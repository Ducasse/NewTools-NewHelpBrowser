"
Execute the following code to open HelpBrowser on doc :
```
| directory browser |
directory := FileSystem workingDirectory / 'doc'.
browser := SpNewHelpBrowserPresenter new topicsFromSystem: directory.
SpNewHelpBrowserPresenter openOn: browser rootTopic
```

Execute the following code to charge doc in the cache :
```
| doc |
doc := FileSystem disk workingDirectory / 'doc'.
SpNewHelpBrowserPresenter internalizeHelpFrom: doc.
```
And to watch the cache inspect that :
```
SpNewHelpBrowserPresenter helpCache
```

After that you can also open the HelpBrowser with the helpCache :
```
| browser |
browser := SpNewHelpBrowserPresenter new topicsFromSystem.
SpNewHelpBrowserPresenter openOn: browser rootTopic
```

to empty the cache execute the following code :
```
SpNewHelpBrowserPresenter emptyHelpCache
```

code to charge and use the cache :
```
| directory browser |
directory := FileSystem workingDirectory / 'doc'.
browser := SpNewHelpBrowserPresenter new topicsWithCacheFrom: directory.
SpNewHelpBrowserPresenter openOn: browser rootTopic
```
"
Class {
	#name : #SpNewHelpBrowserPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'helpText',
		'textOutput',
		'syntaxHelper',
		'textInput',
		'rootTopic',
		'topicList',
		'helpTopicVisitor'
	],
	#classInstVars : [
		'filesystem',
		'helpCache'
	],
	#category : #'NewTools-NewHelpBrowser'
}

