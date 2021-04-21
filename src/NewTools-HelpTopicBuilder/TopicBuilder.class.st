Class {
	#name : #TopicBuilder,
	#superclass : #TopicBuilderVisitor,
	#category : #'NewTools-HelpTopicBuilder'
}

{ #category : #'visiting-document' }
TopicBuilder >> visitAll: aCollection [

	contents := OrderedCollection new.
	^ aCollection collect: [ :each | 
		each class = PRHeader 
			ifTrue: [ contentsList add: contents. 
				contents := OrderedCollection new. self visit: each ] 
			ifFalse: [ contents add: each ]
		]

	
]
