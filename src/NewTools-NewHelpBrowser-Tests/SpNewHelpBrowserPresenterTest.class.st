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

## 2
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

{ #category : #'tests - search' }
SpNewHelpBrowserPresenterTest >> helpTopicClass [

	^ NodeHelpTopic
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

{ #category : #'tests - search' }
SpNewHelpBrowserPresenterTest >> testFoundNoWords [

	| browser topics |
	browser := SpNewHelpBrowserPresenter new.
	topics := OrderedCollection new.
	topics
		add: (self helpTopicClass named: 'section1');
		add: (self helpTopicClass named: 'part 2');
		add: (self helpTopicClass named: 'section 3').
	(topics at: 2) addSubtopic: (self helpTopicClass named: 'section2').
	self assert: (browser search: 'aWord' into: topics) size equals: 0
]

{ #category : #'tests - cache' }
SpNewHelpBrowserPresenterTest >> testHelpCache [

	| rootSystem file text cache save |
	save := SpNewHelpBrowserPresenter helpCache.
	text := 'this is a text'.
	filesystem createDirectory: 'doc'.
	rootSystem := filesystem workingDirectory / 'doc'.
	file := filesystem workingDirectory / 'doc/file.txt'.
	file writeStreamDo: [ :stream | stream nextPutAll: text ].
	
	SpNewHelpBrowserPresenter internalizeHelpFrom: rootSystem.
	cache := SpNewHelpBrowserPresenter helpCache.
	self assert: cache basenameWithoutExtension equals: 'doc'.
	self 
		assert: cache children first basenameWithoutExtension 
		equals: 'file'.
	SpNewHelpBrowserPresenter helpCache: save
]

{ #category : #'tests - cache' }
SpNewHelpBrowserPresenterTest >> testHelpCacheReturnFileReferenceEmptyIfNil [
	| cache |
	cache := SpNewHelpBrowserPresenter helpCache.
	SpNewHelpBrowserPresenter emptyHelpCache.
	self assert: SpNewHelpBrowserPresenter helpCache hasChildren not.
	SpNewHelpBrowserPresenter helpCache: cache

	
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

{ #category : #'tests - search' }
SpNewHelpBrowserPresenterTest >> testSearchList [
	| browser text topics |
	browser := SpNewHelpBrowserPresenter new.
	text := '# section 1
this is a paragraphe
## section 2
this is a paragraphe
## section 3
nothing
#section 4
this is a paragraphe'.
	topics := (browser helpTopicVisitor new start: (MicroDownParser parse: text) asPillar) rootTopics.
	self assert: (browser searchList: 'para' into: topics) size equals: 3

]

{ #category : #'tests - search' }
SpNewHelpBrowserPresenterTest >> testSearchWordInTopics [
	| browser topics text|
	browser := SpNewHelpBrowserPresenter new.
	text := '# section 1
this is a paragraphe
## section 2
blabla
# part 3
lala'.
	topics := (browser helpTopicVisitor new start: (MicroDownParser parse: text) asPillar) rootTopics.
	self assert: (browser search: 'la' into: topics) size equals: 2
]

{ #category : #'tests - search' }
SpNewHelpBrowserPresenterTest >> testSearchWordInTopicsTitle [

	| browser topics |
	browser := SpNewHelpBrowserPresenter new.
	topics := OrderedCollection new.
	topics
		add: (self helpTopicClass named: 'section1');
		add: (self helpTopicClass named: 'part 2');
		add: (self helpTopicClass named: 'section 3').
	(topics at: 2) addSubtopic: (self helpTopicClass named: 'section2').
	self assert: (browser search: 'section' into: topics) size equals: 3
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
	browser helpTopicVisitor: PRVisitor.
	visitor := browser helpTopicVisitor.
	self 
		assert: visitor equals: PRVisitor

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
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserPresenterDocTopicFromFileSystemOnFile [
	| file browser rootTopic |
	file := filesystem workingDirectory / 'fd1.mic'.
	file writeStreamDo: [ :stream | stream nextPutAll: self class spFd1 ].
	browser := SpNewHelpBrowserPresenter new.
	rootTopic := (browser topicsFromFileSystem: file).
	self assert: rootTopic size equals: 2
	
	
]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserPresenterDocTopicFromSystem [
	| file directory browser rootTopic |
	filesystem createDirectory: 'test'.
	directory := filesystem workingDirectory / 'test'.
	file := filesystem workingDirectory / 'test/fd1.mic'.
	file writeStreamDo: [ :stream | stream nextPutAll: self class spFd1 ].
	browser := SpNewHelpBrowserPresenter new.
	rootTopic := (browser topicsFromSystem: directory) rootTopic.
	self assert: rootTopic subtopics size equals: 2
	
	
]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserPresenterOpenADirectory [

	| directory browser |
	directory := filesystem workingDirectory / self class spDirectoryName.
	filesystem createDirectory: self class spDirectoryName.
	browser := SpNewHelpBrowserPresenter new.
	browser topicsFromSystem: directory.
	
	self assert: browser rootTopic title equals: directory basenameWithoutExtension capitalized
	

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

{ #category : #'tests - cache' }
SpNewHelpBrowserPresenterTest >> testTopicsWithCacheFrom [

	| rootSystem file text browser save |
	save := SpNewHelpBrowserPresenter helpCache.
	text := '# section
this is a text'.
	filesystem createDirectory: 'doc'.
	rootSystem := filesystem workingDirectory / 'doc'.
	file := filesystem workingDirectory / 'doc/file.mic'.
	file writeStreamDo: [ :stream | stream nextPutAll: text ].
	
	browser := SpNewHelpBrowserPresenter new topicsWithCacheFrom: rootSystem.
	self assert: browser rootTopic title equals: 'Doc'.
	self assert: browser rootTopic subtopics size equals: 1.
	SpNewHelpBrowserPresenter helpCache: save
]

{ #category : #'tests - cache' }
SpNewHelpBrowserPresenterTest >> testTopicsWithCacheFromChargeTheCache [

	| rootSystem file text cache save |
	save := SpNewHelpBrowserPresenter helpCache.
	text := 'this is a text'.
	filesystem createDirectory: 'doc'.
	rootSystem := filesystem workingDirectory / 'doc'.
	file := filesystem workingDirectory / 'doc/file.txt'.
	file writeStreamDo: [ :stream | stream nextPutAll: text ].
	
	SpNewHelpBrowserPresenter new topicsWithCacheFrom: rootSystem.
	cache := SpNewHelpBrowserPresenter helpCache.
	self assert: cache basenameWithoutExtension equals: 'doc'.
	self assert: cache children first basenameWithoutExtension equals: 'file'.
	SpNewHelpBrowserPresenter helpCache: save
]

{ #category : #'tests - search' }
SpNewHelpBrowserPresenterTest >> testWordInNode [
	| browser text topic |
	browser := SpNewHelpBrowserPresenter new.
	text := '# section 1
this is a paragraphe'.
	topic := (browser helpTopicVisitor new start: (MicroDownParser parse: text) asPillar) rootTopics first.
	self assert: (browser word: 'para' in: topic) 


]

{ #category : #'tests - search' }
SpNewHelpBrowserPresenterTest >> testWordNotInNode [
	| browser text topic |
	browser := SpNewHelpBrowserPresenter new.
	text := '# section 1
this is a paragraphe'.
	topic := (browser helpTopicVisitor new start: (MicroDownParser parse: text) asPillar) rootTopics first.
	self assert: (browser word: 'nothing' in: topic) not


]
