Class {
	#name : #TopicBuilderVisitor,
	#superclass : #PRVisitor,
	#instVars : [
		'actualLevel',
		'contents',
		'helpTopics',
		'nodesList'
	],
	#category : #'NewTools-HelpTopicBuilder'
}

{ #category : #'instance creation' }
TopicBuilderVisitor class >> with: aActualTopic [
	
	| visitor |
	visitor := self new.
	visitor actualLevel: aActualTopic.
	^ visitor 
]

{ #category : #accessing }
TopicBuilderVisitor >> actualLevel [
	^ actualLevel
]

{ #category : #accessing }
TopicBuilderVisitor >> actualLevel: aActualLevel [

	actualLevel := aActualLevel
]

{ #category : #accessing }
TopicBuilderVisitor >> addSubtopicsNodes: aSubtopicsCollection [
	
	aSubtopicsCollection ifNotNil: [ aSubtopicsCollection do:
		[ :each | nodesList first do: [ :node | each addNode: node ].
		nodesList removeFirst.
		self addSubtopicsNodes: each subtopics ] ]
]

{ #category : #initialization }
TopicBuilderVisitor >> initialize [ 
	
	super initialize.
	helpTopics := OrderedCollection new.
	nodesList := LinkedList new.
	actualLevel := 1.
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
			ifTrue: [ self nodesListAdd: contents. 
				contents := OrderedCollection new. self visit: each ] 
			ifFalse: [ contents add: each ]
		].
	self nodesList add: contents.
	^ collection

	
]

{ #category : #'visiting-document' }
TopicBuilderVisitor >> visitHeader: anObject [

	anObject level > actualLevel 	
		ifTrue: 
			[ helpTopics last addSubtopic:  (((self class with: anObject level)  visitHeader: anObject) rootTopics at: 1) ]	
		 ifFalse: 
			[ actualLevel := anObject level.
			helpTopics add: (NodeHelpTopic named: anObject text) ]
]
