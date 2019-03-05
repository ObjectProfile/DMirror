Extension { #name : #Collection }

{ #category : #'*DMirror' }
Collection >> parallelAllSatisfy: aBlock [
	^ (DMirror 
			runMirror: [ :anArray | anArray allSatisfy: aBlock ]
			workloadArray: (DMirror splitArray: self asArray)) allSatisfy: #yourself
]

{ #category : #'*DMirror' }
Collection >> parallelAnySatisfy: aBlock [
	^ (DMirror 
			runMirror: [ :anArray | anArray anySatisfy: aBlock ]
			workloadArray: (DMirror splitArray: self asArray)) anySatisfy: #yourself
]

{ #category : #'*DMirror' }
Collection >> parallelCollect: aBlock [
	^ (DMirror 
			runMirror: [ :anArray | anArray collect: aBlock ]
			workloadArray: (DMirror splitArray: self asArray)) flatCollect: #yourself
]

{ #category : #'*DMirror' }
Collection >> parallelCollect: collectBlock thenReject: rejectBlock [
	^ (DMirror 
			runMirror: [ :anArray | anArray collect: collectBlock thenReject: rejectBlock ]
			workloadArray: (DMirror splitArray: self asArray))
				flatCollect: #yourself
]

{ #category : #'*DMirror' }
Collection >> parallelCollect: collectBlock thenSelect: selectBlock [
	^ (DMirror 
			runMirror: [ :anArray | anArray collect: collectBlock thenSelect: selectBlock ]
			workloadArray: (DMirror splitArray: self asArray))
				flatCollect: #yourself
]

{ #category : #'*DMirror' }
Collection >> parallelFlatCollect: aBlock [
	^ (DMirror 
			runMirror: [ :anArray | anArray flatCollect: aBlock ]
			workloadArray: (DMirror splitArray: self asArray)) flatCollect: #yourself
]

{ #category : #'*DMirror' }
Collection >> parallelGroupedBy: aBlock [
	| dict result |
	dict := Dictionary new.
	result := DMirror 
			runMirror: [ :anArray | (anArray groupedBy: aBlock) associations ]
			workloadArray: (DMirror splitArray: self asArray).
	 result do: [ :localDict | 
		localDict do: [ :assoc |
			(dict 
				at: assoc key 
				ifAbsentPut: [ OrderedCollection new ]) addAll: assoc value ] ].
	^ dict
]

{ #category : #'*DMirror' }
Collection >> parallelNoneSatisfy: aBlock [
	^ (DMirror 
			runMirror: [ :anArray | anArray noneSatisfy: aBlock ]
			workloadArray: (DMirror splitArray: self asArray)) allSatisfy: #yourself
]

{ #category : #'*DMirror' }
Collection >> parallelReject: aBlock [
	^ (DMirror 
			runMirror: [ :anArray | anArray reject: aBlock ]
			workloadArray: (DMirror splitArray: self asArray)) flatCollect: #yourself
]

{ #category : #'*DMirror' }
Collection >> parallelReject: rejectBlock thenCollect: collectBlock [
	^ (DMirror 
			runMirror: [ :anArray | anArray reject: rejectBlock thenCollect: collectBlock ]
			workloadArray: (DMirror splitArray: self asArray))
				flatCollect: #yourself
]

{ #category : #'*DMirror' }
Collection >> parallelSelect: aBlock [
	^ (DMirror 
			runMirror: [ :anArray | anArray select: aBlock ]
			workloadArray: (DMirror splitArray: self asArray)) flatCollect: #yourself
]

{ #category : #'*DMirror' }
Collection >> parallelSelect: selectBlock thenCollect: collectBlock [
	^ (DMirror 
			runMirror: [ :anArray | anArray select: selectBlock thenCollect: collectBlock ]
			workloadArray: (DMirror splitArray: self asArray))
				flatCollect: #yourself
]
