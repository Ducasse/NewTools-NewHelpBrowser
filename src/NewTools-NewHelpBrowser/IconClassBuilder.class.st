Class {
	#name : #IconClassBuilder,
	#superclass : #Object,
	#category : #'NewTools-NewHelpBrowser'
}

{ #category : #build }
IconClassBuilder >> buildIcon: aTopic [
	^ aTopic icon: (self class environment at: aTopic title asSymbol) systemIcon
]
