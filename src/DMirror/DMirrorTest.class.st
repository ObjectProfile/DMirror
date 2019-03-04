Class {
	#name : #DMirrorTest,
	#superclass : #TestCase,
	#instVars : [
		'worker'
	],
	#category : #DMirror
}

{ #category : #tests }
DMirrorTest >> tearDown [
	worker ifNil: [ 
		worker isActive ifTrue: [ worker waitPid ].
		worker filename asFileReference deleteIfAbsent: [  ] ]
]
