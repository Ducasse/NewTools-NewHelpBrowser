Class {
	#name : #MCSpNewHelpBrowserPresenterBook,
	#superclass : #MCSpNewHelpBrowserPresenter,
	#category : #'NewTools-MCBookBrowser'
}

{ #category : #utils }
MCSpNewHelpBrowserPresenterBook >> createRootTopicFromFolder: aFileOrFolder [

	| topic |
	topic := HelpTopic named: aFileOrFolder basenameWithoutExtension.
	(self createTopicsFromFileOrFolder: aFileOrFolder) do: [ :each | 
		topic addSubtopic: each ].
	self rootTopic: topic
]

{ #category : #utils }
MCSpNewHelpBrowserPresenterBook >> createTopicsFromFileOrFolder: aFileOrFolder [

	| visitor subTopic sorted |
	aFileOrFolder isFile ifTrue: [ 
		aFileOrFolder extension = 'mic' ifTrue: [ 
			visitor := self helpTopicVisitor new.
			visitor start: (MicroDownParser new parse: aFileOrFolder contents).
			^ visitor rootTopics ] ].

	subTopic := OrderedCollection new.
	sorted := SortedCollection sortBlock: [ :a :b | 
		          a basename >= b basename ].
	sorted addAll: (aFileOrFolder children select: [ :e | 
			 e isDirectory or: [ e extension = 'mic' ] ]).


	sorted do: [ :fileOrFolder | 
		subTopic addAll: (self createTopicsFromFileOrFolder: fileOrFolder) ].
	^ subTopic
]
