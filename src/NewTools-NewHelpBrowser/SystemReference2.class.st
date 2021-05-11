Class {
	#name : #SystemReference2,
	#superclass : #Object,
	#classVars : [
		'ClassAPIHelpBuilderClass'
	],
	#category : #'NewTools-NewHelpBrowser-Utilities'
}

{ #category : #'help topic creation' }
SystemReference2 class >> all [
	"SpNewHelpBrowserPresenter openOn: self all"
	
 ^ self classAPIHelpBuilderClass new
		rootToBuildFrom: Object;
		addSubclasses: true;
		addMethods: true;
		subclassesAsSeparateTopic: false;
		build;
		topicToBuild 
	 
		 
]

{ #category : #'help topic creation' }
SystemReference2 class >> asHelpTopic [
	
	^self hierarchyFor: Object 
	 
		 
]

{ #category : #'help topic creation' }
SystemReference2 class >> classAPIHelpBuilderClass [

	ClassAPIHelpBuilderClass ifNil: [ ClassAPIHelpBuilderClass := MicrodownClassAPIHelpBuilder ].
	^ ClassAPIHelpBuilderClass
]

{ #category : #'help topic creation' }
SystemReference2 class >> classAPIHelpBuilderClass: aClass [
	ClassAPIHelpBuilderClass := aClass
	 
		 
]

{ #category : #'help topic creation' }
SystemReference2 class >> forClass: aClass [

	| root topic |
	root := self helpTopicClass named:
		        'System reference for ' , aClass name.
	topic := self classAPIHelpBuilderClass buildHelpTopicFrom: aClass.
	root addSubtopic: topic.
	^ root
]

{ #category : #'help topic creation' }
SystemReference2 class >> helpTopicClass [

	^ NodeHelpTopic
]

{ #category : #'help topic creation' }
SystemReference2 class >> hierarchyFor: aClass [

	| root topic |
	root := self helpTopicClass named:
		        'System reference for ' , aClass name.
	topic := self classAPIHelpBuilderClass new
		         rootToBuildFrom: aClass;
		         addSubclasses: true;
		         addMethods: false;
		         subclassesAsSeparateTopic: false;
		         build;
		         topicToBuild.
	root addSubtopic: topic.
	^ root
]

{ #category : #'help topic creation' }
SystemReference2 class >> hierarchyWithMethodsFor: aClass [
	 
	|root topic |
	root := self helpTopicClass named: 'System reference for ', aClass name.
	topic := (self classAPIHelpBuilderClass new)
					rootToBuildFrom: aClass;
					addSubclasses: true;
					addMethods: true;
					subclassesAsSeparateTopic: true;
					build;
					topicToBuild.
	root addSubtopic: topic.
	^root				
]
