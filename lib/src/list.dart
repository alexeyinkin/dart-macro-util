// ignore: public_member_api_docs
extension MacroUtilListExtension on List<Object> {
  /// Indents code parts.
  ///
  /// ```dart
  /// builder.declareInLibrary(
  ///   DeclarationCode.fromParts([
  ///     'augment class Foo {\n',
  ///     ..._getMyMethodParts().indent(),
  ///     '}\n',
  ///   ]),
  /// );
  /// ```
  List<Object> indent([int indent = 2]) {
    final indentation = ' ' * indent;
    bool indentNext = true;
    final result = <Object>[];

    for (final part in this) {
      if (indentNext) {
        result.add(indentation);
      }
      result.add(part);
      indentNext = part is String && part.endsWith('\n');
    }

    return result;
  }
}
