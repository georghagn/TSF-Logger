Class {
	#name : 'TsfFileAppender',
	#superclass : 'TsfLogAppender',
	#instVars : [
		'fileRef'
	],
	#category : 'TSF-Logger-Appender',
	#package : 'TSF-Logger',
	#tag : 'Appender'
}

{ #category : 'initialization' }
TsfFileAppender class >> defaultFileRef [

	^ FileSystem disk workingDirectory / 'tsfLogger.log'.
]

{ #category : 'instance creation' }
TsfFileAppender class >> newOn: aFileRef [

	^ self new 
		fileRef: aFileRef;
		yourself
]

{ #category : 'logging' }
TsfFileAppender >> clearLog [

	fileRef ensureDelete
]

{ #category : 'accessing' }
TsfFileAppender >> fileRef: aFileRef [

	fileRef := aFileRef
]

{ #category : 'initialization' }
TsfFileAppender >> initialize [ 

	super initialize.
	
	"Default: Logdatei im Working Directory"
	fileRef := FileSystem disk workingDirectory / 'tsfLogger.log'.
	
	"Wichtig: Wir setzen hier explizit einen Default Formatter, 
	 damit wir keine Lazy Init im Getter brauchen."
	formatter := TsfDefaultLogFormatter new.

]

{ #category : 'actions api' }
TsfFileAppender >> record: aFormattedString [
	"Hier kommt jetzt der BEREITS FORMATIERTE String an.
	 Strategie: Open-Write-Close (für Rotator-Kompatibilität)"
	
	fileRef ensureCreateFile.
	
	"writeStreamDo schließt den Stream automatisch nach dem Block"
	fileRef writeStreamDo: [ :stream | 
		stream setToEnd.
		stream nextPutAll: aFormattedString.
		stream cr. 
	].
]
