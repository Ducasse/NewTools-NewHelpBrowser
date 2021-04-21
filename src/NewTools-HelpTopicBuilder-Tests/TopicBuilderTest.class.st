Class {
	#name : #TopicBuilderTest,
	#superclass : #TopicBuilderVisitorTest,
	#category : #'NewTools-HelpTopicBuilder-Tests'
}

{ #category : #resources }
TopicBuilderTest class >> spMoreSectionsWithSomeBlocks [

	^ '# Section 1
This is a first section
```
This is a codeblock
```
# Section 2
This is a second section
```
This is a codeblock
```
This is a second paragraphe
'
]

{ #category : #resources }
TopicBuilderTest class >> spOneSectionWithSomeBlocks [

	^ '# Section 1
This is a test
```
This is a codeblock
```'
]

{ #category : #running }
TopicBuilderTest >> setUp [
	super setUp.
	visitor := TopicBuilder new
]

{ #category : #tests }
TopicBuilderTest >> testTopicBuilderWithMoreSections [

	| file |
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | stream nextPutAll: self class spMoreSectionsWithSomeBlocks ].
	self visitFile: file.
	self assert: visitor rootTopics first contents size equals: 2.
	self assert: (visitor rootTopics at: 2) contents size equals: 3.
	self assert: visitor rootTopics size equals: 2.
]

{ #category : #tests }
TopicBuilderTest >> testTopicBuilderWithOneSection [

	| file |
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | 
		stream nextPutAll: self class spOneSectionWithSomeBlocks ].
	self visitFile: file.
	self assert: visitor rootTopics first contents size equals: 2.
	self assert: visitor rootTopics size equals: 1	
]
