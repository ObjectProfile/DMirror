Class {
	#name : #DMirror,
	#superclass : #Object,
	#instVars : [
		'workloadArray',
		'action',
		'workers',
		'results',
		'imageBasename'
	],
	#classVars : [
		'CurrentInstance',
		'DefaultCores'
	],
	#category : #DMirror
}

{ #category : #'public-api' }
DMirror class >> createMirror: aBlock workloadArray: arrayOfObjects [
	self currentInstance: (DMirror new
										action: aBlock;
										workloadArray: arrayOfObjects;
										generateWorkers;
										yourself).
	^ self currentInstance
]

{ #category : #accessing }
DMirror class >> currentInstance [
	^ CurrentInstance
]

{ #category : #accessing }
DMirror class >> currentInstance: anObject [
	CurrentInstance := anObject
]

{ #category : #accessing }
DMirror class >> defaultCores [
	^ DefaultCores ifNil: [ DefaultCores := 2 ]
]

{ #category : #accessing }
DMirror class >> defaultCores: anObject [
	DefaultCores := anObject
]

{ #category : #'public-api' }
DMirror class >> parallelizeAction: aBlock onWorkLoad: anArray [
	^ self runMirror: aBlock workloadArray: anArray
]

{ #category : #'public-api' }
DMirror class >> runMirror: aBlock workloadArray: arrayOfObjects [
	^ (self createMirror: aBlock workloadArray: arrayOfObjects) run
]

{ #category : #'public-api' }
DMirror class >> splitArray: anArray [
	^ self splitArray: anArray inParts: DMirror defaultCores
]

{ #category : #'public-api' }
DMirror class >> splitArray: anArray inParts: anInteger [
	| step result |
	step := (anArray size / anInteger) floor.
	result := OrderedCollection new.
	1 to: anInteger - 1 do: [ :i | 
		result add: (anArray copyFrom: ((i - 1) * step) + 1 to: i * step) ].
	result add: (anArray copyFrom: ((anInteger - 1) * step) + 1 to: anArray size).
	^ result
]

{ #category : #accessing }
DMirror >> action [
	^ action
]

{ #category : #accessing }
DMirror >> action: anObject [
	action := anObject
]

{ #category : #actions }
DMirror >> changesFilename [
	 ^ imageBasename , '.changes'
]

{ #category : #actions }
DMirror >> cleanTmpFiles [
	self workers do: #deleteTmpFile.
	self imageFilename asFileReference deleteIfAbsent: [].
	self changesFilename asFileReference delete deleteIfAbsent: [].
]

{ #category : #actions }
DMirror >> generateImage [
	Smalltalk image backupImageInFileNamed: self imageFilename.
	Smalltalk shortImageName = self imageFilename ifTrue: [ 
		DMirrorProcessNotification signal ]
]

{ #category : #accessing }
DMirror >> generateWorkers [
	self workers: (workloadArray collectWithIndex: [ :workload :id | 
												DMirrorWorker 
													action: action 
													workload: workload 
													id: id
													imageFilename: self imageFilename ])
]

{ #category : #accessing }
DMirror >> getResults [
	| workersWithErrors |
	self workers do: #getResult.
	workersWithErrors := self workers select: #hasError.
	workersWithErrors ifNotEmpty: [ 
		(DMirrorExternalError on: workersWithErrors) signal ]
]

{ #category : #accessing }
DMirror >> imageFilename [
	 ^ imageBasename , '.image'
]

{ #category : #initialization }
DMirror >> initialize [
	super initialize.
	imageBasename := UUID new printString , '.deleteme'.
]

{ #category : #accessing }
DMirror >> results [
	^ self workers collect: #result
]

{ #category : #actions }
DMirror >> run [
	^ self spawnProcessesAndWait
]

{ #category : #actions }
DMirror >> spawnProcessesAndWait [
	| semaphores |
	[ 
		[ self generateImage.
		semaphores := self workers collect: [ :worker | | semaphore |
			semaphore := Semaphore new.
			[ [ worker spawnProcessAndWait ] ensure: [ semaphore signal ] ] fork.
			semaphore ].
		semaphores do: #wait.
		self getResults. ] ensure: [ self cleanTmpFiles ]
	] on: DMirrorProcessNotification do: [ :e | Semaphore new wait ].
	^ self results
]

{ #category : #accessing }
DMirror >> workers [
	^ workers
]

{ #category : #accessing }
DMirror >> workers: anObject [
	workers := anObject
]

{ #category : #accessing }
DMirror >> workloadArray [
	^ workloadArray
]

{ #category : #accessing }
DMirror >> workloadArray: anObject [
	workloadArray := anObject
]
