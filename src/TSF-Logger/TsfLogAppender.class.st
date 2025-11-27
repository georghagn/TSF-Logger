Class {
	#name : 'TsfLogAppender',
	#superclass : 'Object',
	#instVars : [
		'name',
		'formatter'
	],
	#category : 'TSF-Logger-Appender',
	#package : 'TSF-Logger',
	#tag : 'Appender'
}

{ #category : 'logging' }
TsfLogAppender >> clearLog [

	self subclassResponsibility 
]

{ #category : 'accessing' }
TsfLogAppender >> formatter [

	^ formatter ifNil: [ formatter := TsfDefaultLogFormatter new ]
]

{ #category : 'accessing' }
TsfLogAppender >> formatter: aFormatter [

	formatter := aFormatter
]

{ #category : 'initialization' }
TsfLogAppender >> initialize [ 

	super initialize.
	
	name := self className 
]

{ #category : 'accessing' }
TsfLogAppender >> name [

	^ name
]

{ #category : 'accessing' }
TsfLogAppender >> name: anObject [

	name := anObject
]

{ #category : 'actions api' }
TsfLogAppender >> record: aMsg [

	self subclassResponsibility 
]
