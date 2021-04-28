Class {
	#name : #SpNewHelpBrowserPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'filesystem',
		'window'
	],
	#category : #'NewTools-NewHelpBrowser-Tests'
}

{ #category : #resources }
SpNewHelpBrowserPresenterTest class >> spDirectoryName [

	^ 'tests'
]

{ #category : #resources }
SpNewHelpBrowserPresenterTest class >> spFd1 [

	^ '# Chapitre Bar
Un paragraphe sur Bar

## 1
_Un paragraphe 1_

### 2
Un paragraphe 2

# Chapitre Foo

un paragraphe sur Foo'
]

{ #category : #resources }
SpNewHelpBrowserPresenterTest class >> spFd2 [

	^ '# Chapitre 3
Un paragraphe sur 3'
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

{ #category : #'tests - interaction' }
SpNewHelpBrowserPresenterTest >> tearDown [ 

	window ifNotNil: [ window close ].
	super tearDown.
]

{ #category : #'tests - interaction' }
SpNewHelpBrowserPresenterTest >> testClickOnFirstTopicExpandTree [

	| browser |
	self skip.
	"waiting for new release of Spec20 with fix/Expand integrated."
	browser := SpNewHelpBrowserPresenter new.
	window := browser openWithSpec. 
	
	browser topicList expandPath: #(1 2).

	self 
		assert: (browser topicList isExpanded: #(1 2))

]

{ #category : #'tests - interaction' }
SpNewHelpBrowserPresenterTest >> testOpenIsWorkingSmokeTest [

	| browser |
	browser := SpNewHelpBrowserPresenter new.
	window := browser openWithSpec. 
	

]

{ #category : #'tests - interaction' }
SpNewHelpBrowserPresenterTest >> testOpenIsWorkingSmokeTestOnSpecificHelp [

	| browser topic |
	topic := HelpTopic named: 'Test'.
	browser := SpNewHelpBrowserPresenter on: topic.
	self assert: browser rootTopic equals: topic.
	window := browser openWithSpec. 
	

]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserGotHelpTopicVisitorPerDefault [

	| visitor browser |
	browser := SpNewHelpBrowserPresenter new.
	visitor := browser helpTopicVisitor.
	self 
		assert: visitor equals: TopicBuilderVisitor

]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserGotHelpTopicVisitorThatISpecify [

	| visitor browser |
	browser := SpNewHelpBrowserPresenter new.
	browser helpTopicVisitor: MDTopicBuilder.
	visitor := browser helpTopicVisitor.
	self 
		assert: visitor equals: MDTopicBuilder 

]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserGotRootTopicThatISpecify [

	| topic browser |
	browser := SpNewHelpBrowserPresenter new.
	topic := HelpTopic named: 'Test'.
	browser rootTopic: topic.
	self 
		assert: browser rootTopic equals: topic 

]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserGotTopicsPerDefault [

	| topic browser |
	browser := SpNewHelpBrowserPresenter new.
	topic := browser rootTopic.
	self 
		assert: topic title equals: 'Help' 

]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserGotTopicsThatISpecify [

	| topic browser |
	browser := SpNewHelpBrowserPresenter new.
	browser rootTopic: (HelpTopic named: 'foo').
	topic := browser rootTopic.
	self 
		assert: topic title equals: 'foo' 

]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserPresenterOpenADirectory [

	| directory browser |
	directory := filesystem workingDirectory / self class spDirectoryName.
	filesystem createDirectory: self class spDirectoryName.
	browser := SpNewHelpBrowserPresenter new.
	browser topicsFromSystem: directory.
	
	self assert: browser rootTopic title equals: directory basenameWithoutExtension
	

]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserPresenterTopicFromSystemOnDirectoryWithFiles [
	| directory file1 file2 browser rootTopic |
	filesystem createDirectory: 'test'.
	directory := filesystem workingDirectory / 'test'.
	
	
	file1 := filesystem workingDirectory / 'test/fd1.mic'.
	file1 writeStreamDo: [ :stream | stream nextPutAll: self class spFd1 ].
	
	file2 := filesystem workingDirectory / 'test/fd2.mic'.
	file2 writeStreamDo: [ :stream | stream nextPutAll: self class spFd2  ].
	
	browser := SpNewHelpBrowserPresenter new.
	rootTopic := (browser topicsFromSystem: directory) rootTopic.
	self assert: rootTopic subtopics size equals: 3
	
	
]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserPresenterTopicFromSystemOnFile [
	| file browser rootTopic |
	file := filesystem workingDirectory / 'fd1.mic'.
	file writeStreamDo: [ :stream | stream nextPutAll: self class spFd1 ].
	browser := SpNewHelpBrowserPresenter new.
	rootTopic := (browser topicsFromSystem: file) rootTopic.
	self assert: rootTopic subtopics size equals: 2
	
	
]
