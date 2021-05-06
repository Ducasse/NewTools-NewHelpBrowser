Class {
	#name : #BaselineOfNewHelpBrowser,
	#superclass : #BaselineOf,
	#category : #BaselineOfNewHelpBrowser
}

{ #category : #baselines }
BaselineOfNewHelpBrowser >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			package: #'NewTools-NewHelpBrowser'
			with: [ spec requires: #( #'NewTools-HelpTopicBuilder' ) ];
			package: #'NewTools-NewHelpBrowser-Tests' with: [ 
				spec requires:
						#( #'NewTools-NewHelpBrowser' #'NewTools-HelpTopicBuilder' ) ];
			package: #'NewTools-HelpTopicBuilder';
			package: #'NewTools-HelpTopicBuilder-Tests'
			with: [ spec requires: #( #'NewTools-HelpTopicBuilder' ) ] ]
]
