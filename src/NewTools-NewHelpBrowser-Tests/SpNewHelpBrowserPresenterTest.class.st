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
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserGotTopicsPerDefault [

	| topic browser |
	browser := SpNewHelpBrowserPresenter new.
	topic := browser helpTopic.
	self 
		assert: topic title equals: 'Help' 

]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserGotTopicsThatISpecify [

	| topic browser |
	browser := SpNewHelpBrowserPresenter new.
	browser helpTopic: (HelpTopic named: 'foo').
	topic := browser helpTopic.
	self 
		assert: topic title equals: 'foo' 

]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserPresenterOpenADirectory [

	| directory browser |
	directory := filesystem workingDirectory / self class spDirectoryName.
	filesystem createDirectory: self class spDirectoryName.
	browser := SpNewHelpBrowserPresenter new.
	browser topicsFromFileSystem: directory.
	
	self assert: browser helpTopic title equals: directory basenameWithoutExtension
	

]
