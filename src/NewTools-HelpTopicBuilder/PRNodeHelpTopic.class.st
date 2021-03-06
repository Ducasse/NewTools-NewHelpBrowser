"
The difference with my superclass (HelpTopic) is that I have an extra node which refers to a PRDocument 
containing the pillar nodes of the document displayed on the right.

Ideally this class should be merged in its superclass.
This way we can rerender the text when needed. 


"
Class {
	#name : #PRNodeHelpTopic,
	#superclass : #HelpTopic,
	#instVars : [
		'node',
		'iconBuilder'
	],
	#category : #'NewTools-HelpTopicBuilder'
}

{ #category : #'instance creation' }
PRNodeHelpTopic class >> named: aName with: anIconBuilder [
	| topic |
	topic := self named: aName.
	topic iconBuilder: anIconBuilder.
	topic iconBuilder buildIcon: topic.
	^ topic
]

{ #category : #adding }
PRNodeHelpTopic >> addNode: aNode [

	node add: aNode
]

{ #category : #accessing }
PRNodeHelpTopic >> addSubtopic: aSubTopic [
	iconBuilder buildIcon: self.
	super addSubtopic: aSubTopic
]

{ #category : #adding }
PRNodeHelpTopic >> addSubtopic: aHelpTopic with: aLevel [

	(aLevel  - 1 > 1 and: self subtopics isNotEmpty)
		ifTrue: [ self subtopics last addSubtopic: aHelpTopic with: aLevel - 1 ] 
		ifFalse: [ self addSubtopic: aHelpTopic ]
]

{ #category : #accessing }
PRNodeHelpTopic >> iconBuilder [
	^ iconBuilder
]

{ #category : #accessing }
PRNodeHelpTopic >> iconBuilder: aIconBuilder [
	iconBuilder := aIconBuilder
]

{ #category : #initialization }
PRNodeHelpTopic >> initialize [ 

	super initialize.
	iconBuilder := IconBookBuilder new.
	node := PRDocument new.
	iconBuilder buildPageIcon: self
]

{ #category : #accessing }
PRNodeHelpTopic >> node [
	^ node
]

{ #category : #accessing }
PRNodeHelpTopic >> subtopics: aCollection [
	iconBuilder buildIcon: self.
	super subtopics: aCollection
]
