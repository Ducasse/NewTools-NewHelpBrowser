Class {
	#name : #MicrodownisedHelp,
	#superclass : #Object,
	#category : #'NewTools-NewHelpBrowser'
}

{ #category : #conversion }
MicrodownisedHelp class >> asHelpTopic [ 
	<systemHelp>
	
	^MicrodownStyleHelpBuilder new build topicToBuild
]
