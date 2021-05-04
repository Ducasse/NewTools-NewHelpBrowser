"
The difference with the HelpTopic it's we have an extra node which refers to a PRDoucment containing the pillar nodes of the document displayed on the right.
"
Class {
	#name : #NodeHelpTopic,
	#superclass : #HelpTopic,
	#instVars : [
		'node'
	],
	#category : #'NewTools-HelpTopicBuilder'
}

{ #category : #adding }
NodeHelpTopic >> addNode: aNode [

	node add: aNode
]

{ #category : #accessing }
NodeHelpTopic >> addSubtopic: aSubTopic [
	self iconName: #bookIcon.
	super addSubtopic: aSubTopic
]

{ #category : #adding }
NodeHelpTopic >> addSubtopic: aHelpTopic with: aLevel [

	aLevel - 1 > 1
		ifTrue: [ 
			self subtopics isEmpty
				ifTrue: [ self addSubtopic: aHelpTopic ]
				ifFalse: [ self subtopics last addSubtopic: aHelpTopic with: aLevel - 1 ] ]
		ifFalse: [ self addSubtopic: aHelpTopic ]
]

{ #category : #initialization }
NodeHelpTopic >> initialize [ 

	super initialize.
	node := PRDocument new.
	self iconName: #pageIcon
]

{ #category : #accessing }
NodeHelpTopic >> node [
	^ node
]

{ #category : #accessing }
NodeHelpTopic >> subtopics: aCollection [
	self iconName: #bookIcon.
	super subtopics: aCollection
]
