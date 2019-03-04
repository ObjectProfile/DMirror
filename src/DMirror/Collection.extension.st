Extension { #name : #Collection }

{ #category : #'*DMirror' }
Collection >> parallelCollect: aBlock [
	^ self parallelCollect: aBlock inCores: DMirror defaultCores
]

{ #category : #'*DMirror' }
Collection >> parallelCollect: aBlock inCores: numberOfCores [
	^ self asArray parallelCollect: aBlock inCores: numberOfCores
]
