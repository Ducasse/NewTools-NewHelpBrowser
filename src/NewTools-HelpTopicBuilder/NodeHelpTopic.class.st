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

{ #category : #initialization }
NodeHelpTopic >> initialize [ 

	super initialize.
	node := PRDocument new
]

{ #category : #accessing }
NodeHelpTopic >> node [
	^ node
]
