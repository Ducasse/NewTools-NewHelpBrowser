Class {
	#name : #SpNewHelpBrowserPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'filesystem'
	],
	#category : #'NewTools-NewHelpBrowser-Tests'
}

{ #category : #resources }
SpNewHelpBrowserPresenterTest class >> spDirectoryName [

	^ 'tests'
]

{ #category : #resources }
SpNewHelpBrowserPresenterTest class >> spFileContentsOneSection [

	^ '# Section 1
This is a test'
]

{ #category : #resources }
SpNewHelpBrowserPresenterTest class >> spFileName [

	^ 'test.md'
]

{ #category : #initialization }
SpNewHelpBrowserPresenterTest >> setUp [
	super setUp.
	filesystem := FileSystem memory
]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserPresenterOpenADirectory [

	| directory topic |
	[ directory := filesystem workingDirectory / self class spDirectoryName.
	filesystem createDirectory: self class spDirectoryName.
		
	topic := SpHelpBrowserPresenter topicFileSystem: directory.
	self assert: directory exists.
	self assert: topic title equals: directory basenameWithoutExtension ]
		ensure: [ filesystem workingDirectory ensureDeleteAllChildren ]

]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserPresenterOpenADirectoryWithSubFile [

	| directory subfile topic|
	self skip.
	[ directory := filesystem workingDirectory / self class spDirectoryName.
	filesystem createDirectory: self class spDirectoryName.
	(subfile := directory / self class spFileName) 
		writeStreamDo: [ :stream | stream nextPutAll: self class spFileContentsOneSection ].
	
	topic := SpHelpBrowserPresenter topicFileSystem: directory.
	self assert: directory exists.
	self assert: (topic subtopics at: 1) title equals: subfile basenameWithoutExtension ]
		ensure: [ filesystem workingDirectory ensureDeleteAllChildren ]

]
