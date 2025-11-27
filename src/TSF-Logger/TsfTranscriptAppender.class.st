Class {
	#name : 'TsfTranscriptAppender',
	#superclass : 'TsfLogAppender',
	#category : 'TSF-Logger-Appender',
	#package : 'TSF-Logger',
	#tag : 'Appender'
}

{ #category : 'actions api' }
TsfTranscriptAppender >> record: aRecord [

	Transcript show: aRecord; cr; flush.
]
