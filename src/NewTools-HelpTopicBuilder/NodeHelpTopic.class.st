Class {
	#name : #NodeHelpTopic,
	#superclass : #HelpTopic,
	#instVars : [
		'node'
	],
	#category : #'NewTools-HelpTopicBuilder'
}

{ #category : #initialization }
NodeHelpTopic >> addNode: aNode [

	node add: aNode
]

{ #category : #adding }
NodeHelpTopic >> addSubtopic: aHelpTopic with: aLevel [
	aLevel - 1 > 1 ifTrue: 
		[ self subtopics isEmpty ifTrue: [ self addSubtopic: aHelpTopic  ] 
			ifFalse:  [self subtopics last addSubtopic: aHelpTopic  with: (aLevel  - 1) ] ]
	ifFalse: 
		[ self addSubtopic: aHelpTopic ]
]

{ #category : #initialization }
NodeHelpTopic >> initialize [ 

	super initialize.
	node := PRDocument new
]

{ #category : #accessing }
NodeHelpTopic >> node [
	^ node
]
