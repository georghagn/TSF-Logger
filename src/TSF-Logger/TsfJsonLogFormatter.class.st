Class {
	#name : 'TsfJsonLogFormatter',
	#superclass : 'TsfLogMessageFormatter',
	#category : 'TSF-Logger-Core',
	#package : 'TSF-Logger',
	#tag : 'Core'
}

{ #category : 'formatting' }
TsfJsonLogFormatter >> formatMessage: msg tag: tagString [
	| dict |
	
	dict := Dictionary new.
	dict 
		at: 'level' put: tagString;
		at: 'unixTS' put: DateAndTime now asUnixTime ;
		at: 'message' put: msg.
	
	^ STONJSON toString: dict
]
