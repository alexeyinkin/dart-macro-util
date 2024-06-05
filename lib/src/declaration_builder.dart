import 'package:macros/macros.dart';

// ignore: public_member_api_docs
extension MacroUtilDeclarationBuilderExtension on DeclarationBuilder {
  /// Logs [obj] as a comment in the library's global code.
  void log(Object? obj) {
    declareInLibrary(DeclarationCode.fromString('// $obj'));
  }

  /// Follows the declaration of [type] through any type aliases.
  Future<TypeDeclaration> unaliasedTypeDeclarationOf(
    NamedTypeAnnotation type,
  ) async {
    var typeDecl = await typeDeclarationOf(type.identifier);

    while (typeDecl is TypeAliasDeclaration) {
      final aliasedType = typeDecl.aliasedType;

      if (aliasedType is! NamedTypeAnnotation) {
        report(
          Diagnostic(
            DiagnosticMessage(
              'Can only follow aliases on fields with explicit named types.',
              target: type.asDiagnosticTarget,
            ),
            Severity.error,
          ),
        );

        throw Exception(
          'Can only follow aliases on fields with explicit named types.',
        );
      }

      typeDecl = await typeDeclarationOf(aliasedType.identifier);
    }

    return typeDecl;
  }
}
