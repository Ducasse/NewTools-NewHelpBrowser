Class {
	#name : #IconClassBuilder,
	#superclass : #Object,
	#category : #'NewTools-IconBuilder'
}

{ #category : #build }
IconClassBuilder >> buildIcon: aTopic [
	^ aTopic icon: (self class environment at: aTopic title asSymbol) systemIcon
]
