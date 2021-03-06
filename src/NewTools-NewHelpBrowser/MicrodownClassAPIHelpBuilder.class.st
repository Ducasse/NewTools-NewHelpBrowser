"
A builder to build the API Help for a class. 
The builder can be parametised as follows: 
-	addMethods:	<Boolean> When true the builder will include method help
-	addSubclasses:	 <Boolean> When true the builder will recursively go through and add subclasses
-	subclassesAsSeparateTopic: <Boolean> When true subclasses are managed as separated topics. 


"
Class {
	#name : #MicrodownClassAPIHelpBuilder,
	#superclass : #HelpBuilder,
	#instVars : [
		'addSubclasses',
		'addMethods',
		'subclassesAsSeparateTopic',
		'addMethodsWithoutComment',
		'iconBuilder'
	],
	#category : #'NewTools-NewHelpBrowser'
}

{ #category : #building }
MicrodownClassAPIHelpBuilder class >> buildHierarchicalHelpTopicFrom: aClass withSubclasses: aBoolean withMethods: anotherBoolean [
	"Start building from the given class"
	
	^ self new 
		addSubclasses: aBoolean;
		addMethods: anotherBoolean;
		rootToBuildFrom: aClass;
		build;
		topicToBuild 
]

{ #category : #building }
MicrodownClassAPIHelpBuilder class >> buildHierarchicalHelpTopicFrom: aClass withSubclasses: aBoolean withMethods: anotherBoolean withTopicSubclasses: aNewBoolean [
	"Start building from the given class"
	
	^ self new 
		addSubclasses: aBoolean;
		addMethods: anotherBoolean;
		subclassesAsSeparateTopic: aNewBoolean;
		rootToBuildFrom: aClass;
		build;
		topicToBuild 
]

{ #category : #building }
MicrodownClassAPIHelpBuilder class >> sample [
	<sampleInstance>
	
	SpNewHelpBrowserPresenter openOn: (self buildHierarchicalHelpTopicFrom: SpPresenter withSubclasses: false withMethods: true)
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> addMethods [
	^ addMethods
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> addMethods: anObject [
	addMethods := anObject
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> addMethodsWithoutComment [
	^ addMethodsWithoutComment
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> addMethodsWithoutComment: anObject [
	addMethodsWithoutComment := anObject
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> addSubclasses [
	^ addSubclasses
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> addSubclasses: anObject [
	addSubclasses := anObject
]

{ #category : #building }
MicrodownClassAPIHelpBuilder >> build [

	| builder |
	builder := MicroDownParser builder.
	topicToBuild := self topicClass named: rootToBuildFrom name with: self iconBuilder.
	rootToBuildFrom
		buildMicroDownUsing: builder
		withComment: rootToBuildFrom comment.
	topicToBuild addNode: (MicroDownParser new parse: builder contents) asPillar.

	addMethods ifTrue: [ self buildSubnodesForMethods ].
	addSubclasses ifTrue: [ self buildSubnodesForSubclasses ]
]

{ #category : #'private building' }
MicrodownClassAPIHelpBuilder >> buildMethodTopicsOn: topic for: aClass [

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
	
	topic contents: stream contents.
	
	
]

{ #category : #'private building' }
MicrodownClassAPIHelpBuilder >> buildSubclassTopicFor: aSubclass [
	 
	^ self class new
			rootToBuildFrom: aSubclass;
			addSubclasses: addSubclasses;
			addMethods: addMethods;
			subclassesAsSeparateTopic: subclassesAsSeparateTopic;
			build;
			topicToBuild 
	 
]

{ #category : #'private building' }
MicrodownClassAPIHelpBuilder >> buildSubnodesForMethods [
	| instanceSide classSide |
	instanceSide := self topicClass named: 'Instance side'.
	classSide := self topicClass named: 'Class side'.
	topicToBuild
		addSubtopic: instanceSide;
		addSubtopic: classSide.
	self buildMethodTopicsOn: instanceSide for: rootToBuildFrom.
	self buildMethodTopicsOn: classSide for: rootToBuildFrom class
]

{ #category : #'private building' }
MicrodownClassAPIHelpBuilder >> buildSubnodesForSubclasses [
	| topic |
	rootToBuildFrom subclasses isEmpty
		ifTrue: [ ^ self ].
	iconBuilder buildIcon: topicToBuild.
	topic := subclassesAsSeparateTopic
		ifTrue: [ self topicClass named: 'Subclasses' ]
		ifFalse: [ topicToBuild ].
	rootToBuildFrom subclasses
		do:
			[ :subclass | topic addSubtopic: (self buildSubclassTopicFor: subclass) ].
	topic sortSubtopicsByTitle.
	topicToBuild = topic 	
		ifFalse: [ topicToBuild addSubtopic: topic ]
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> iconBuilder [
	^ iconBuilder
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> iconBuilder: aIconBuilder [
	iconBuilder := aIconBuilder
]

{ #category : #initialization }
MicrodownClassAPIHelpBuilder >> initialize [
	"Initializes the receiver"
	
	super initialize.
	addSubclasses := false.
	addMethods := true.
	subclassesAsSeparateTopic := true.
	addMethodsWithoutComment := true.
	iconBuilder := IconClassBuilder  new
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> subclassesAsSeparateTopic [
	^ subclassesAsSeparateTopic
]

{ #category : #accessing }
MicrodownClassAPIHelpBuilder >> subclassesAsSeparateTopic: anObject [
	subclassesAsSeparateTopic := anObject
]

{ #category : #'private building' }
MicrodownClassAPIHelpBuilder >> topicClass [
	^ PRNodeHelpTopic
]
