Class {
	#name : #MDMicrodownClassAPIHelpBuilder,
	#superclass : #HelpBuilder,
	#instVars : [
		'addSubclasses',
		'addMethods',
		'subclassesAsSeparateTopic',
		'addMethodsWithoutComment'
	],
	#category : #'NewTools-MDNewHelpBrowser'
}

{ #category : #building }
MDMicrodownClassAPIHelpBuilder class >> buildHierarchicalHelpTopicFrom: aClass withSubclasses: aBoolean withMethods: anotherBoolean [
	"Start building from the given class"
	
	^ self new 
		addSubclasses: aBoolean;
		addMethods: anotherBoolean;
		rootToBuildFrom: aClass;
		build;
		topicToBuild 
]

{ #category : #building }
MDMicrodownClassAPIHelpBuilder class >> sample [
	<sampleInstance>
	
	MDSpNewHelpBrowserPresenter openOn: (self buildHierarchicalHelpTopicFrom: SpPresenter withSubclasses: true withMethods: true)
]

{ #category : #accessing }
MDMicrodownClassAPIHelpBuilder >> addMethods [
	^ addMethods
]

{ #category : #accessing }
MDMicrodownClassAPIHelpBuilder >> addMethods: anObject [
	addMethods := anObject
]

{ #category : #accessing }
MDMicrodownClassAPIHelpBuilder >> addMethodsWithoutComment [
	^ addMethodsWithoutComment
]

{ #category : #accessing }
MDMicrodownClassAPIHelpBuilder >> addMethodsWithoutComment: anObject [
	addMethodsWithoutComment := anObject
]

{ #category : #accessing }
MDMicrodownClassAPIHelpBuilder >> addSubclasses [
	^ addSubclasses
]

{ #category : #accessing }
MDMicrodownClassAPIHelpBuilder >> addSubclasses: anObject [
	addSubclasses := anObject
]

{ #category : #building }
MDMicrodownClassAPIHelpBuilder >> build [
	| builder |
	builder := MicroDownParser builder.
	topicToBuild := MDNodeHelpTopic named: rootToBuildFrom name.
	topicToBuild iconName: #pageIcon.
	"does not work anymore since we are storing nodes"
	rootToBuildFrom buildMicroDownUsing: builder withComment: rootToBuildFrom comment.
	topicToBuild addNode: (MicroDownParser new parse: builder contents).
		
	addMethods
		ifTrue: [ self buildSubnodesForMethods ].
	addSubclasses
		ifTrue: [ self buildSubnodesForSubclasses ]
]

{ #category : #'private building' }
MDMicrodownClassAPIHelpBuilder >> buildMethodTopicsOn: topic for: aClass [

	|stream methodComment|
	stream := String new writeStream.
	aClass selectors asSortedCollection do: [:selector | 
		methodComment := (aClass>>selector) comment.
		addMethodsWithoutComment | methodComment notNil ifTrue: [ 
			stream 
				nextPutAll: '`';
				nextPutAll: aClass name;
				nextPutAll: '>>#';
				nextPutAll: selector asString;
				nextPutAll: '`';
				cr.		

		methodComment ifNil: [ methodComment := 'Method has no comment.' ].
		stream nextPutAll: '_"'; nextPutAll: methodComment; nextPutAll: '"_';cr;cr ] ].
	
	topic addNode: (MicroDownParser new parse: stream contents).
	
	
]

{ #category : #'private building' }
MDMicrodownClassAPIHelpBuilder >> buildSubclassTopicFor: aSubclass [
	 
	^ self class new
			rootToBuildFrom: aSubclass;
			addSubclasses: addSubclasses;
			addMethods: addMethods;
			subclassesAsSeparateTopic: subclassesAsSeparateTopic;
			build;
			topicToBuild 
	 
]

{ #category : #'private building' }
MDMicrodownClassAPIHelpBuilder >> buildSubnodesForMethods [
	| instanceSide classSide |
	instanceSide := MDNodeHelpTopic named: 'Instance side'.
	classSide := MDNodeHelpTopic named: 'Class side'.
	topicToBuild iconName: #bookIcon.
	topicToBuild
		addSubtopic: instanceSide;
		addSubtopic: classSide.
	self buildMethodTopicsOn: instanceSide for: rootToBuildFrom.
	self buildMethodTopicsOn: classSide for: rootToBuildFrom class
]

{ #category : #'private building' }
MDMicrodownClassAPIHelpBuilder >> buildSubnodesForSubclasses [
	| topic |
	rootToBuildFrom subclasses isEmpty
		ifTrue: [ ^ self ].
	topicToBuild iconName: #bookIcon.
	topic := subclassesAsSeparateTopic
		ifTrue: [ topicToBuild addSubtopic: (HelpTopic named: 'Subclasses') ]
		ifFalse: [ topicToBuild ].
	rootToBuildFrom subclasses
		do:
			[ :subclass | topic addSubtopic: (self buildSubclassTopicFor: subclass) ].
	topic sortSubtopicsByTitle
]

{ #category : #initialization }
MDMicrodownClassAPIHelpBuilder >> initialize [
	"Initializes the receiver"
	
	super initialize.
	addSubclasses := false.
	addMethods := true.
	subclassesAsSeparateTopic := true.
	addMethodsWithoutComment := true.
]

{ #category : #accessing }
MDMicrodownClassAPIHelpBuilder >> subclassesAsSeparateTopic [
	^ subclassesAsSeparateTopic
]

{ #category : #accessing }
MDMicrodownClassAPIHelpBuilder >> subclassesAsSeparateTopic: anObject [
	subclassesAsSeparateTopic := anObject
]
