Class {
	#name : #DMirrorTest,
	#superclass : #TestCase,
	#instVars : [
		'worker'
	],
	#category : #DMirror
}

{ #category : #tests }
DMirrorTest >> testSimpleWorkload [
	self 
		assert:(DMirror 
			createMirror: [ :obj :id | obj * 3 ] 
			workloadArray: #(1 5)) run
		equals: #(3 15)
]
