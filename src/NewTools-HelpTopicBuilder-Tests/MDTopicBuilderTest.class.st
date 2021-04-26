Class {
	#name : #MDTopicBuilderTest,
	#superclass : #TopicBuilderVisitorTest,
	#category : #'NewTools-HelpTopicBuilder-Tests'
}

{ #category : #resources }
MDTopicBuilderTest class >> spMoreSectionsWithSomeBlocks [

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
MDTopicBuilderTest class >> spOneSectionWithSomeBlocks [

	^ '# Section 1
This is a test
```
This is a codeblock
```'
]

{ #category : #resources }
MDTopicBuilderTest class >> spOneSectionWithSubSectionWithSomeBlocks [

	^ '# Section 1
This is a test
```
This is a codeblock
```
## SubSection 1
This is a paragraph
```
This is a codeblock
```
'
]

{ #category : #resources }
MDTopicBuilderTest class >> spSectionsWithSubSectionsWithSomeBlocks [

	^ '# Section 1
This is a test
```
This is a codeblock
```
## SubSection 1
This is a paragraph
```
This is a codeblock
```
## SubSection 2
This is a paragraph
```
This is a codeblock
```
This is a paragraphe
# Section 2
This a paragraphe
## SubSection 3
This is a paragraphe
```
This is a codeblock
```'
]

{ #category : #running }
MDTopicBuilderTest >> setUp [
	super setUp.
	visitor := MDTopicBuilder new
]

{ #category : #tests }
MDTopicBuilderTest >> testMDTopicBuilderWithMoreSections [
	| file |
	self skip.
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | stream nextPutAll: self class spMoreSectionsWithSomeBlocks ].
	self visitFile: file.
	self assert: visitor rootTopics first contents size equals: 2.
	self assert: (visitor rootTopics at: 2) contents size equals: 3.
	self assert: visitor rootTopics size equals: 2.
]

{ #category : #tests }
MDTopicBuilderTest >> testMDTopicBuilderWithOneSection [

	| file |
	self skip.
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | 
		stream nextPutAll: self class spOneSectionWithSomeBlocks ].
	self visitFile: file.
	self assert: visitor rootTopics first contents size equals: 2.
	self assert: visitor rootTopics size equals: 1	
]

{ #category : #tests }
MDTopicBuilderTest >> testMDTopicBuilderWithSectionAndSubSection [

	| file |
	self skip.
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | 
		stream nextPutAll: self class spOneSectionWithSubSectionWithSomeBlocks ].
	self visitFile: file.
	self assert: visitor rootTopics first subtopics first contents size equals: 2.
	self assert: visitor rootTopics size equals: 1	
]

{ #category : #tests }
MDTopicBuilderTest >> testMDTopicBuilderWithSectionsAndSubSections [

	| file |
	self skip.
	(file := filesystem workingDirectory / self class spFileName) 
		writeStreamDo: [ :stream | 
		stream nextPutAll: self class spSectionsWithSubSectionsWithSomeBlocks ].
	self visitFile: file.
	self assert: visitor rootTopics first subtopics first contents size equals: 2.
	self assert: (visitor rootTopics first subtopics at: 2) contents size equals: 3.
	self assert: (visitor rootTopics at: 2) subtopics first contents size equals: 2.
	self assert: visitor rootTopics size equals: 2
]
