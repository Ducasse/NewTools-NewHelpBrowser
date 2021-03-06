"
When I visit a header I create a NodeHelpTopic.
When I visit something else I add it to the nodelist of the current node (help topic).
"
Class {
	#name : #MDTopicBuilderVisitor,
	#superclass : #MicrodownVisitor,
	#instVars : [
		'contents',
		'helpTopics',
		'nodesList'
	],
	#classInstVars : [
		'helpCache'
	],
	#category : #'NewTools-MDHelpTopicBuilder'
}

{ #category : #adding }
MDTopicBuilderVisitor >> addSubtopicsNodes: aSubtopicsCollection [

	aSubtopicsCollection do: [ :each | 
		nodesList first do: [ :node | each addNode: node ].
		nodesList removeFirst.
		self addSubtopicsNodes: each subtopics ]
]

{ #category : #'visiting-document' }
MDTopicBuilderVisitor >> helpTopicClass [

	^ MDNodeHelpTopic
]

{ #category : #initialization }
MDTopicBuilderVisitor >> initialize [ 
	
	super initialize.
	helpTopics := OrderedCollection new.
	nodesList := LinkedList new.
]

{ #category : #accessing }
MDTopicBuilderVisitor >> nodesList [

	^ nodesList 
]

{ #category : #adding }
MDTopicBuilderVisitor >> nodesListAdd: anObject [

	nodesList add: anObject
]

{ #category : #accessing }
MDTopicBuilderVisitor >> rootTopics [
	^ helpTopics
]

{ #category : #visiting }
MDTopicBuilderVisitor >> start: anObject [
	"The normal case is to have
	
	#header 
		ljklj
		jlkklk
		jlkl
		
	#header 2
		fgddfg	
		gjhgj
		
	Now it may be the case where we have some text before a header and we should not lose it. 
	"
	
	self visitAll: anObject children.
	nodesList removeFirst.
	self addSubtopicsNodes: helpTopics 
	
	
]

{ #category : #'visiting-document' }
MDTopicBuilderVisitor >> visitAll: aCollection [

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
MDTopicBuilderVisitor >> visitHeader: anObject [

	(anObject level > 1 and: helpTopics isNotEmpty)
		ifTrue: [ 
			helpTopics last
				addSubtopic: (self helpTopicClass named: anObject header capitalized)
				with: anObject level ]
		ifFalse: [ 
			helpTopics add:
				(self helpTopicClass named: anObject header capitalized) ]
]