{ #category : #specs }
SpNewHelpBrowserPresenter class >> defaultSpec [

	 ^ SpBoxLayout newTopToBottom
			add: (SpPanedLayout newLeftToRight
				add: #topicList;
				add: #textOutput;
				yourself);
			yourself
]

{ #category : #accessing }
SpNewHelpBrowserPresenter class >> emptyHelpCache [

	helpCache := nil
]

{ #category : #accessing }
SpNewHelpBrowserPresenter class >> filesystem [
	^ filesystem
]

{ #category : #accessing }
SpNewHelpBrowserPresenter class >> filesystem: aFileSystem [
	filesystem := aFileSystem
]

{ #category : #accessing }
SpNewHelpBrowserPresenter class >> helpCache [

	^ helpCache ifNil: [ helpCache := FileSystem memory workingDirectory ]
]

{ #category : #accessing }
SpNewHelpBrowserPresenter class >> helpCache: aCache [
	helpCache := aCache.
]

{ #category : #cache }
SpNewHelpBrowserPresenter class >> internalizeHelpFrom: aFolderOrFile [
	self filesystem: FileSystem memory.
	aFolderOrFile isDirectory 
		ifTrue:  [self filesystem createDirectory: aFolderOrFile basename.
					aFolderOrFile children do: [ :folderOrFile | self internalizeHelpFrom: folderOrFile  at: aFolderOrFile basename ] ]
		ifFalse: [ | file |
					file := self filesystem workingDirectory / aFolderOrFile basename.
					file writeStreamDo: [ :stream |stream nextPutAll: aFolderOrFile contents ] ].
		
		self helpCache: self filesystem workingDirectory / aFolderOrFile basename.
	
	
]

{ #category : #cache }
SpNewHelpBrowserPresenter class >> internalizeHelpFrom: aFolderOrFile  at: aFolderName [

	aFolderOrFile isDirectory 
		ifTrue:  [ | directoryPath |
					directoryPath := aFolderName , '/' ,aFolderOrFile basename.
					self filesystem createDirectory: directoryPath.
					aFolderOrFile children do: [ :folderOrFile | self internalizeHelpFrom: folderOrFile  at: directoryPath ] ]
		ifFalse: [ | file filePath |
					filePath := aFolderName , '/' , aFolderOrFile basename.
					file := self filesystem workingDirectory / filePath.
					file writeStreamDo: [ :stream |stream nextPutAll: aFolderOrFile contents ] ].
	
]

{ #category : #examples }
SpNewHelpBrowserPresenter class >> open [
	<example>
	^ self new openWithSpec
]

{ #category : #examples }
SpNewHelpBrowserPresenter class >> openOn: aHelpTopic [
	"Open the receiver on the given help topic or any other object that can be transformed into
	 a help topic by sending #asHelpTopic."

	^ (self on:  aHelpTopic)
		openWithSpec;
		yourself
]

{ #category : #initialization }
SpNewHelpBrowserPresenter >> connectPresenters [
 
	topicList
		whenSelectionChangedDo: [ :selection | 
					| item node text |
					item := selection selectedItem.
					"case for SystemHelp when SystemHelp will manage NodeHelpTopic we will be
					able to remove this condition"
					item class = HelpTopic ifTrue:
						[ text := item contents.
						text ifNotNil: [ 
							self render: text ] ] 
					ifFalse: 
						[ node := item node.
						 node ifNotNil: [ 
							self renderNode: node ]]];
				displayIcon: [ :each | each icon ]
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> dummyHelp [

	^  '# Empty Help
	This a dummy help.'
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> helpTopicClass [

	^ NodeHelpTopic
]

{ #category : #accessing }
SpNewHelpBrowserPresenter >> helpTopicVisitor [
	
	helpTopicVisitor ifNil: [ ^ helpTopicVisitor := TopicBuilderVisitor. ].
	^ helpTopicVisitor
]

{ #category : #accessing }
SpNewHelpBrowserPresenter >> helpTopicVisitor: aClass [ 
	helpTopicVisitor := aClass
]

{ #category : #initialization }
SpNewHelpBrowserPresenter >> initialExtent [
	^ 800@600
]

{ #category : #initialization }
SpNewHelpBrowserPresenter >> initializePresenters [

	super initializePresenters.
	topicList := self newTree.
	topicList 
		roots: { self rootTopic };
		children: [ :aNode | aNode subtopics ];
		display: [ :each | each title ].
	
	"Using a morph container as the output because a text presenter is intended to receive 
	 strings, not instances of Text (the fact that it works now is just casual, and will 
	 be removed in the future)"
	textOutput := self newMorph
		morph: (RubScrolledTextMorph new 
			hResizing: #spaceFill; 
			vResizing: #spaceFill;
			in: [ :this | this textArea readOnly: true ];
			yourself);
		yourself.
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> morphWriter [ 
		
	^ PRRichTextComposer new
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> parser [ 
	^ MicroDownParser
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> render [

	| document |	
	document := self parser parse: self dummyHelp.
	textOutput morph setText: (self morphWriter start: document asPillar) 
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> render: aString [

	| document text |
	aString 
		ifNil: [ text := self dummyHelp ]
		ifNotNil: [ text := aString ].
	 document := [ self parser parse: text ] 
							on: MicParsingError
							do: [ :ex | textOutput morph setText: text. ^ self ].
	textOutput morph setText: (self morphWriter start: document asPillar) 
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> renderNode: aNode [

	textOutput morph setText: (self morphWriter start: aNode) 
]

{ #category : #accessing }
SpNewHelpBrowserPresenter >> rootTopic [
	^ rootTopic ifNil: [ self rootTopic: SystemHelp2 asHelpTopic. rootTopic ]
]

{ #category : #accessing }
SpNewHelpBrowserPresenter >> rootTopic: aHelpTopic [ 
	rootTopic := aHelpTopic asHelpTopic
]

{ #category : #search }
SpNewHelpBrowserPresenter >> search: aString [

	| topics |
	topics := self rootTopic subtopics.
	^ self search: aString into: topics. 
]

{ #category : #search }
SpNewHelpBrowserPresenter >> search: aString into: aTopicCollection [

	| collection |
	collection := OrderedCollection new.
	aTopicCollection do: [ :topic | 
		(self word: aString in: topic )
			ifTrue: [ collection add: topic ]
			ifFalse: [ collection addAll: (self search: aString into: topic subtopics) ] ].
	^ collection
]

{ #category : #search }
SpNewHelpBrowserPresenter >> searchList: aString [

	| topics |
	topics := self rootTopic subtopics.
	^ self searchList: aString into: topics. 
]

{ #category : #search }
SpNewHelpBrowserPresenter >> searchList: aString into: aTopicCollection [

	| collection |
	collection := OrderedCollection new.
	aTopicCollection do: [ :topic | 
		(self word: aString in: topic) 
			ifTrue: [ collection add: topic ].
		collection addAll: (self search: aString into: topic subtopics) ].
	^ collection
]

{ #category : #initialization }
SpNewHelpBrowserPresenter >> setModelBeforeInitialization: anHelpTopic [
	
	rootTopic := anHelpTopic
]

{ #category : #initialization }
SpNewHelpBrowserPresenter >> title [
	^ 'Help Topic Browser'
]

{ #category : #accessing }
SpNewHelpBrowserPresenter >> topicList [
	^ topicList
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> topicsFromFileSystem: aFileOrFolder [

	| visitor subTopic sorted topic |
	aFileOrFolder isFile ifTrue: [ 
		aFileOrFolder extension = 'mic' ifTrue: [ 
			visitor := self helpTopicVisitor new.
			visitor start: (MicroDownParser parse: aFileOrFolder) asPillar.
			^ visitor rootTopics ] ].

	subTopic := OrderedCollection new.
	topic := self helpTopicClass named:
		         aFileOrFolder basenameWithoutExtension capitalized.
	sorted := SortedCollection sortBlock: [ :a :b | 
		          a basename <= b basename ].
	sorted addAll: (aFileOrFolder children select: [ :e | 
			 e isDirectory or: [ e extension = 'mic' ] ]).


	sorted do: [ :fileOrFolder | 
		(self topicsFromFileSystem: fileOrFolder) do: [ :each | 
			topic addSubtopic: each ] ].
	subTopic add: topic.
	^ subTopic
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> topicsFromSystem [
	self topicsFromSystem: self class helpCache.
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> topicsFromSystem: aFolder [
	| topic |
	topic := (self topicsFromFileSystem: aFolder) first.
	self rootTopic: topic.
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> topicsWithCacheFrom: aFolder [
	self class internalizeHelpFrom: aFolder.
	self topicsFromSystem
]

{ #category : #search }
SpNewHelpBrowserPresenter >> word: aString in: aTopic [

	^ (aTopic node text findString: aString startingAt: 1) > 0 | ((aTopic title findString: aString startingAt: 1) > 0)
]
