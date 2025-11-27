Class {
	#name : 'TsfLoggerTest',
	#superclass : 'TestCase',
	#instVars : [
		'logger',
		'memoryAppender'
	],
	#category : 'TSF-Logger-Tests-Core',
	#package : 'TSF-Logger-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
TsfLoggerTest >> setUp [
	super setUp.

	memoryAppender := TsfMemoryAppender new.
	logger := TsfLogger new.
	logger clearAppenders. "Standard Transcript entfernen"
	logger addAppender: memoryAppender.

]

{ #category : 'tests' }
TsfLoggerTest >> testAppenderManagement [

	self assert: logger appenders size equals: 1.
	logger removeAppender: memoryAppender.
	self assert: logger appenders isEmpty.
]

{ #category : 'tests' }
TsfLoggerTest >> testBlockEvaluationPerformance [
	"Prüfen, ob Blöcke NUR ausgeführt werden, wenn das Level passt"
	| wasEvaluated |
	
	wasEvaluated := false.
	
	logger level: #ERROR.
	
	"Info ist unterhalb von Error, Block darf NICHT ausgeführt werden"
	logger info: [ wasEvaluated := true. 'Teure Berechnung' ].
	
	self deny: wasEvaluated description: 'Block wurde ausgeführt, obwohl Level zu niedrig war!'.
	
	"Jetzt testen wir den positiven Fall"
	logger error: [ wasEvaluated := true. 'Fehler' ].
	self assert: wasEvaluated description: 'Block wurde nicht ausgeführt, obwohl Level passte.'
]

{ #category : 'tests' }
TsfLoggerTest >> testLogLevelFiltering [
	"Prüfen, ob Level eingehalten werden"
	logger level: #INFO.
	
	logger info: 'Info Message'.
	logger debug: 'Debug Message'. "Sollte ignoriert werden"
	logger error: 'Error Message'.
	
	self assert: memoryAppender logs size equals: 2.
	self assert: (memoryAppender logs first includesSubstring: 'Info Message').
	self assert: (memoryAppender logs last includesSubstring: 'Error Message').

]
