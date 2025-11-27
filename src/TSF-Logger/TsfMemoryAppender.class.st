"
I am only for testing purposes. Do not use in Production
"
Class {
	#name : 'TsfMemoryAppender',
	#superclass : 'TsfLogAppender',
	#instVars : [
		'logs'
	],
	#category : 'TSF-Logger-Appender',
	#package : 'TSF-Logger',
	#tag : 'Appender'
}

{ #category : 'logging' }
TsfMemoryAppender >> clearLog [


]

{ #category : 'initialization' }
TsfMemoryAppender >> initialize [

	super initialize.
	logs := OrderedCollection new.
]

{ #category : 'accessing' }
TsfMemoryAppender >> logs [

	^ logs
]

{ #category : 'actions api' }
TsfMemoryAppender >> record: aFormattedString [

	logs add: aFormattedString
]
