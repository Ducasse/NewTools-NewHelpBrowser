Class {
	#name : #TopicBuilderVisitor,
	#superclass : #PRVisitor,
	#instVars : [
		'helpTopic',
		'actualLevel',
		'contentsList',
		'textComposer',
		'contents'
	],
	#category : #'NewTools-HelpTopicBuilder'
}

{ #category : #'instance creation' }
TopicBuilderVisitor class >> with: aActualTopic [
	
	| visitor |
	visitor := self new.
	visitor actualLevel: aActualTopic.
	^ visitor 
]

{ #category : #accessing }
TopicBuilderVisitor >> actualLevel: aActualLevel [

	actualLevel := aActualLevel
]

{ #category : #accessing }
TopicBuilderVisitor >> addContents: aSubtopicsCollection [
	
	aSubtopicsCollection ifNotNil: [ aSubtopicsCollection do: 
		[ :each | each contents: contentsList first.
		contentsList removeFirst.
		self addContents: each subtopics ] ]
]

{ #category : #accessing }
TopicBuilderVisitor >> contentsList [

	^ contentsList 
]

{ #category : #adding }
TopicBuilderVisitor >> contentsListAdd: anObject [

	contentsList add: anObject
]

{ #category : #initialization }
TopicBuilderVisitor >> initialize [ 
	
	super initialize.
	helpTopic := OrderedCollection new.
	contentsList := LinkedList new.
	actualLevel := 1.
]

{ #category : #accessing }
TopicBuilderVisitor >> rootTopics [
	^ helpTopic
]

{ #category : #visiting }
TopicBuilderVisitor >> start: anObject [
	self visit: anObject.
	contentsList removeFirst.
	helpTopic do: [ :each | 
		each contents: contentsList first.
		contentsList removeFirst.
		self addContents: each subtopics ]
	
	
]

{ #category : #accessing }
TopicBuilderVisitor >> textComposer [

	^ textComposer ifNil: [ textComposer := PRRichTextComposer new ].
]

{ #category : #accessing }
TopicBuilderVisitor >> textComposer: aPRVisitorClass [

	textComposer := aPRVisitorClass new
]

{ #category : #visiting }
TopicBuilderVisitor >> visit: anObject [
	^ anObject accept: self
]

{ #category : #'visiting-document' }
TopicBuilderVisitor >> visitAll: aCollection [
	| collection |
	contents := Text new.
	collection := aCollection collect: [ :each | 
		each class = PRHeader 
			ifTrue: [ self contentsListAdd: contents. 
				contents := Text new. self visit: each ] 
			ifFalse: [ contents := contents , (self textComposer start: each) ]
		].
	self contentsList add: contents.
	^ collection

	
]

{ #category : #'visiting-document' }
TopicBuilderVisitor >> visitHeader: anObject [

	anObject level > actualLevel 	
		ifTrue: 
			[ (helpTopic at: helpTopic size) addSubtopic:  (((self class with: anObject level)  visitHeader: anObject) rootTopics at: 1) ]	
		 ifFalse: 
			[ actualLevel := (anObject level).
			helpTopic add: (HelpTopic named: anObject text) ]
]
