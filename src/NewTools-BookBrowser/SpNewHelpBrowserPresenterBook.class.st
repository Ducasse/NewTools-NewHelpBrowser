Class {
	#name : #SpNewHelpBrowserPresenterBook,
	#superclass : #SpNewHelpBrowserPresenter,
	#category : #'NewTools-BookBrowser'
}

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
