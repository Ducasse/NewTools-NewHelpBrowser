Class {
	#name : #MicrodownClassAPIHelpBuilderTest,
	#superclass : #TestCase,
	#category : #'NewTools-NewHelpBrowser-Tests'
}

{ #category : #tests }
MicrodownClassAPIHelpBuilderTest >> testBuildingTraits [
	| topic |
	topic := MicrodownClassAPIHelpBuilder buildHelpTopicFrom: TSortable.
	self assert: topic subtopics size equals: 2.
	self assert: topic subtopics first title equals: 'Instance side'.
	self assert: topic subtopics last title equals: 'Class side'
]

{ #category : #tests }
MicrodownClassAPIHelpBuilderTest >> testDefaultBuilding [
	| topic |
	topic := MicrodownClassAPIHelpBuilder buildHelpTopicFrom: Integer.
	self assert: topic subtopics size equals: 2.
	self assert: topic subtopics first title equals: 'Instance side'.
	self assert: topic subtopics last title equals: 'Class side'
]

{ #category : #tests }
MicrodownClassAPIHelpBuilderTest >> testMethodsButNoSubclasses [
	| topic |
	topic := MicrodownClassAPIHelpBuilder buildHierarchicalHelpTopicFrom: Integer withSubclasses: false withMethods: true.
	self assert: topic subtopics size equals: 2.
	self assert: topic subtopics first title equals: 'Instance side'.
	self assert: topic subtopics last title equals: 'Class side'
]
