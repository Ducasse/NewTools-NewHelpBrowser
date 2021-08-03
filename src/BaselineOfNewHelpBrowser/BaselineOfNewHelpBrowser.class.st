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
			baseline: 'Microdown'
			with: [
				spec
					loads: #('RichText');
					repository: 'github://Pillar-markup/Microdown:dev/src' ].
		
		spec
			package: #'NewTools-MDHelpTopicBuilder'
				with: [ spec requires: #( #'Microdown' ) ];
			package: #'NewTools-MDHelpTopicBuilder-Tests'
				with: [ spec requires: #( #'NewTools-MDHelpTopicBuilder' #'NewTools-IconBuilder') ];
				
			package: #'NewTools-MDNewHelpBrowser'
				with: [ spec requires: #( #'NewTools-MDHelpTopicBuilder' ) ];
			package: #'NewTools-MDNewHelpBrowser-Tests' 
				with: [ spec requires: #( #'NewTools-MDNewHelpBrowser' #'NewTools-MDHelpTopicBuilder' #'NewTools-IconBuilder' ) ];
			
			package: #'NewTools-IconBuilder'].
			
			
	
]
