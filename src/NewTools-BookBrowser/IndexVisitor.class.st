Class {
	#name : #IndexVisitor,
	#superclass : #PRVisitor,
	#instVars : [
		'indexList'
	],
	#category : #'NewTools-BookBrowser'
}

{ #category : #accessing }
IndexVisitor >> indexList [
	^ indexList
]

{ #category : #initialization }
IndexVisitor >> initialize [
	super initialize.
	indexList := OrderedCollection new
]

{ #category : #visiting }
IndexVisitor >> visitInputFileAnnotation: anInput [
	(anInput parameters includesKey: 'path')
		ifTrue:[indexList add: (anInput parameters at: 'path')].
	
]
