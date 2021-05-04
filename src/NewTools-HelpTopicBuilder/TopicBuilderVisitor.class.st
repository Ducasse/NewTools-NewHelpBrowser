"
```
pillarParser := PRPillarParser new.
writer := PRMicrodownWriter new.
doc := pillarParser parse: (FileSystem workingDirectory / 'withStyle.pillar') contents.
d := writer start: doc; contents.
t := FileSystem disk createDirectory: 'Book'.
directory :=  FileSystem disk workingDirectory / 'Book'.
file := directory / 'fd1.md'.
file writeStreamDo: [ :st | st nextPutAll: d ].
browser := SpNewHelpBrowserPresenter new.
rootTopic := (browser topicsFromSystem: directory) rootTopic.
SpNewHelpBrowserPresenter openOn: rootTopic
```

```
TopicBuilderVisitor internalizeHelpFrom: 'doc'.
SpNewHelpBrowserPresenter openOn: TopicBuilderVisitor helpCache
```
"
Class {
	#name : #TopicBuilderVisitor,
	#superclass : #PRVisitor,
	#instVars : [
		'contents',
		'helpTopics',
		'nodesList'
	],
	#classInstVars : [
		'helpCache'
	],
	#category : #'NewTools-HelpTopicBuilder'
}

{ #category : #accessing }
TopicBuilderVisitor >> addSubtopicsNodes: aSubtopicsCollection [

	aSubtopicsCollection do: [ :each | 
		nodesList first do: [ :node | each addNode: node ].
		nodesList removeFirst.
		self addSubtopicsNodes: each subtopics ]
]

{ #category : #initialization }
TopicBuilderVisitor >> initialize [ 
	
	super initialize.
	helpTopics := OrderedCollection new.
	nodesList := LinkedList new.
]

{ #category : #accessing }
TopicBuilderVisitor >> nodesList [

	^ nodesList 
]

{ #category : #adding }
TopicBuilderVisitor >> nodesListAdd: anObject [

	nodesList add: anObject
]

{ #category : #accessing }
TopicBuilderVisitor >> rootTopics [
	^ helpTopics
]

{ #category : #visiting }
TopicBuilderVisitor >> start: anObject [
	self visit: anObject.
	nodesList removeFirst.
	helpTopics do: [ :each | 
		nodesList first do: [ :node | each addNode: node ].
		nodesList removeFirst.
		self addSubtopicsNodes: each subtopics ]
	
	
]

{ #category : #visiting }
TopicBuilderVisitor >> visit: anObject [
	^ anObject accept: self
]

{ #category : #'visiting-document' }
TopicBuilderVisitor >> visitAll: aCollection [

	| collection |
	contents := OrderedCollection new.
	collection := aCollection collect: [ :each | 
		              each class = PRHeader 
							  ifTrue: [ 
			              		self nodesListAdd: contents.
			              		contents := OrderedCollection new.
			              		self visit: each ].
		              contents add: each ].
	self nodesList add: contents.
	^ collection
]

{ #category : #'visiting-document' }
TopicBuilderVisitor >> visitHeader: anObject [
		anObject level > 1 
		ifTrue: 
			[ helpTopics last  addSubtopic: (NodeHelpTopic named: anObject text capitalized) with: anObject level ] 
		ifFalse: 
			[ helpTopics add: (NodeHelpTopic named: anObject text capitalized) ]
]
