Class {
	#name : #MDNodeHelpTopic,
	#superclass : #HelpTopic,
	#instVars : [
		'node'
	],
	#category : #'NewTools-MDHelpTopicBuilder'
}

{ #category : #adding }
MDNodeHelpTopic >> addNode: aNode [

	node addChild: aNode
]

{ #category : #adding }
MDNodeHelpTopic >> addSubtopic: aSubTopic [
	self iconName: #bookIcon.
	super addSubtopic: aSubTopic
]

{ #category : #adding }
MDNodeHelpTopic >> addSubtopic: aHelpTopic with: aLevel [

	aLevel - 1 > 1
		ifTrue: [ 
			self subtopics isEmpty
				ifTrue: [ self addSubtopic: aHelpTopic ]
				ifFalse: [ self subtopics last addSubtopic: aHelpTopic with: aLevel - 1 ] ]
		ifFalse: [ self addSubtopic: aHelpTopic ]
]

{ #category : #initialize }
MDNodeHelpTopic >> initialize [ 

	super initialize.
	node := MicRootBlock new.
	self iconName: #pageIcon
]

{ #category : #acccessing }
MDNodeHelpTopic >> node [
	^ node
]

{ #category : #setting }
MDNodeHelpTopic >> subtopics: aCollection [
	self iconName: #bookIcon.
	super subtopics: aCollection
]
