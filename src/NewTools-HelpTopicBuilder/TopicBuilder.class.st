Class {
	#name : #TopicBuilder,
	#superclass : #TopicBuilderVisitor,
	#category : #'NewTools-HelpTopicBuilder'
}

{ #category : #'visiting-document' }
TopicBuilder >> visitAll: aCollection [
	| collection |
	contents := OrderedCollection new.
	collection := aCollection collect: [ :each | 
		each class = PRHeader 
			ifTrue: [ contentsList add: contents. 
				contents := OrderedCollection new. self visit: each ] 
			ifFalse: [ contents add: each ]
		].
	contentsList add: contents.
	^ collection

	
]
