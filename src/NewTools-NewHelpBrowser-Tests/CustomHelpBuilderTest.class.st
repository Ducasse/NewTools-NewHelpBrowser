Class {
	#name : #CustomHelpBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'filesystem',
		'window'
	],
	#category : #'NewTools-NewHelpBrowser-Tests'
}

{ #category : #tests }
CustomHelpBuilderTest >> testCreateTopicFrom [
	| topic |
	topic := CustomHelpHelpBuilder new createTopicFrom: HelpOnHelp.
	self assert: topic title equals: 'Help on Help'.
	self assert: topic subtopics size equals: 3.
]
