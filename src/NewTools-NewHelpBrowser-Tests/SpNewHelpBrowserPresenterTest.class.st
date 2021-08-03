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

	^ PRNodeHelpTopic
]

{ #category : #running }
SpNewHelpBrowserPresenterTest >> setUp [
	super setUp.
	filesystem := FileSystem memory.
	
]

{ #category : #running }
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

	| docFolder file cache save |

	[ save := SpNewHelpBrowserPresenter helpCache.

	filesystem createDirectory: 'doc'.
	docFolder := filesystem workingDirectory / 'doc'.
	file := filesystem workingDirectory / 'doc' / 'file.mic'.
	file writeStreamDo: [ :stream | stream nextPutAll: 'this is a text' ].
	
	SpNewHelpBrowserPresenter internalizeHelpFrom: docFolder.
	cache := SpNewHelpBrowserPresenter helpCache.
	self assert: cache basenameWithoutExtension equals: 'doc'.
	self 
		assert: cache children first basenameWithoutExtension 
		equals: 'file' ] ensure: [ SpNewHelpBrowserPresenter helpCache: save ]
]

{ #category : #'tests - cache' }
SpNewHelpBrowserPresenterTest >> testHelpCacheHandleShittyFiles [

	| docFolder file cache save |

	[ save := SpNewHelpBrowserPresenter helpCache.

	filesystem createDirectory: 'doc'.
	docFolder := filesystem workingDirectory / 'doc'.
	file := filesystem workingDirectory / 'doc' / 'file.mic'.
	file writeStreamDo: [ :stream | stream nextPutAll: 'this is a text' ].
	
	file := filesystem workingDirectory / 'doc' / '.DS_Store'.
	file writeStreamDo: [ :stream | stream nextPutAll: 'crap crap' ].
	
	SpNewHelpBrowserPresenter internalizeHelpFrom: docFolder.
	cache := SpNewHelpBrowserPresenter helpCache.
	self assert: cache basenameWithoutExtension equals: 'doc'.
	self 
		assert: cache children size equals: 1 ] ensure: [ SpNewHelpBrowserPresenter helpCache: save ]
]

{ #category : #'tests - cache' }
SpNewHelpBrowserPresenterTest >> testHelpCacheOnlyAcceptFolderAndMicFiles [

	| docFolder file cache save |

	[ save := SpNewHelpBrowserPresenter helpCache.

	filesystem createDirectory: 'doc'.
	docFolder := filesystem workingDirectory / 'doc'.
	file := filesystem workingDirectory / 'doc' / 'file.mic'.
	file writeStreamDo: [ :stream | stream nextPutAll: 'this is a text' ].
	
	file := filesystem workingDirectory / 'doc' / 'Stupid.txt'.
	file writeStreamDo: [ :stream | stream nextPutAll: 'This is a stupid mistyped extension text' ].
	
	filesystem createDirectory: 'doc/Epicea'.
	file := filesystem workingDirectory / 'doc' / 'Epicea' / 'fileEp.mic'.
	file writeStreamDo: [ :stream | stream nextPutAll: 'this is a text about Epicea' ].
	
	SpNewHelpBrowserPresenter internalizeHelpFrom: docFolder.
	cache := SpNewHelpBrowserPresenter helpCache.
	self  assert: cache children size equals: 2.
	self  assert: cache allChildren size equals: 4.
	
	
	
	] ensure: [ SpNewHelpBrowserPresenter helpCache: save ]
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

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testOpenOnCustomHelp2 [
	| browser rootTopic |	
	browser := SpNewHelpBrowserPresenter on: CustomHelp2 asHelpTopic.
	rootTopic := browser rootTopic.
	self assert: rootTopic title equals: 'Help'.
	self assert: rootTopic icon isNotNil.
	window := browser openWithSpec.
	
	
	
]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testOpenOnCustomHelpWithClass [
	| browser rootTopic save |	
	[ save := SpNewHelpBrowserPresenter helpCache.
	SpNewHelpBrowserPresenter emptyHelpCache.
	browser := SpNewHelpBrowserPresenter openOnCustomHelp: SpNewHelpBrowserPresenter.
	rootTopic := browser rootTopic.
	self assert: rootTopic title equals: '/'.
	window := browser window ] ensure: [ SpNewHelpBrowserPresenter helpCache: save ]
	
	
	
]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testOpenOnCustomHelpWithDescription [
	| browser rootTopic save |	
	[ save := SpNewHelpBrowserPresenter helpCache.
	SpNewHelpBrowserPresenter emptyHelpCache.
	browser := SpNewHelpBrowserPresenter openOnCustomHelp: SUnitTutorial.
	rootTopic := browser rootTopic.
	self assert: rootTopic title equals: 'Tutorial'.
	window := browser window ] ensure: [ SpNewHelpBrowserPresenter helpCache: save ]
	
	
	
]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testOpenOnCustomHelpWithMethod [
	| browser rootTopic save |	
	[ save := SpNewHelpBrowserPresenter helpCache.
	SpNewHelpBrowserPresenter emptyHelpCache.
	browser := SpNewHelpBrowserPresenter openOnCustomHelp: SpNewHelpBrowserPresenter>>#rootTopic:.
	rootTopic := browser rootTopic.
	self assert: rootTopic title equals: '/'.
	window := browser window ] ensure: [ SpNewHelpBrowserPresenter helpCache: save ]
	
	
	
]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testOpenOnCustomHelpWithObject [
	| browser rootTopic save |	
	[ save := SpNewHelpBrowserPresenter helpCache.
	SpNewHelpBrowserPresenter emptyHelpCache.
	browser := SpNewHelpBrowserPresenter openOnCustomHelp: Object new.
	rootTopic := browser rootTopic.
	self assert: rootTopic title equals: '/'.
	window := browser window ] ensure: [ SpNewHelpBrowserPresenter helpCache: save ]
	
	
	
]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testOpenOnCustomHelpWithString [
	| browser rootTopic save |	
	[ save := SpNewHelpBrowserPresenter helpCache.
	SpNewHelpBrowserPresenter emptyHelpCache.
	browser := SpNewHelpBrowserPresenter openOnCustomHelp: SpNewHelpBrowserPresenter>>#rootTopic:.
	rootTopic := browser rootTopic.
	self assert: rootTopic title equals: '/'.
	window := browser window ] ensure: [ SpNewHelpBrowserPresenter helpCache: save ]
	
	
	
]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testOpenOnDoesNotExistFolder [
	| browser rootTopic save |
		
	[ save := SpNewHelpBrowserPresenter helpCache.
	SpNewHelpBrowserPresenter emptyHelpCache.
	browser := SpNewHelpBrowserPresenter openOnHelpFolder: FileSystem workingDirectory  / 'ojdoajdjvsaidqsjkjfzeuican'.
	rootTopic := browser rootTopic. 
	self assert: rootTopic title equals: '/'.
	window := browser window] ensure: [ SpNewHelpBrowserPresenter helpCache: save ]

	
	
	
]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testOpenOnSystemHelp2 [
	| browser rootTopic |	
	browser := SpNewHelpBrowserPresenter on: SystemHelp2 asHelpTopic.
	rootTopic := browser rootTopic.
	self assert: rootTopic title equals: 'Help'.
	self assert: rootTopic icon isNil.
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
	topics := (browser helpTopicVisitorClass new start: (MicroDownParser parse: text) asPillar) rootTopics.
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
	topics := (browser helpTopicVisitorClass new start: (MicroDownParser parse: text) asPillar) rootTopics.
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
	visitor := browser helpTopicVisitorClass.
	self 
		assert: visitor equals: TopicBuilderVisitor

]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserGotHelpTopicVisitorThatISpecify [

	| visitor browser |
	browser := SpNewHelpBrowserPresenter new.
	browser helpTopicVisitorClass: PRVisitor.
	visitor := browser helpTopicVisitorClass.
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
	rootTopic := (browser createTopicsFromFileOrFolder: file).
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
	rootTopic := (browser createRootTopicFromFolder: directory) rootTopic.
	self assert: rootTopic subtopics size equals: 2
	
	
]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserPresenterOpenADirectory [

	| directory browser |
	directory := filesystem workingDirectory / self class spDirectoryName.
	filesystem createDirectory: self class spDirectoryName.
	browser := SpNewHelpBrowserPresenter new.
	browser createRootTopicFromFolder: directory.
	
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
	rootTopic := (browser createRootTopicFromFolder: directory) rootTopic.
	self assert: rootTopic subtopics size equals: 3
	
	
]

{ #category : #tests }
SpNewHelpBrowserPresenterTest >> testSpHelpBrowserPresenterTopicFromSystemOnFile [
	| file browser rootTopic |
	file := filesystem workingDirectory / 'fd1.mic'.
	file writeStreamDo: [ :stream | stream nextPutAll: self class spFd1 ].
	browser := SpNewHelpBrowserPresenter new.
	rootTopic := (browser createRootTopicFromFolder: file) rootTopic.
	self assert: rootTopic subtopics size equals: 2
	
	
]

{ #category : #'tests - cache' }
SpNewHelpBrowserPresenterTest >> testTopicsWithCacheFrom [

	| docFolder file browser save |
	[ save := SpNewHelpBrowserPresenter helpCache.

	filesystem createDirectory: 'doc'.
	docFolder := filesystem workingDirectory / 'doc'.
	file := filesystem workingDirectory / 'doc'/ 'file.mic'.
	file writeStreamDo: [ :stream | stream nextPutAll:  '# section
this is a text' ].
	
	SpNewHelpBrowserPresenter internalizeHelpFrom: docFolder.
	browser := SpNewHelpBrowserPresenter open.
	window := browser window.
	self assert: browser rootTopic title equals: 'Doc'.
	self assert: browser rootTopic subtopics size equals: 1 ]
		ensure: [  SpNewHelpBrowserPresenter helpCache: save ]
]

{ #category : #'tests - search' }
SpNewHelpBrowserPresenterTest >> testWordInNode [
	| browser text topic |
	browser := SpNewHelpBrowserPresenter new.
	text := '# section 1
this is a paragraphe'.
	topic := (browser helpTopicVisitorClass new start: (MicroDownParser parse: text) asPillar) rootTopics first.
	self assert: (browser word: 'para' in: topic) 


]

{ #category : #'tests - search' }
SpNewHelpBrowserPresenterTest >> testWordNotInNode [
	| browser text topic |
	browser := SpNewHelpBrowserPresenter new.
	text := '# section 1
this is a paragraphe'.
	topic := (browser helpTopicVisitorClass new start: (MicroDownParser parse: text) asPillar) rootTopics first.
	self assert: (browser word: 'nothing' in: topic) not


]
