Extension { #name : #Array }

{ #category : #'*DMirror' }
Array >> parallelCollect: aBlock inCores: numberOfCores [
	^ (DMirror 
			runMirror: [ :anArray | anArray collect: aBlock ]
			workloadArray: (DMirror splitArray: self inParts: numberOfCores)) flatCollect: #yourself
]
