Class {
	#name : #BaselineOfDMirror,
	#superclass : #BaselineOf,
	#category : #BaselineForDMirror
}

{ #category : #baselines }
BaselineOfDMirror >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [			
			spec
				baseline: 'OSSubprocess' 
				with: [ 
					spec repository: 'github://pharo-contributions/OSSubprocess:v1.0.0/repository' ].
			spec
				package: 'DMirror' with: [ spec requires: 'OSSubprocess' ]
			 ]
]
