Class {
	#name : #SpNewHelpBrowserPresenterBook,
	#superclass : #SpNewHelpBrowserPresenter,
	#category : #'NewTools-BookBrowser'
}

{ #category : #accessing }
SpNewHelpBrowserPresenterBook >> bookChapters: aFolder [

	aFolder children do: [ :each | 
		each extension = 'pillar' ifTrue: [ ^ self listOfChapters: each ] ]
]

{ #category : #utils }
SpNewHelpBrowserPresenterBook >> createRootTopicFromFolder: aFileOrFolder [

	| topic |
	topic := HelpTopic named: aFileOrFolder basenameWithoutExtension.
	(self createTopicsFromFileOrFolder: aFileOrFolder) do: [ :each | 
		topic addSubtopic: each ].
	self rootTopic: topic
]

{ #category : #utils }
SpNewHelpBrowserPresenterBook >> createTopicsFromFileOrFolder: aFileOrFolder [

	| subTopic sorted |
	(aFileOrFolder isFile and: aFileOrFolder extension = 'mic')
		ifTrue: [ self createTopicsFromFile: aFileOrFolder ].

	subTopic := OrderedCollection new.
	sorted := self sortFileAndFolder: aFileOrFolder.
	sorted do: [ :fileOrFolder | 
		subTopic addAll: (self createTopicsFromFileOrFolder: fileOrFolder) ].
	^ subTopic
]

{ #category : #'as yet unclassified' }
SpNewHelpBrowserPresenterBook >> indexVisitorClass [

	^ IndexVisitor
]

{ #category : #'as yet unclassified' }
SpNewHelpBrowserPresenterBook >> listOfChapters: aFile [

	| pillar visitor |
	pillar := PRPillarParser new parse: aFile contents.
	visitor := self indexVisitorClass new.
	pillar accept: visitor.
	^ visitor indexList
]
