Class {
	#name : #TopicBuilderVisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'filesystem',
		'visitor'
	],
	#category : #'NewTools-HelpTopicBuilder-Tests'
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
	visitor := TopicBuilderVisitor new
	
]

{ #category : #tests }
TopicBuilderVisitorTest >> testAddContentsAddContentsInTopic [

	| topics |
	topics := OrderedCollection new.
	topics add: (HelpTopic named: '1');
	add: (HelpTopic named: '2');
	add: (HelpTopic named: '3').
	visitor contentsListAdd: 1;
	contentsListAdd: 2;
	contentsListAdd: 3.
	visitor addContents: topics.
	self assert: topics first contents equals: 1.
	self assert: topics second contents equals: 2.
	self assert: topics third contents equals: 3
]

{ #category : #tests }
TopicBuilderVisitorTest >> testAddContentsAddContentsUseContentsList [

	| topics size |
	topics := OrderedCollection new.
	topics add: (HelpTopic named: '1');
	add: (HelpTopic named: '2');
	add: (HelpTopic named: '3').
	visitor contentsListAdd: 1;
	contentsListAdd: 2;
	contentsListAdd: 3;
	contentsListAdd: 4.
	size := visitor contentsList size.
	visitor addContents: topics.
	self assert: visitor contentsList size equals: size - 3 

]

{ #category : #tests }
TopicBuilderVisitorTest >> testGetContentsListAfterAddObject [

	visitor contentsListAdd: 1.
	visitor contentsListAdd: 2.
	self assert: visitor contentsList size equals: 2.
	self assert: visitor contentsList first equals: 1.
	self assert: visitor contentsList second equals: 2
]

{ #category : #tests }
TopicBuilderVisitorTest >> testGetContentsListAtInitialization [

	self assert: visitor contentsList isEmpty
]

{ #category : #tests }
TopicBuilderVisitorTest >> testTopicBuilderVisitorVisitAllAddInContentsList [

	| file text document |
	text := '# SectionTest
This is a paragraphe'.
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | 
		stream nextPutAll: text ].
	document := (MicroDownParser parse: file) asPillar.
	visitor visitAll: document children.
	self assert: visitor contentsList first asString equals: ''.
	self assert: (visitor contentsList at: 2) asString equals: Character cr asString , 'This is a paragraphe' , Character cr asString 

]

{ #category : #tests }
TopicBuilderVisitorTest >> testTopicBuilderVisitorVisitHeader [

	| file text header |
	text := '# SectionTest
	This is a paragraphe'.
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | 
		stream nextPutAll: text ].
	header := (MicroDownParser parse: file) asPillar children first.
	visitor visitHeader: header.
	self assert: visitor rootTopics first title equals: 'SectionTest'.
	self assert: visitor rootTopics first contents equals: ''

]

{ #category : #tests }
TopicBuilderVisitorTest >> testTopicBuilderVisitorWithMoreSections [

	| file |
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | 
		stream nextPutAll: self class spFileContentsMoreSections ].
	self visitFile: file.
	self assert: (visitor rootTopics at: 2) title equals: 'Section 2'.
	self
		assert: (visitor rootTopics at: 2) contents asString
		equals: Character cr asString , 'blabla2' , Character cr asString.
	self assert: visitor rootTopics size equals: 2.
]

{ #category : #tests }
TopicBuilderVisitorTest >> testTopicBuilderVisitorWithMoreSubSection [

	| file |
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | 
			stream nextPutAll: self class spFileContentsWithMoreSubSection ].
	self visitFile: file.
	self
		assert: ((visitor rootTopics at: 1) subtopics at: 2) title
		equals: 'Section 3'.
	self
		assert:
		((visitor rootTopics at: 1) subtopics at: 2) contents asString
		equals: Character cr asString , 'blabla3' , Character cr asString.
	self assert: visitor rootTopics size equals: 1.
	self assert: visitor rootTopics first subtopics size equals: 2
]

{ #category : #tests }
TopicBuilderVisitorTest >> testTopicBuilderVisitorWithOneSection [

	| file text |
	text := '
blabla
blabla
'.
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | 
		stream nextPutAll: self class spFileContentsOneSection ].
	self visitFile: file.
	self assert: (visitor rootTopics at: 1) title equals: 'Section 1'.
	self assert: (visitor rootTopics at: 1) contents asString equals: text.
	self assert: visitor rootTopics size equals: 1
]

{ #category : #tests }
TopicBuilderVisitorTest >> testTopicBuilderVisitorWithOneSubSection [

	| file |
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | 
			stream nextPutAll: self class spFileContentsWithOneSubSection ].
	self visitFile: file.
	self
		assert: ((visitor rootTopics at: 1) subtopics at: 1) title
		equals: 'Section 2'.
	self
		assert:
		((visitor rootTopics at: 1) subtopics at: 1) contents asString
		equals: Character cr asString , 'blabla2' , Character cr asString.
	self assert: visitor rootTopics size equals: 1.
	self assert: visitor rootTopics first subtopics size equals: 1
]

{ #category : #tests }
TopicBuilderVisitorTest >> visitFile: file [

	visitor start: (MicroDownParser parse: file) asPillar
]
