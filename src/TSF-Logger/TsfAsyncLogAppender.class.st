Class {
	#name : 'TsfAsyncLogAppender',
	#superclass : 'TsfLogAppender',
	#instVars : [
		'targetAppender',
		'queue',
		'workerProcess'
	],
	#category : 'TSF-Logger-Appender',
	#package : 'TSF-Logger',
	#tag : 'Appender'
}

{ #category : 'instance creation' }
TsfAsyncLogAppender class >> decorate: anAppender [
	"Erzeugt einen Async Wrapper um einen existierenden Appender"
	
	^ self new
		targetAppender: anAppender;
		formatter: anAppender formatter; "Wir übernehmen den Formatter des Originals"
		yourself
]

{ #category : 'logging' }
TsfAsyncLogAppender >> clearLog [

	targetAppender clearLog
]

{ #category : 'accessing' }
TsfAsyncLogAppender >> flush [
	| doneSemaphore |

	doneSemaphore := Semaphore new.
	
	"Wir schieben den 'Signal'-Block in die Queue.
	 Er reiht sich HINTER alle noch wartenden Log-Einträge ein."
	queue nextPut: [ doneSemaphore signal ].
	
	"Der Main-Thread wartet hier, bis der Worker beim Block angekommen ist."
	doneSemaphore wait.
	
	"Wenn wir hier sind, ist die Queue garantiert leer."
	^ self
]

{ #category : 'initialization' }
TsfAsyncLogAppender >> initialize [

	super initialize.
	
	queue := SharedQueue new. 
	self startWorker
]

{ #category : 'actions api' }
TsfAsyncLogAppender >> record: aFormattedString [
	"Das ist der 'Hot Path'. Er muss extrem schnell sein.
	 Wir schieben den String nur in die Queue und kehren sofort zurück."
	
	queue nextPut: aFormattedString.
	
]

{ #category : 'private - actions' }
TsfAsyncLogAppender >> startWorker [
	"Startet den Hintergrundprozess, der die Queue abarbeitet."
	
	self stopWorker.
	
	workerProcess := [
		[ true ] whileTrue: [
			| entry |
			entry := queue next. "Wartet hier..."
			
			"TRICK: Wir prüfen, ob es ein Block ist (für flush) oder ein String (Log)"
			entry isBlock 
				ifTrue: [ 
					"Es ist ein Befehl (z.B. vom flush), einfach ausführen"
					entry value 
				]
				ifFalse: [ 
					"Es ist ein Log-Eintrag, ab zum Target damit"
					[ targetAppender record: entry ] 
						on: Error 
						do: [ :ex | Transcript show: 'AsyncLog Error: '; show: ex description; cr ]
				].
		]
	] forkAt: Processor userBackgroundPriority named: 'TSF Logger Worker'.

]

{ #category : 'private - actions' }
TsfAsyncLogAppender >> stopWorker [

	workerProcess ifNotNil: [ 
		"Erst alles wegschreiben..."
		self flush.

		"Dann Prozess beenden"
		workerProcess terminate.
		workerProcess := nil.
	].
]

{ #category : 'accessing' }
TsfAsyncLogAppender >> targetAppender: anAppender [

	targetAppender := anAppender.
	
	"Wir übernehmen den Namen des Targets für Debugging-Zwecke"
	name := 'Async -> ', anAppender name.
]
