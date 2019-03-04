Extension { #name : #Array }

{ #category : #'*DMirror' }
Array >> parallelCollect: aBlock inCores: numberOfCores [
	^ DMirror 
			runMirror: aBlock
			workloadArray: (DMirror splitArray: self inParts: numberOfCores)
]
