Extension { #name : #MCNodeHelpTopic }

{ #category : #'*NewTools-MCNewHelpBrowser' }
MCNodeHelpTopic >> addNode: aNode [

	node addChild: aNode
]

{ #category : #'*NewTools-MCNewHelpBrowser' }
MCNodeHelpTopic >> addSubtopic: aSubTopic [
	self iconName: #bookIcon.
	super addSubtopic: aSubTopic
]

{ #category : #'*NewTools-MCNewHelpBrowser' }
MCNodeHelpTopic >> addSubtopic: aHelpTopic with: aLevel [

	aLevel - 1 > 1
		ifTrue: [ 
			self subtopics isEmpty
				ifTrue: [ self addSubtopic: aHelpTopic ]
				ifFalse: [ self subtopics last addSubtopic: aHelpTopic with: aLevel - 1 ] ]
		ifFalse: [ self addSubtopic: aHelpTopic ]
]

{ #category : #'*NewTools-MCNewHelpBrowser' }
MCNodeHelpTopic >> initialize [ 

	super initialize.
	node := MicRootBlock new.
	self iconName: #pageIcon
]

{ #category : #'*NewTools-MCNewHelpBrowser' }
MCNodeHelpTopic >> inspectionMCTopicTree [
	<inspectorPresentationOrder: 930 title: 'TopicTree'>

	^ SpTreePresenter new 
		roots: { self };
		children: [ :aNode | aNode subtopics ];
		display: [ :each | 
			String
				streamContents: [ :stream | 
					each displayStringOn: stream						
			 ] ];
		yourself
]

{ #category : #'*NewTools-MCNewHelpBrowser' }
MCNodeHelpTopic >> node [
	^ node
]

{ #category : #'*NewTools-MCNewHelpBrowser' }
MCNodeHelpTopic >> subtopics: aCollection [
	self iconName: #bookIcon.
	super subtopics: aCollection
]
