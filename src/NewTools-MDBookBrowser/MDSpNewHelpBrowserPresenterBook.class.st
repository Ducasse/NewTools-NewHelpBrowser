"
```
	MDSpNewHelpBrowserPresenterBook openOnHelpFolder: FileSystem workingDirectory / 'Booklet-Smacc'
```
"
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

{ #category : #'as yet unclassified' }
MDSpNewHelpBrowserPresenterBook >> createFirstPageTopic: aConfFile [

	| dict topic node |
	dict := (STONReader on: aConfFile readStream) next.
	topic := MDNodeHelpTopic named: (dict at: 'title').
	node := MicHeaderBlock new addChild:
		        (MicTextBlock new substring: (dict at: 'title')).
	node level: 1.
	topic addNode: node.
	node := MicParagraphBlock new addChild:
		        (MicTextBlock new substring: (dict at: 'attribution')).
	topic addNode: node.
	node := MicParagraphBlock new addChild:
		        (MicTextBlock new substring: (dict at: 'series')).
	topic addNode: node.
	^ topic
]

{ #category : #utils }
MDSpNewHelpBrowserPresenterBook >> createRootTopicFromFolder: aFileOrFolder [

	| topic chapters |
	aFileOrFolder children do: [ :each | 
		each extension = 'conf' ifTrue: [ 
			topic := self createFirstPageTopic: each ] ].
	chapters := self bookChapters: aFileOrFolder.
	chapters do: [ :each | 
		(self createTopicsFromFileOrFolder:
			 FileSystem workingDirectory / aFileOrFolder pathString / each) 
			do: [ :e | topic addSubtopic: e ] ].
	self rootTopic: topic
]

{ #category : #utils }
MDSpNewHelpBrowserPresenterBook >> createTopicsFromFileOrFolder: aFileOrFolder [

	| subTopic sorted |
	(aFileOrFolder isFile and: aFileOrFolder extension = 'mic')
		ifTrue: [ ^ self createTopicsFromFile: aFileOrFolder ].

	subTopic := OrderedCollection new.
	aFileOrFolder isDirectory ifTrue: [ 
		sorted := self sortFileAndFolder: aFileOrFolder.
		sorted do: [ :fileOrFolder | 
			subTopic addAll: (self createTopicsFromFileOrFolder: fileOrFolder) ]. ].
	
	^ subTopic
]

{ #category : #utils }
MDSpNewHelpBrowserPresenterBook >> indexVisitorClass [

	^ MDIndexVisitor
]

{ #category : #utils }
MDSpNewHelpBrowserPresenterBook >> listOfChapters: aFile [

	| mic visitor |
	mic := self parserClass new parse: aFile contents.
	visitor := self indexVisitorClass new.
	mic accept: visitor.
	^ visitor indexList
]
