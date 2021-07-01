Class {
	#name : #IconBookBuilder,
	#superclass : #Object,
	#instVars : [
		'bookIcon',
		'pageIcon'
	],
	#category : #'NewTools-NewHelpBrowser'
}

{ #category : #build }
IconBookBuilder >> buildBookIcon: aTopic [

	^ aTopic iconName: bookIcon
]

{ #category : #build }
IconBookBuilder >> buildIcon: aTopic [

	self buildBookIcon: aTopic
]

{ #category : #build }
IconBookBuilder >> buildPageIcon: aTopic [
	^ aTopic iconName: pageIcon
]

{ #category : #initialization }
IconBookBuilder >> initialize [
	super initialize.
	bookIcon := #bookIcon.
	pageIcon := #pageIcon
]
