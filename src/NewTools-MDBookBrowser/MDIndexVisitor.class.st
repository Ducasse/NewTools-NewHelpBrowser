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

	(anAnnotation parameters includesKey: 'path') ifTrue: [ 
		indexList add: (anAnnotation parameters at: 'path') ]
]
