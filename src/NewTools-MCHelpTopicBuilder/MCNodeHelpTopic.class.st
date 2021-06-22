Class {
	#name : #MCNodeHelpTopic,
	#superclass : #HelpTopic,
	#instVars : [
		'node'
	],
	#category : #'NewTools-MCHelpTopicBuilder'
}

{ #category : #adding }
MCNodeHelpTopic >> addNode: aNode [

	node addChild: aNode
]

{ #category : #adding }
MCNodeHelpTopic >> addSubtopic: aSubTopic [
	self iconName: #bookIcon.
	super addSubtopic: aSubTopic
]

{ #category : #adding }
MCNodeHelpTopic >> addSubtopic: aHelpTopic with: aLevel [

	aLevel - 1 > 1
		ifTrue: [ 
			self subtopics isEmpty
				ifTrue: [ self addSubtopic: aHelpTopic ]
				ifFalse: [ self subtopics last addSubtopic: aHelpTopic with: aLevel - 1 ] ]
		ifFalse: [ self addSubtopic: aHelpTopic ]
]

{ #category : #initialize }
MCNodeHelpTopic >> initialize [ 

	super initialize.
	node := MicRootBlock new.
	self iconName: #pageIcon
]

{ #category : #acccessing }
MCNodeHelpTopic >> node [
	^ node
]

{ #category : #setting }
MCNodeHelpTopic >> subtopics: aCollection [
	self iconName: #bookIcon.
	super subtopics: aCollection
]
