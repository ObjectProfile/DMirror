Class {
	#name : #DMirrorWorker,
	#superclass : #Object,
	#instVars : [
		'id',
		'workload',
		'action',
		'filename',
		'imageFilename',
		'result',
		'process'
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

{ #category : #actions }
DMirrorWorker >> deleteTmpFile [
	self filename asFileReference deleteIfAbsent: []
]

{ #category : #accessing }
DMirrorWorker >> filename [
	^ filename
]

{ #category : #actions }
DMirrorWorker >> getResult [
	^ result := FLMaterializer materializeFromFileNamed: filename
]

{ #category : #testing }
DMirrorWorker >> hasError [
	^ self result isContext
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
DMirrorWorker >> primitiveRun [
	| ans |
	ans := self action cull: workload cull: self id.
	FLSerializer serialize: ans toFileNamed: filename
]

{ #category : #accessing }
DMirrorWorker >> result [
	^ result
]

{ #category : #running }
DMirrorWorker >> runOnMirror [
	[ [ 
		self primitiveRun.
		Smalltalk exit: 0 ] 
			on: Error 
			do: [ :e |
				FLDebuggerStackSerializer 
					FLDebuggerStackSerializer: e signalerContext 
					toFileNamed: self filename.
				Smalltalk exit: 0 ] ] ifCurtailed: [ Smalltalk exit: 1 ]
]

{ #category : #actions }
DMirrorWorker >> spawnProcessAndWait [
	| count |
	count := 0.
	[ count < 5 and: [ filename asFileReference exists not ] ] whileTrue: [ 
		count := count + 1.
		count > 1 ifTrue: [ 
			Transcript show: 'Retrying worker ' , id asString , ' for the' , count asString , ' time.' ].
		Smalltalk shortImageName = self imageFilename ifTrue: [ 
			DMirrorProcessNotification signal. 
			^ self ].
		process := OSSUnixSubprocess new
			command: Smalltalk vm binary fullPath pathString;
			arguments: {
				'--headless'.
				self imageFilename.
				'dmirror'.
				self id asString
				};
			"redirectStderr;" "Do not redirect stdout or stderr because it will cause deadlocks."
			terminateOnShutdown.
		process runAndWait.
		]
]

{ #category : #accessing }
DMirrorWorker >> workload [
	^ workload
]

{ #category : #accessing }
DMirrorWorker >> workload: anObject [
	workload := anObject
]
