Helpers and utilities for developing macros.

# Log information in into the augmenting library as code comments

```dart
builder.log('Got here.');
```

Output:
```dart
// Got here.
```

# Introspect all fields of a type

```dart
final map = await builder.introspectFields(clazz);
final type = map['fieldName']!.typeDeclaration;
```

# Indent the generated code

```dart
builder.declareInLibrary(
  DeclarationCode.fromParts([
    'augment class Foo {\n',
    ..._getMyMethodParts().indent(), // Adds 2 spaces before each line of the code.
    '}\n',
  ]),
);
```

# Report errors with 5 less lines of code

```dart
builder.reportError('Error message', target: target);
```

...instead of

```dart
builder.report(
  Diagnostic(
    DiagnosticMessage('Error message', target: target),
    Severity.error,
  ),
);
```
