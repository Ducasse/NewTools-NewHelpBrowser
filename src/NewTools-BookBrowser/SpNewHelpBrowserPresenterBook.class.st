Class {
	#name : #SpNewHelpBrowserPresenterBook,
	#superclass : #SpNewHelpBrowserPresenter,
	#category : #'NewTools-BookBrowser'
}

{ #category : #accessing }
SpNewHelpBrowserPresenterBook >> bookChapters: aFolder [

	aFolder children do: [ :each | 
		each extension = 'pillar' ifTrue: [ ^ self listOfChapters: each ] ]
]

{ #category : #utils }
SpNewHelpBrowserPresenterBook >> createRootTopicFromFolder: aFileOrFolder [

	| topic chapters |
	topic := self helpTopicClass named:
		         aFileOrFolder basenameWithoutExtension.
	chapters := self bookChapters: aFileOrFolder.
	chapters do: [ :each | 
		(self createTopicsFromFileOrFolder:
			 FileSystem workingDirectory / aFileOrFolder pathString / each) 
			do: [ :e | topic addSubtopic: e ] ].

	"
	(self createTopicsFromFileOrFolder: aFileOrFolder) do: [ :each | 
		topic addSubtopic: each ]."
	self rootTopic: topic
]

{ #category : #utils }
SpNewHelpBrowserPresenterBook >> createTopicsFromFileOrFolder: aFileOrFolder [

	| subTopic sorted |
	(aFileOrFolder isFile and: aFileOrFolder extension = 'mic') ifTrue: [ 
		^ self createTopicsFromFile: aFileOrFolder ].

	subTopic := OrderedCollection new.
	aFileOrFolder isDirectory ifTrue: [ 
		sorted := self sortFileAndFolder: aFileOrFolder.
		sorted do: [ :fileOrFolder | 
			subTopic addAll: (self createTopicsFromFileOrFolder: fileOrFolder) ] ].
	^ subTopic
]

{ #category : #'as yet unclassified' }
SpNewHelpBrowserPresenterBook >> indexVisitorClass [

	^ IndexVisitor
]

{ #category : #'as yet unclassified' }
SpNewHelpBrowserPresenterBook >> listOfChapters: aFile [

	| pillar visitor |
	pillar := PRPillarParser new parse: aFile contents.
	visitor := self indexVisitorClass new.
	pillar accept: visitor.
	^ visitor indexList
]

{ #category : #utils }
SpNewHelpBrowserPresenterBook >> topicsFromFileSystem: aFileOrFolder visitor: aVistor [
	| subTopic sorted |
	aFileOrFolder isFile ifTrue: [ 
		aFileOrFolder extension = 'mic' ifTrue: [ 
			aVistor start: (MicroDownParser parse: aFileOrFolder) asPillar.
			^ aVistor rootTopics ] ].
	
	self writePillarToMic: aFileOrFolder.
	subTopic := OrderedCollection new.
	sorted := SortedCollection sortBlock: [ :a :b | 
		          a basename >= b basename ].
	sorted addAll: (aFileOrFolder children select: [ :e | 
			 e isDirectory or: [ e extension = 'mic' ] ]).


	sorted do: [ :fileOrFolder | 
		subTopic addAll: (self topicsFromFileSystem: fileOrFolder visitor: aVistor) ].
	^ subTopic
]

{ #category : #writing }
SpNewHelpBrowserPresenterBook >> writePillarToMic: aFolder [
	aFolder children do:[ :each |
			each extension = 'pillar' 
				ifTrue: [ | contents |
						contents := PRPillarParser parse: each contents.
						aFolder / (each basenameWithoutExtension , '.mic') writeStreamDo: [ :stream |
							stream nextPutAll: (PRMicrodownWriter new start: contents) contents ] ] ]
]
