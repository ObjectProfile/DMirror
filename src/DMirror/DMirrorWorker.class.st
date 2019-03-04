Class {
	#name : #DMirrorWorker,
	#superclass : #Object,
	#instVars : [
		'id',
		'workload',
		'action',
		'filename',
		'imageFilename'
	],
	#category : #DMirror
}

{ #category : #'as yet unclassified' }
DMirrorWorker class >> action: action workload: workload [
	^ self new
			action: action;
			workload: workload;
			yourself
]

{ #category : #'as yet unclassified' }
DMirrorWorker class >> action: action workload: workload id: int [
	^ self new
			id: int;
			action: action;
			workload: workload;
			yourself
]

{ #category : #'as yet unclassified' }
DMirrorWorker class >> action: action workload: workload id: int imageFilename: imageFilename [
	^ self new
			id: int;
			action: action;
			workload: workload;
			imageFilename: imageFilename;
			yourself
]

{ #category : #accessing }
DMirrorWorker >> action [
	^ action
]

{ #category : #accessing }
DMirrorWorker >> action: anObject [
	action := anObject
]

{ #category : #'as yet unclassified' }
DMirrorWorker >> deleteTmpFile [
	self filename asFileReference delete
]

{ #category : #accessing }
DMirrorWorker >> filename [
	^ filename
]

{ #category : #'as yet unclassified' }
DMirrorWorker >> generateImageFile [
	Smalltalk image backupImageInFileNamed: self imageFilename
]

{ #category : #'as yet unclassified' }
DMirrorWorker >> getResult [
	^ FLMaterializer materializeFromFileNamed: filename
]

{ #category : #accessing }
DMirrorWorker >> id [
	^ id
]

{ #category : #accessing }
DMirrorWorker >> id: anObject [
	id := anObject
]

{ #category : #accessing }
DMirrorWorker >> imageFilename [
	^ imageFilename
]

{ #category : #accessing }
DMirrorWorker >> imageFilename: anObject [
	imageFilename := anObject
]

{ #category : #initialization }
DMirrorWorker >> initialize [
	super initialize.
	filename := UUID new printString , '.deleteme'.
	action := #yourself
]

{ #category : #testing }
DMirrorWorker >> isActive [
	^ self pid notNil
]

{ #category : #running }
DMirrorWorker >> run [
	| ans |
	ans := self action cull: workload cull: self id.
	FLSerializer serialize: ans toFileNamed: filename
]

{ #category : #running }
DMirrorWorker >> runOnMirror [
	[ [ 
		self run.
		Smalltalk exit: 0 ] on: Error do: [ Smalltalk exit: 1 ] ] ifCurtailed: [ Smalltalk exit: 1 ]
]

{ #category : #'as yet unclassified' }
DMirrorWorker >> spawnProcessAndWait [
	Smalltalk shortImageName = self imageFilename ifTrue: [ 
		DMirrorProcessNotification signal. 
		^ self ].
	OSSUnixSubprocess new
		command: Smalltalk vm binary fullPath pathString;
		arguments: {
			'--headless'.
			self imageFilename.
			'dmirror'.
			self id asString
			};
		terminateOnShutdown;
		runAndWait
]

{ #category : #accessing }
DMirrorWorker >> workload [
	^ workload
]

{ #category : #accessing }
DMirrorWorker >> workload: anObject [
	workload := anObject
]
