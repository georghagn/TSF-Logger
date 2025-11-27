Class {
	#name : 'TsfDefaultLogFormatter',
	#superclass : 'TsfLogMessageFormatter',
	#category : 'TSF-Logger-Core',
	#package : 'TSF-Logger',
	#tag : 'Core'
}

{ #category : 'formatting' }
TsfDefaultLogFormatter >> formatMessage: msg tag: tagString [

	"Standardformat: [TAG] message (ohne Timestamp; Timestamp kann hier ergänzt werden)"
	^ '[' , tagString , '] ' , msg
]
