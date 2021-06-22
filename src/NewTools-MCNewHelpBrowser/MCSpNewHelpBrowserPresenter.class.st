"
Execute the following code to open HelpBrowser on doc :
```
MCSpNewHelpBrowserPresenter openOnHelpFolder:  FileSystem workingDirectory / 'doc'.
```

Execute the following code to charge doc in the cache :
```
| doc |
doc := FileSystem disk workingDirectory / 'doc'.
MCSpNewHelpBrowserPresenter internalizeHelpFrom: doc.
```
And to watch the cache inspect that :
```
MCSpNewHelpBrowserPresenter helpCache
```

After that you can also open the HelpBrowser with the helpCache :
```
| browser |
browser := MCSpNewHelpBrowserPresenter new topicsFromSystem.
MCSpNewHelpBrowserPresenter openOn: browser rootTopic
```

to empty the cache execute the following code :
```
MCSpNewHelpBrowserPresenter emptyHelpCache
```

code to charge and use the cache :
```
MCSpNewHelpBrowserPresenter internalizeHelpFrom: FileSystem disk workingDirectory / 'doc'.
MCSpNewHelpBrowserPresenter open
```
"
Class {
	#name : #MCSpNewHelpBrowserPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'helpText',
		'textOutput',
		'syntaxHelper',
		'textInput',
		'rootTopic',
		'topicList',
		'helpTopicVisitor',
		'searchInput',
		'nextButton'
	],
	#classInstVars : [
		'filesystem',
		'helpCache'
	],
	#category : #'NewTools-MCNewHelpBrowser'
}

{ #category : #specs }
MCSpNewHelpBrowserPresenter class >> defaultSpec [

	 ^ SpBoxLayout newTopToBottom
			add: (SpPanedLayout newLeftToRight
				add: #topicList;
				add: #textOutput;
				yourself);
			"add: (SpBoxLayout newLeftToRight
				add: #searchInput withConstraints:  [ :constraints | constraints height: 18 ];
				add: #nextButton withConstraints:  [ :constraints | constraints height: 18 ] ;
				yourself);"
			yourself
]

