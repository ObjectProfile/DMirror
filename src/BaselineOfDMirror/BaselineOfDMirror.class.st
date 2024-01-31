Class {
	#name : #BaselineOfDMirror,
	#superclass : #BaselineOf,
	#category : #BaselineOfDMirror
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
					spec repository: 'github://pharo-contributions/OSSubprocess:master/repository' ].
			spec
				package: 'DMirror' with: [ spec requires: 'OSSubprocess' ]
			 ]
]
