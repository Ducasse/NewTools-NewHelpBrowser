Class {
	#name : #MDSpNewHelpBrowserPresenterBook,
	#superclass : #MDSpNewHelpBrowserPresenter,
	#category : #'NewTools-MDBookBrowser'
}

{ #category : #utils }
MDSpNewHelpBrowserPresenterBook >> bookChapters: aFolder [

	aFolder children do: [ :each | 
		each extension = 'mic' ifTrue: [ ^ self listOfChapters: each ] ]
]

{ #category : #utils }
MDSpNewHelpBrowserPresenterBook >> createRootTopicFromFolder: aFileOrFolder [

	| topic |
	topic := MDNodeHelpTopic named: aFileOrFolder basenameWithoutExtension.
	(self createTopicsFromFileOrFolder: aFileOrFolder) do: [ :each | 
		topic addSubtopic: each ].
	self rootTopic: topic
]

{ #category : #utils }
MDSpNewHelpBrowserPresenterBook >> createTopicsFromFileOrFolder: aFileOrFolder [

	| subTopic sorted |
	(aFileOrFolder isFile and: aFileOrFolder extension = 'mic')
		ifTrue: [ ^ self createTopicsFromFile: aFileOrFolder ].

	subTopic := OrderedCollection new.
	sorted := self sortFileAndFolder: aFileOrFolder.
	sorted do: [ :fileOrFolder | 
		subTopic addAll: (self createTopicsFromFileOrFolder: fileOrFolder) ].
	^ subTopic
]

{ #category : #utils }
MDSpNewHelpBrowserPresenterBook >> indexVisitorClass [

	^ MDIndexVisitor
]

{ #category : #utils }
MDSpNewHelpBrowserPresenterBook >> listOfChapters: aFile [

	| mic visitor |
	mic := self parser new parse: aFile contents.
	visitor := self indexVisitorClass new.
	mic accept: visitor.
	^ visitor indexList
]
