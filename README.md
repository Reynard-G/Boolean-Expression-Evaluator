# Boolean Expression Evaluator

A simple boolean expression evaluator for the Swift CLI.

## Examples

```console
foo@bar:~$ run
((not true and true) and (true or true) and (true and true))
RESULT: FALSE
not false
RESULT: TRUE
true and (false or true)
RESULT: TRUE
```

## Features

* Supports boolean operators `and` and `or`
* Supports negation of results with the `not` operator
* Supports evaluation of boolean expressions with parenthesis for grouping and precedence
