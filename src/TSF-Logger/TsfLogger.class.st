Class {
	#name : 'TsfLogger',
	#superclass : 'Object',
	#instVars : [
		'level',
		'appenders'
	],
	#classInstVars : [
		'defaultLogger'
	],
	#category : 'TSF-Logger-Core',
	#package : 'TSF-Logger',
	#tag : 'Core'
}

{ #category : 'private - initialization' }
TsfLogger class >> debugLevel [

	^ 10.
]

{ #category : 'accessing' }
TsfLogger class >> default [

    ^ defaultLogger ifNil: [ 
        defaultLogger := self new 
            addAppender: TsfTranscriptAppender new;
            yourself 
    ]
]

{ #category : 'accessing' }
TsfLogger class >> default: aLogger [

    defaultLogger := aLogger
]

{ #category : 'error handling' }
TsfLogger class >> error: aStringOrBlock [

    self default error: aStringOrBlock
]

{ #category : 'private - initialization' }
TsfLogger class >> errorLevel [

	^ 40.
]

{ #category : 'private - initialization' }
TsfLogger class >> fatalLevel [

	^ 50.
]

{ #category : 'accessing - structure variables' }
TsfLogger class >> info: aStringOrBlock [

    self default info: aStringOrBlock
]

{ #category : 'private - initialization' }
TsfLogger class >> infoLevel [

	^ 20.
]

{ #category : 'instance creation' }
TsfLogger class >> new [
	"Erzeugt Logger mit Transcript Appender als Default"
	
	^ super new 
		addAppender: (TsfTranscriptAppender new);
		yourself
]

{ #category : 'private - initialization' }
TsfLogger class >> warnLevel [

	^ 30.
]

{ #category : 'adding' }
TsfLogger >> addAppender: anAppender [

	appenders at: (anAppender name asSymbol) put: anAppender.

]

{ #category : 'accessing' }
TsfLogger >> appenders [

	^ appenders
]

{ #category : 'cleanup' }
TsfLogger >> clearAppenders [

	appenders removeAll.
	
	^ self
]

{ #category : 'logging' }
TsfLogger >> debug: aMsgOrBlock [

	(level <= self class debugLevel) ifTrue: [ 
		self logInternalWithTag: 'DEBUG' message: aMsgOrBlock value 
	].

	^ self
]

{ #category : 'error handling' }
TsfLogger >> error: aMsgOrBlock [

	(level <= self class errorLevel) ifTrue: [ 
		self logInternalWithTag: 'ERROR' message: aMsgOrBlock value 
	].
	^ self
]

{ #category : 'logging' }
TsfLogger >> fatal: aMsgOrBlock [

	(level <= self class fatalLevel) ifTrue: [ 
		self logInternalWithTag: 'FATAL' message: aMsgOrBlock value 
	].
	^ self
]

{ #category : 'formatting' }
TsfLogger >> formatMessage: msg tag: tagString [

	"Standardformat: [TAG] message (ohne Timestamp; Timestamp kann hier ergänzt werden)"
	^ '[' , tagString , '] ' , msg
]

{ #category : 'initialization' }
TsfLogger >> formatter: aFormatter [
	"Helper: Setzt den Formatter für ALLE aktuellen Appender (Convenience)"
	
	appenders do: [ :each | each formatter: aFormatter ].

]

{ #category : 'running' }
TsfLogger >> handleError: aString [
	"handle single message - override oder setze target via block"
	"Default: schreibe in Transcript (oder delegiere an inner-appender)"

	Transcript show: aString; cr. 

]

{ #category : 'logging' }
TsfLogger >> info: aMsgOrBlock [

	(level <= self class infoLevel) ifTrue: [ 
		self logInternalWithTag: 'INFO' message: aMsgOrBlock value 
	].
	^ self
]

{ #category : 'initialization' }
TsfLogger >> initialize [

	super initialize.
	
	level := self class infoLevel.
	appenders := IdentityDictionary new.

	^ self

]

{ #category : 'accessing' }
TsfLogger >> level: aLevelSymbol [
	"aLevelSymbol kann sein: [ #DEBUG | #INFO | #WARN | #ERROR | #FATAL ]"
	| selector val |
	
	selector := (aLevelSymbol asString asLowercase , 'Level') asSymbol.
	[ 
		val := (self class perform: selector). 
		level := val .
	] onErrorDo: [ 
		self handleError: MessageNotUnderstood .
	] .

	
]

{ #category : 'private - logging' }
TsfLogger >> logInternalWithTag: tagString message: msg [
	"Wir delegieren jetzt die Rohdaten an die Appender,
	 damit jeder Appender selbst entscheiden kann, wie er formatiert."
	
	appenders valuesDo: [:each |
		[ each recordTag: tagString message: msg ] 
			on: Error 
			do: [:ex | self handleError: 'Appender Error: ', ex description ]
	].
]

{ #category : 'removing' }
TsfLogger >> removeAppender: anAppender [  

	appenders removeKey: (anAppender name asSymbol) ifAbsent: [] .

	^ self
]

{ #category : 'logging' }
TsfLogger >> warn: aMsgOrBlock [
	
	(level <= self class warnLevel) ifTrue: [ 
		self logInternalWithTag: 'WARN' message: aMsgOrBlock value 
	].
	^ self
]
