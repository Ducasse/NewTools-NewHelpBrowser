Class {
	#name : #TopicBuilderVisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'filesystem',
		'visitor'
	],
	#category : #TopicBuilderVisitorTest
}

{ #category : #resources }
TopicBuilderVisitorTest class >> spFileContentsMoreSections [

	^ '# Section 1
blabla1
# Section 2
blabla2
'
]

{ #category : #resources }
TopicBuilderVisitorTest class >> spFileContentsOneSection [

	^ '# Section 1	
_blabla_
blabla'

]

{ #category : #resources }
TopicBuilderVisitorTest class >> spFileContentsWithMoreSubSection [

	^ '# Section 1
blabla1
## Section 2
blabla2
## Section 3
blabla3'
]

{ #category : #resources }
TopicBuilderVisitorTest class >> spFileContentsWithOneSubSection [

	^ '# Section 1
blabla1
## Section 2
blabla2'
]

{ #category : #resources }
TopicBuilderVisitorTest class >> spFileName [

	^ 'test.md'
]

{ #category : #running }
TopicBuilderVisitorTest >> setUp [
	super setUp.
	filesystem := FileSystem memory.
	visitor := TopicBuilderVisitor new.
	
]

{ #category : #tests }
TopicBuilderVisitorTest >> testTopicBuilderWithMoreSections [

	| file |
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | 
		stream nextPutAll: self class spFileContentsMoreSections ].
	self visitFile: file.
	self assert: (visitor rootTopic at: 2) title equals: 'Section 2'.
	self
		assert: (visitor rootTopic at: 2) contents asString
		equals: Character cr asString , 'blabla2' , Character cr asString
]

{ #category : #tests }
TopicBuilderVisitorTest >> testTopicBuilderWithMoreSubSection [

	| file |
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | 
			stream nextPutAll: self class spFileContentsWithMoreSubSection ].
	self visitFile: file.
	self
		assert: ((visitor rootTopic at: 1) subtopics at: 2) title
		equals: 'Section 3'.
	self
		assert:
		((visitor rootTopic at: 1) subtopics at: 2) contents asString
		equals: Character cr asString , 'blabla3' , Character cr asString.
	self assert: visitor rootTopic size equals: 1
]

{ #category : #tests }
TopicBuilderVisitorTest >> testTopicBuilderWithOneSection [

	| file text |
	text := '
blabla
blabla
'.
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | 
		stream nextPutAll: self class spFileContentsOneSection ].
	self visitFile: file.
	self assert: (visitor rootTopic at: 1) title equals: 'Section 1'.
	self assert: (visitor rootTopic at: 1) contents asString equals: text.
	self assert: visitor rootTopic size equals: 1
]

{ #category : #tests }
TopicBuilderVisitorTest >> testTopicBuilderWithOneSubSection [

	| file |
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | 
			stream nextPutAll: self class spFileContentsWithOneSubSection ].
	self visitFile: file.
	self
		assert: ((visitor rootTopic at: 1) subtopics at: 1) title
		equals: 'Section 2'.
	self
		assert:
		((visitor rootTopic at: 1) subtopics at: 1) contents asString
		equals: Character cr asString , 'blabla2' , Character cr asString.
	self assert: visitor rootTopic size equals: 1
]

{ #category : #tests }
TopicBuilderVisitorTest >> visitFile: file [

	visitor start: (MicroDownParser parse: file) asPillar
]
