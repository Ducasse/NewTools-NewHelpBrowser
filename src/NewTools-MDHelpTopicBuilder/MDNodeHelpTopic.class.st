Class {
	#name : #MDNodeHelpTopic,
	#superclass : #HelpTopic,
	#instVars : [
		'node',
		'iconBuilder'
	],
	#category : #'NewTools-MDHelpTopicBuilder'
}

{ #category : #adding }
MDNodeHelpTopic >> addNode: aNode [

	node addChild: aNode
]

{ #category : #adding }
MDNodeHelpTopic >> addSubtopic: aSubTopic [

	iconBuilder buildIcon: self.
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

{ #category : #accessing }
MDNodeHelpTopic >> iconBuilder [ 
	^ iconBuilder
]

{ #category : #adding }
MDNodeHelpTopic >> iconBuilder: aIconBuilder [

	iconBuilder := aIconBuilder
]

{ #category : #initialize }
MDNodeHelpTopic >> initialize [

	super initialize.
	iconBuilder := IconBookBuilder new.
	node := MicRootBlock new.
	iconBuilder buildPageIcon: self
]

{ #category : #acccessing }
MDNodeHelpTopic >> node [
	^ node
]

{ #category : #setting }
MDNodeHelpTopic >> subtopics: aCollection [

	iconBuilder buildIcon: self.
	super subtopics: aCollection
]
