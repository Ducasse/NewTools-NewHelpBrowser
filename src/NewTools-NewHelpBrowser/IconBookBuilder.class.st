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
IconBookBuilder >> buildIcon: aTopic [
	^ aTopic icon 
		ifNil: [ aTopic iconName: pageIcon ]
		ifNotNil: [ aTopic iconName: bookIcon ]
]

{ #category : #initialization }
IconBookBuilder >> initialize [
	super initialize.
	bookIcon := #bookIcon.
	pageIcon := #pageIcon
]
