Class {
	#name : #SpNewHelpBrowserPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'loadedTopicList',
		'helpText',
		'textOutput',
		'syntaxHelper',
		'textInput',
		'helpTopicCache',
		'rootTopic'
	],
	#category : #'NewTools-NewHelpBrowser'
}

{ #category : #specs }
SpNewHelpBrowserPresenter class >> defaultSpec [

	 ^ SpBoxLayout newTopToBottom
			add: (SpPanedLayout newLeftToRight
				add: #loadedTopicList;
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
	"SpHelpBrowser openOn: SystemHelp"
	
	^self new
		rootTopic: aHelpTopic;
		openWithSpec;
		yourself
]

{ #category : #initialization }
SpNewHelpBrowserPresenter >> connectPresenters [
 
	loadedTopicList
		whenSelectionChangedDo: [ :selection | 
					| text |
					text := selection selectedItem contents.
					text ifNotNil: [ 
							self render: text ]].
]

{ #category : #utils }
SpNewHelpBrowserPresenter >> dummyHelp [

	^  '# Empty Help
	This a dummy help.'
]

{ #category : #actions }
SpNewHelpBrowserPresenter >> helpTopic [
	^ helpTopicCache ifNil: [ helpTopicCache := SystemHelp asHelpTopic ]
]

{ #category : #initialization }
SpNewHelpBrowserPresenter >> initialExtent [
	^ 800@600
]

{ #category : #initialization }
SpNewHelpBrowserPresenter >> initializePresenters [

	super initializePresenters.
	loadedTopicList := self newTree.
	loadedTopicList 
		roots: { self helpTopic };
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

{ #category : #accessing }
SpNewHelpBrowserPresenter >> rootTopic [

	^ rootTopic
]

{ #category : #accessing }
SpNewHelpBrowserPresenter >> rootTopic: anObject [

	rootTopic := anObject
]

{ #category : #initialization }
SpNewHelpBrowserPresenter >> title [
	^ 'Help Topic Browser'
]
