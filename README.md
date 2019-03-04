# DMirror
Tool to spawn new job on forked Pharo images


## Example

```Smalltalk
(1 to: 1000) parallelCollect: [ :i | i * 10 ].
```

You can use the method `DMirror class>>defaultCores:` to set the number of workers you wish to have.
