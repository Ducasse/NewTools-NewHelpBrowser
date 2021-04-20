Class {
	#name : #BaselineOfNewHelpBrowser,
	#superclass : #BaselineOf,
	#category : #BaselineOfNewHelpBrowser
}

{ #category : #baselines }
BaselineOfNewHelpBrowser >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec 
			package: #'NewTools-NewHelpBrowser';
			package: #'TopicBuilderVisitor';
			package: #'TopicBuilderVisitorTest' with: [ spec requires: #('TopicBuilderVisitor'). ]
		]
]
