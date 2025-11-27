Class {
	#name : 'TsfFileAppenderTest',
	#superclass : 'TestCase',
	#instVars : [
		'fileAppender',
		'fileRef'
	],
	#category : 'TSF-Logger-Tests-Appender',
	#package : 'TSF-Logger-Tests',
	#tag : 'Appender'
}

{ #category : 'running' }
TsfFileAppenderTest >> setUp [

	super setUp.
	
	fileRef := FileSystem memory / 'test.log'. "Wir nutzen FileSystem memory wenn möglich, sonst disk"
	"Falls du kein MemoryFileSystem installiert hast, nimm:"
	"fileRef := FileSystem disk workingDirectory / 'tsf_test_temp.log'."
	
	fileRef ensureDelete.
	fileAppender := TsfFileAppender newOn: fileRef.
]

{ #category : 'running' }
TsfFileAppenderTest >> tearDown [

	fileRef ensureDelete.
	
	super tearDown
]

{ #category : 'tests' }
TsfFileAppenderTest >> testFileCreationAndWriting [

	self deny: fileRef exists.
	
	"Wir simulieren den Aufruf vom Logger (RecordTag -> Record)"
	fileAppender recordTag: 'TEST' message: 'Hallo Datei'.
	
	self assert: fileRef exists.
	self assert: (fileRef contents includesSubstring: 'Hallo Datei').
	self assert: (fileRef contents includesSubstring: '[TEST]').
]
