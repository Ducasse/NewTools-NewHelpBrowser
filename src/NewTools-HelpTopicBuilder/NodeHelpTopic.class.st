"
The difference with my superclass (HelpTopic) is that I have an extra node which refers to a PRDocument 
containing the pillar nodes of the document displayed on the right.

Ideally this class should be merged in its superclass.
This way we can rerender the text when needed. 


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
	self iconInitialize.
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

{ #category : #'as yet unclassified' }
NodeHelpTopic >> iconInitialize [
	
	icon = (Smalltalk ui icons iconNamed: #pageIcon)
		ifTrue: [ self iconName: #bookIcon ].

	icon 
		ifNil: [ self iconName: #pageIcon ]
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
	self iconInitialize.
	super subtopics: aCollection
]

{ #category : #accessing }
NodeHelpTopic >> title: anObject [
	anObject asClassIfPresent: [ self iconName: #classIcon ].
	super title: anObject
]
