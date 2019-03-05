# DMirror
Tool to spawn new job on forked Pharo images. This library allow you to split a workload in several workers consisting on copies of the current Pharo image executed by several Pharo vms.

## How to install

Execute the following code snippet to load DMirror in a fresh Pharo 7 image:

```
Metacello new
    baseline: 'DMirror';
    repository: 'github://ObjectProfile/DMirror/src';
    load.
```

## Example

The following code snippet allow you to split the execution of a `collect:` message in several workers. The library assumes that the code inside the block does not perform side-effects, in case it does, the behavior is not specified.

```Smalltalk
(1 to: 1000) parallelCollect: [ :i | i * 10 ].
```

You can use the method `DMirror class>>defaultCores:` to set the number of workers you wish to have.

## Arbitrary worker execution

DMirror allow users to execute arbitrary pieces of code in different workers. The workers have access to the whole system, all the libraries available in the current image and their globals. Nevertheless, the user may use them as read-only values, because the library behavior is not defined in case of side-effects performed by the user code execution.

The following snippet allow a user to define an arbitrary code to be parallelized in several mirrors or workers. The concrete action of the workers is to remove the spaces in the strings.

```Smalltalk
(DMirror 
	createMirror: [ :obj :id | obj reject: [ :char | char = Character space ] ]
	workloadArray: #('foo bar zork' '1 2 3 4 5')) run.
```

The mirror will spawn a new vm process for each element in the workloadArray, therefore, if the user pass an array with 20 elements, the library will spawn 20 processes. Each process will apply the block to one of the elements of the workloadArray, being it the first argument. The second argument of the block is opcional and corresponds to the position of the element in the workloadArray.

## Collection API

DMirror implements several of the Collection API including: 

- `collect:` -> `parallelCollect:`
- `collect:thenReject:` -> `parallelCollect:thenReject:`
- `collect:thenSelect:` -> `parallelCollect:thenSelect:`
- `select:` -> `parallelSelect:`
- `select:thenCollect:` -> `parallelSelect:thenCollect:`
- `reject:` -> `parallelReject:`
- `reject:thenCollect:` -> `parallelReject:thenCollect:`
- `flatCollect:` -> `parallelFlatCollect:`
- `groupedBy:` -> `parallelGroupedBy:`
- `anySatisfy:` -> `parallelAnySatisfy:`
- `allSatisfy:` -> `parallelAllSatisfy:`
- `noneSatisfy:` -> `parallelNoneSatisfy:`

## Error debugging

In case of errors in the worker execution the library will signal an Error and open a debugger showing the state of all the workers that failed. Those debuggers allow you to inspect the execution, but you will not be able to continue the execution or restart it.
