"
The textComposer inherite from TopicBuilderVisitor but it unused in MDTopicBuilder. 
"
Class {
	#name : #MDTopicBuilder,
	#superclass : #TopicBuilderVisitor,
	#category : #'NewTools-HelpTopicBuilder'
}

{ #category : #'visiting-document' }
MDTopicBuilder >> visitAll: aCollection [
	| collection |
	contents := OrderedCollection new.
	collection := aCollection collect: [ :each | 
		each class = PRHeader 
			ifTrue: [ self nodesListAdd: contents. 
				contents := OrderedCollection new. self visit: each ] 
			ifFalse: [ contents add: each ]
		].
	nodesList add: contents.
	^ collection

	
]
