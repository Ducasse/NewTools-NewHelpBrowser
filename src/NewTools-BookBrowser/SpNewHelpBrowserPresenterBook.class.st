Class {
	#name : #SpNewHelpBrowserPresenterBook,
	#superclass : #SpNewHelpBrowserPresenter,
	#category : #'NewTools-BookBrowser'
}

{ #category : #utils }
SpNewHelpBrowserPresenterBook >> topicsFromFileSystem: aFileOrFolder [

	| visitor subTopic sorted |
	aFileOrFolder isFile ifTrue: [ 
		aFileOrFolder extension = 'mic' ifTrue: [ 
			visitor := self helpTopicVisitorClass new.
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
SpNewHelpBrowserPresenterBook >> topicsFromFileSystem: aFileOrFolder visitor: aVistor [
	| subTopic sorted |
	aFileOrFolder isFile ifTrue: [ 
		aFileOrFolder extension = 'mic' ifTrue: [ 
			aVistor start: (MicroDownParser parse: aFileOrFolder) asPillar.
			^ aVistor rootTopics ] ].
	
	self writePillarToMic: aFileOrFolder.
	subTopic := OrderedCollection new.
	sorted := SortedCollection sortBlock: [ :a :b | 
		          a basename >= b basename ].
	sorted addAll: (aFileOrFolder children select: [ :e | 
			 e isDirectory or: [ e extension = 'mic' ] ]).


	sorted do: [ :fileOrFolder | 
		subTopic addAll: (self topicsFromFileSystem: fileOrFolder visitor: aVistor) ].
	^ subTopic
]

{ #category : #utils }
SpNewHelpBrowserPresenterBook >> topicsFromSystem: aBookFolder [

	| topic visitor title header |
	visitor := self helpTopicVisitorClass new.
	title := (STON fromString: aBookFolder / 'pillar.conf' contents)at: #title.
	visitor rootTopics add: (NodeHelpTopic named: title).
	header := PRHeader new.
	header level: 1.
	header setChildren: { PRText new text: title }.
	visitor contents add: header.
	topic := (self topicsFromFileSystem: aBookFolder / 'Chapters' visitor: visitor) first.
	self rootTopic: topic
]

{ #category : #writing }
SpNewHelpBrowserPresenterBook >> writePillarToMic: aFolder [
	aFolder children do:[ :each |
			each extension = 'pillar' 
				ifTrue: [ | contents |
						contents := PRPillarParser parse: each contents.
						aFolder / (each basenameWithoutExtension , '.mic') writeStreamDo: [ :stream |
							stream nextPutAll: (PRMicrodownWriter new start: contents) contents ] ] ]
]
