"
Execute the following code to open HelpBrowser on doc :
```
| directory browser |
directory := FileSystem workingDirectory / 'doc'.
browser := SpNewHelpBrowserPresenter new docTopicsFromSystem: directory.
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

{ #category : #examples }
SpNewHelpBrowserPresenter class >> open [
	<example>
	^ self new openWithSpec
]

{ #category : #examples }
SpNewHelpBrowserPresenter class >> openOn: aHelpTopic [
	"Open the receiver on the given help topic or any other object that can be transformed into
	 a help topic by sending #asHelpTopic."
	"self openOn: (HelpTopic new "

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
					item class = HelpTopic ifTrue:
						[ text := item contents.
						text ifNotNil: [ 
							self render: text ] ] 
					ifFalse: 
						[					 node := item node.
						 node ifNotNil: [ 
							self renderNode: node ]]]
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> docTopicsFromFileSystem: aFileSystem [

	| visitor subTopic sorted topic |
	aFileSystem isFile ifTrue: [ 
		aFileSystem extension = 'mic'
			ifTrue: [ 	
				visitor := self helpTopicVisitor new.
				visitor start: (MicroDownParser parse: aFileSystem) asPillar.
				^ visitor rootTopics ] ].
	
	subTopic := OrderedCollection new.
	topic := NodeHelpTopic named: aFileSystem basenameWithoutExtension capitalized.	
	sorted := SortedCollection sortBlock: [ :a :b | a basename <= b basename ].
	sorted addAll: (aFileSystem children select: [ :e  | e isDirectory or: [e extension = 'mic']]).
	
	
	sorted 	do: [ :fileOrFolder |
			 (self docTopicsFromFileSystem: fileOrFolder) do: [ :each | topic addSubtopic: each ]].
		subTopic add: topic.
		^ subTopic
	
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> docTopicsFromSystem: aFileSystem [
	| topic |
	topic := (self docTopicsFromFileSystem: aFileSystem) first.
	self rootTopic: topic.
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> dummyHelp [

	^  '# Empty Help
	This a dummy help.'
]

{ #category : #utils }
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
SpNewHelpBrowserPresenter >> topicsFromFileSystem: aFileSystem [

	| visitor subTopic sorted |
	aFileSystem isFile ifTrue: [ 
		aFileSystem extension = 'mic'
			ifTrue: [ 	
				visitor := self helpTopicVisitor new.
				visitor start: (MicroDownParser parse: aFileSystem) asPillar.
				^ visitor rootTopics ] ].
	
	subTopic := OrderedCollection new.
	sorted := SortedCollection sortBlock: [ :a :b | a basename >= b basename ].
	sorted addAll: (aFileSystem children select: [ :e  | e isDirectory or: [e extension = 'mic']]).
	
		
	sorted 	do: [ :fileOrFolder |
			 subTopic addAll: (self topicsFromFileSystem: fileOrFolder)].
		^ subTopic
	
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> topicsFromSystem: aFileSystem [

	| topic |
	topic := HelpTopic named: aFileSystem basenameWithoutExtension.
	(self topicsFromFileSystem: aFileSystem) do: [ :each | topic addSubtopic: each ].
	self rootTopic: topic.
]
