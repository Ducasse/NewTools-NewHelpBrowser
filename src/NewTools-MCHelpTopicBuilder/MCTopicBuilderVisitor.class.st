Class {
	#name : #MCTopicBuilderVisitor,
	#superclass : #MicrodownVisitor,
	#instVars : [
		'contents',
		'helpTopics',
		'nodesList'
	],
	#classInstVars : [
		'helpCache'
	],
	#category : #'NewTools-MCHelpTopicBuilder'
}

{ #category : #accessing }
MCTopicBuilderVisitor >> addSubtopicsNodes: aSubtopicsCollection [

	aSubtopicsCollection do: [ :each | 
		nodesList first do: [ :node | each addNode: node ].
		nodesList removeFirst.
		self addSubtopicsNodes: each subtopics ]
]

{ #category : #'visiting-document' }
MCTopicBuilderVisitor >> helpTopicClass [

	^ MCNodeHelpTopic
]

{ #category : #initialization }
MCTopicBuilderVisitor >> initialize [ 
	
	super initialize.
	helpTopics := OrderedCollection new.
	nodesList := LinkedList new.
]

{ #category : #accessing }
MCTopicBuilderVisitor >> nodesList [

	^ nodesList 
]

{ #category : #adding }
MCTopicBuilderVisitor >> nodesListAdd: anObject [

	nodesList add: anObject
]

{ #category : #accessing }
MCTopicBuilderVisitor >> rootTopics [
	^ helpTopics
]

{ #category : #visiting }
MCTopicBuilderVisitor >> start: anObject [
	self visitAll: anObject children.
	nodesList removeFirst.
	helpTopics do: [ :each | 
		nodesList first do: [ :node | each addNode: node ].
		nodesList removeFirst.
		self addSubtopicsNodes: each subtopics ]
	
	
]

{ #category : #visiting }
MCTopicBuilderVisitor >> visit: anObject [
	^ anObject accept: self
]

{ #category : #'visiting-document' }
MCTopicBuilderVisitor >> visitAll: aCollection [
	| collection |
	contents := OrderedCollection new.
	collection := aCollection collect: [ :each | 
		              each class = MicHeaderBlock 
							  ifTrue: [ 
			              		self nodesListAdd: contents.
			              		contents := OrderedCollection new.
			              		self visit: each ].
		              contents add: each ].
	self nodesList add: contents.
	^ collection
]

{ #category : #'visiting-document' }
MCTopicBuilderVisitor >> visitHeader: anObject [

	anObject level > 1
		ifTrue: [ 
			helpTopics last
				addSubtopic: (self helpTopicClass named: anObject header capitalized)
				with: anObject level ]
		ifFalse: [ 
			helpTopics add:
				(self helpTopicClass named: anObject header capitalized) ]
]
