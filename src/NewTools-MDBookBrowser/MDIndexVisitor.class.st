Class {
	#name : #MDIndexVisitor,
	#superclass : #MicrodownVisitor,
	#instVars : [
		'indexList'
	],
	#category : #'NewTools-MDBookBrowser'
}

{ #category : #initialization }
MDIndexVisitor >> indexList [

	^ indexList
]

{ #category : #initialization }
MDIndexVisitor >> initialize [

	super initialize.
	indexList := OrderedCollection new
]

{ #category : #initialization }
MDIndexVisitor >> visitEnvironment: anEnvironment [
	(anEnvironment arguments includesKey: 'path') ifTrue: [ 
		indexList add: (anEnvironment arguments at: 'path') ]
]

{ #category : #'visiting - inline elements' }
MDIndexVisitor >> visitText: aMicTextBlock [

	
]