{ #category : #accessing }
MCSpNewHelpBrowserPresenter class >> emptyHelpCache [

	helpCache := nil
]

{ #category : #accessing }
MCSpNewHelpBrowserPresenter class >> filesystem [
	^ filesystem
]

{ #category : #accessing }
MCSpNewHelpBrowserPresenter class >> filesystem: aFileSystem [
	filesystem := aFileSystem
]

{ #category : #accessing }
MCSpNewHelpBrowserPresenter class >> helpCache [

	^ helpCache ifNil: [ helpCache := FileSystem memory workingDirectory ]
]

{ #category : #accessing }
MCSpNewHelpBrowserPresenter class >> helpCache: aCache [
	helpCache := aCache.
]

{ #category : #cache }
MCSpNewHelpBrowserPresenter class >> internalizeHelpFrom: aFolderOrFile [
	self filesystem: FileSystem memory.
	[ aFolderOrFile isDirectory 
		ifTrue:  [self filesystem createDirectory: aFolderOrFile basename. 
					(aFolderOrFile children select: [ :e |  e isDirectory or: [ e extension = 'mic' ] ])
						do: [ :folderOrFile | self internalizeHelpFrom: folderOrFile  at: aFolderOrFile basename ] ]
		ifFalse: [ | file |
					file := self filesystem workingDirectory / aFolderOrFile basename.
					file writeStreamDo: [ :stream |stream nextPutAll: aFolderOrFile contents ] ].
	self helpCache: self filesystem workingDirectory / aFolderOrFile basename.
	] 
		on: FileDoesNotExistException 
		do: [  "We do not do anything special because the only thing we could do is to reinitialize
			and we may lose the contents there was one." ]
		
		
	
	
]

{ #category : #cache }
MCSpNewHelpBrowserPresenter class >> internalizeHelpFrom: aFolderOrFile  at: aFolderName [

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

{ #category : #'instance creation' }
MCSpNewHelpBrowserPresenter class >> open [
	"Open a HelpBrowser on the internalized docs."
	<example>

	^ self openOnHelpFolder: helpCache 
]

{ #category : #'instance creation' }
MCSpNewHelpBrowserPresenter class >> openOn: aHelpTopic [
	"Open the receiver on the given help topic or any other object that can be transformed into
	 a help topic by sending #asHelpTopic."

	^ (self on:  aHelpTopic)
		openWithSpec;
		yourself
]

{ #category : #'instance creation' }
MCSpNewHelpBrowserPresenter class >> openOnCustomHelp: aDescription [
	[ aDescription bookName.
	 ^ SpNewHelpBrowserPresenter openOn: (CustomHelpHelpBuilder new createTopicFrom: aDescription)] 
	on: MessageNotUnderstood do: [ | inst |
		inst:= self basicNew.
		inst createTopicsFromCache.
		^ inst 
		setModelBeforeInitialization: inst rootTopic;
		initialize;
		openWithSpec;
		yourself
	 ]
	
]

{ #category : #'instance creation' }
MCSpNewHelpBrowserPresenter class >> openOnHelpFolder: aFileReference [
	"Open an help browser on a given folder."
	"Implementation note: the logic is not really good because I have to copy the logic from SpPresenter class>>#newApplication:model:.
	Especially how to pass a model before the initialization which is normally done via message #on: "
	
	| inst fileReference |
	inst := self basicNew. 
	aFileReference exists 
		ifFalse: [ fileReference := self helpCache ] 
		ifTrue: [ fileReference := aFileReference  ].
	inst createRootTopicFromFolder: fileReference.
	^ inst 
		setModelBeforeInitialization: inst rootTopic;
		initialize;
		openWithSpec;
		yourself
]

{ #category : #initialization }
MCSpNewHelpBrowserPresenter >> connectPresenters [
 
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
MCSpNewHelpBrowserPresenter >> createRootTopicFromFolder: aFolder [
	| topic |
	topic := (self createTopicsFromFileOrFolder: aFolder) first.
	self rootTopic: topic.
]

{ #category : #utils }
MCSpNewHelpBrowserPresenter >> createTopicsFromCache [
	self createRootTopicFromFolder: self class helpCache.
]

{ #category : #utils }
MCSpNewHelpBrowserPresenter >> createTopicsFromFileOrFolder: aFileOrFolder [

	| visitor subTopic sorted topic |
	aFileOrFolder isFile ifTrue: [ 
		aFileOrFolder extension = 'mic' ifTrue: [
			visitor := self helpTopicVisitor new.
			visitor start: (MicroDownParser new parse: aFileOrFolder contents).
			^ visitor rootTopics ] ].

	subTopic := OrderedCollection new.
	topic := self helpTopicClass named:
		         aFileOrFolder basenameWithoutExtension capitalized.
	sorted := SortedCollection sortBlock: [ :a :b | 
		          a basename <= b basename ].
	sorted addAll: (aFileOrFolder children select: [ :e | 
			 e isDirectory or: [ e extension = 'mic' ] ]).


	sorted do: [ :fileOrFolder | 
		(self createTopicsFromFileOrFolder: fileOrFolder) do: [ :each | 
			topic addSubtopic: each ] ].
	subTopic add: topic.
	^ subTopic
]

{ #category : #utils }
MCSpNewHelpBrowserPresenter >> dummyHelp [

	^  '# Empty Help
	This a dummy help.'
]

{ #category : #utils }
MCSpNewHelpBrowserPresenter >> helpTopicClass [

	^ MCNodeHelpTopic
]

{ #category : #accessing }
MCSpNewHelpBrowserPresenter >> helpTopicVisitor [
	
	helpTopicVisitor ifNil: [ ^ helpTopicVisitor := MCTopicBuilderVisitor. ].
	^ helpTopicVisitor
]

{ #category : #accessing }
MCSpNewHelpBrowserPresenter >> helpTopicVisitor: aClass [ 
	helpTopicVisitor := aClass
]

{ #category : #initialization }
MCSpNewHelpBrowserPresenter >> initialExtent [
	^ 800@600
]

{ #category : #initialization }
MCSpNewHelpBrowserPresenter >> initializePresenters [

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
	searchInput := self newTextInput.
	nextButton := self newButton 
						help: 'To select the next one';
						label: 'Next'.




]

{ #category : #utils }
MCSpNewHelpBrowserPresenter >> morphWriter [ 
		
	^ BCRichTextComposer new
]

{ #category : #utils }
MCSpNewHelpBrowserPresenter >> parser [ 
	^ MicroDownParser
]

{ #category : #utils }
MCSpNewHelpBrowserPresenter >> render [

	| document |	
	document := self parser parse: self dummyHelp.
	textOutput morph setText: (self morphWriter start: document) 
]

{ #category : #utils }
MCSpNewHelpBrowserPresenter >> render: aString [

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
MCSpNewHelpBrowserPresenter >> renderNode: aNode [

	textOutput morph setText: (self morphWriter start: aNode) 
]

{ #category : #accessing }
MCSpNewHelpBrowserPresenter >> rootTopic [
	^ rootTopic ifNil: [ self rootTopic: SystemHelp2 asHelpTopic. rootTopic ]
]

{ #category : #accessing }
MCSpNewHelpBrowserPresenter >> rootTopic: aHelpTopic [ 
	rootTopic := aHelpTopic asHelpTopic
]

{ #category : #search }
MCSpNewHelpBrowserPresenter >> search: aString [

	| topics |
	topics := self rootTopic subtopics.
	^ self search: aString into: topics. 
]

{ #category : #search }
MCSpNewHelpBrowserPresenter >> search: aString into: aTopicCollection [

	| collection |
	collection := OrderedCollection new.
	aTopicCollection do: [ :topic | 
		(self word: aString in: topic )
			ifTrue: [ collection add: topic ]
			ifFalse: [ collection addAll: (self search: aString into: topic subtopics) ] ].
	^ collection
]

{ #category : #search }
MCSpNewHelpBrowserPresenter >> searchList: aString [

	| topics |
	topics := self rootTopic subtopics.
	^ self searchList: aString into: topics. 
]

{ #category : #search }
MCSpNewHelpBrowserPresenter >> searchList: aString into: aTopicCollection [

	| collection |
	collection := OrderedCollection new.
	aTopicCollection do: [ :topic | 
		(self word: aString in: topic) 
			ifTrue: [ collection add: topic ].
		collection addAll: (self search: aString into: topic subtopics) ].
	^ collection
]

{ #category : #initialization }
MCSpNewHelpBrowserPresenter >> setModelBeforeInitialization: anHelpTopic [
	
	rootTopic := anHelpTopic
]

{ #category : #initialization }
MCSpNewHelpBrowserPresenter >> title [
	^ 'Help Topic Browser'
]

{ #category : #accessing }
MCSpNewHelpBrowserPresenter >> topicList [
	^ topicList
]

{ #category : #search }
MCSpNewHelpBrowserPresenter >> word: aString in: aTopic [

	^ (aTopic node text findString: aString startingAt: 1) > 0 | ((aTopic title findString: aString startingAt: 1) > 0)
]
