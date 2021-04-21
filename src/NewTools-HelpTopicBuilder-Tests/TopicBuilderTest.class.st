Class {
	#name : #TopicBuilderTest,
	#superclass : #TopicBuilderVisitorTest,
	#category : #'NewTools-HelpTopicBuilder-Tests'
}

{ #category : #resources }
TopicBuilderTest class >> spOneSectionWithSomeBlock [

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
TopicBuilderTest >> testTopicBuilderWithOneSection [

	| file |
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | 
		stream nextPutAll: self class spOneSectionWithSomeBlock ].
	self visitFile: file.
	self assert: visitor rootTopics first contents size equals: 2.
	self assert: visitor rootTopics size equals: 1	
]
