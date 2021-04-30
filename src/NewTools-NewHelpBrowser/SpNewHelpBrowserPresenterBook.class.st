Class {
	#name : #SpNewHelpBrowserPresenterBook,
	#superclass : #SpNewHelpBrowserPresenter,
	#category : #'NewTools-NewHelpBrowser'
}

{ #category : #utils }
SpNewHelpBrowserPresenterBook >> topicsFromFileSystem: aFileOrFolder [

	| visitor subTopic sorted |
	aFileOrFolder isFile ifTrue: [ 
		aFileOrFolder extension = 'mic' ifTrue: [ 
			visitor := self helpTopicVisitor new.
			visitor start: (MicroDownParser parse: aFileOrFolder) asPillar.
			^ visitor rootTopics ] ].

	subTopic := OrderedCollection new.
	sorted := SortedCollection sortBlock: [ :a :b | 
		          a basename >= b basename ].
	sorted addAll: (aFileOrFolder children select: [ :e | 
			 e isDirectory or: [ e extension = 'mic' ] ]).


	sorted do: [ :fileOrFolder | 
		subTopic addAll: (self topicsFromFileSystem: fileOrFolder) ].
	^ subTopic
]

{ #category : #utils }
SpNewHelpBrowserPresenterBook >> topicsFromSystem: aFileOrFolder [

	| topic |
	topic := HelpTopic named: aFileOrFolder basenameWithoutExtension.
	(self topicsFromFileSystem: aFileOrFolder) do: [ :each | 
		topic addSubtopic: each ].
	self rootTopic: topic
]
