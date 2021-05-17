Class {
	#name : #IconClassBuilder,
	#superclass : #Object,
	#category : #'NewTools-NewHelpBrowser'
}

{ #category : #'as yet unclassified' }
IconClassBuilder >> buildIcon: aTopic [
	aTopic icon: aTopic title asClass systemIcon
]
