Extension { #name : #NodeHelpTopic }

{ #category : #'*NewTools-NewHelpBrowser' }
NodeHelpTopic >> inspectionTopicTree [
	<inspectorPresentationOrder: 35 title: 'TopicTree'>

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
