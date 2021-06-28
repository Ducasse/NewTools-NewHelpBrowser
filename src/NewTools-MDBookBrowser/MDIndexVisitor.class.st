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
MDIndexVisitor >> visitAnnotation: anAnnotation [

	(anAnnotation arguments includesKey: 'path') ifTrue: [ 
		indexList add: (anAnnotation arguments at: 'path') ]
]

{ #category : #'visiting - inline elements' }
MDIndexVisitor >> visitText: aMicTextBlock [

	
]
