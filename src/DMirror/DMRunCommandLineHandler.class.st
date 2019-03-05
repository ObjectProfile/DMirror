Class {
	#name : #DMRunCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #DMirror
}

{ #category : #accessing }
DMRunCommandLineHandler class >> commandName [
	^ 'dmirror'
]

{ #category : #accessing }
DMRunCommandLineHandler class >> description [
	^ 'Run predefined DMirror script. First argument is worker id.'
]

{ #category : #activation }
DMRunCommandLineHandler >> activate [
	| worker workerId |
	workerId := self arguments first asInteger.
	worker := DMirror currentInstance workers at: workerId.
	worker runOnMirror.
	^ self exitSuccess
]
