Class {
	#name : #IconClassBuilder,
	#superclass : #Object,
	#category : #'NewTools-NewHelpBrowser'
}

{ #category : #build }
IconClassBuilder >> buildIcon: aTopic [
	^ aTopic icon: aTopic title asClass systemIcon
]
