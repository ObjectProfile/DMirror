Class {
	#name : #DMirrorExternalError,
	#superclass : #Error,
	#instVars : [
		'workers'
	],
	#category : #DMirror
}

{ #category : #'instance creation' }
DMirrorExternalError class >> on: aWorkers [
	^ self new
		workers: aWorkers;
		yourself
]

{ #category : #accessing }
DMirrorExternalError >> messageText [
	"Return an exception's message text."

	^ String streamContents: [ :str |
		str << 'An error has ocurred on external workers with ids: '.
		workers 
			do: [ :worker | str << worker id asString ]
			separatedBy: [ str << ', ' ] ]
]

{ #category : #accessing }
DMirrorExternalError >> workers [
	^ workers
]

{ #category : #accessing }
DMirrorExternalError >> workers: anObject [
	workers := anObject
]
