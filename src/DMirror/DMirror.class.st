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
		'Action',
		'CurrentInstance',
		'Filename',
		'WorkLoadArray'
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

{ #category : #'public-api' }
DMirror class >> parallelizeAction: aBlock onWorkLoad: anArray [
	^ self runMirror: aBlock workloadArray: anArray
]

{ #category : #'public-api' }
DMirror class >> runMirror: aBlock workloadArray: arrayOfObjects [
	^ (self createMirror: aBlock workloadArray: arrayOfObjects) run
]

{ #category : #accessing }
DMirror >> action [
	^ action
]

{ #category : #accessing }
DMirror >> action: anObject [
	action := anObject
]

{ #category : #'as yet unclassified' }
DMirror >> changesFilename [
	 ^ imageBasename , '.changes'
]

{ #category : #'as yet unclassified' }
DMirror >> cleanTmpFiles [
	self workers do: #deleteTmpFile.
	self imageFilename asFileReference delete.
	self changesFilename asFileReference delete.
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
DMirror >> getResults [
	results := self workers collect: #getResult
]

{ #category : #'as yet unclassified' }
DMirror >> imageFilename [
	 ^ imageBasename , '.image'
]

{ #category : #initialization }
DMirror >> initialize [
	super initialize.
	imageBasename := UUID new printString , '.deleteme'.
]

{ #category : #'as yet unclassified' }
DMirror >> run [
	^ self spawnProcessesAndWait
]

{ #category : #'as yet unclassified' }
DMirror >> spawnProcessesAndWait [
	| semaphores |
	[ 
		self generateImage.
		semaphores := self workers collect: [ :worker | | semaphore |
			semaphore := Semaphore new.
			[ [ worker spawnProcessAndWait ] ensure: [ semaphore signal ] ] fork.
			semaphore ].
		semaphores do: #wait.
		self getResults.
		self cleanTmpFiles 
	] on: DMirrorProcessNotification do: [ :e | ^ nil ].
	^ results
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
