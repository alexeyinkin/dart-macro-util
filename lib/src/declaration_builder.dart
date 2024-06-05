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

  /// Returns the [ClassDeclaration] for the superclass of [clazz]
  /// unless it's [Object] explicitly or implicitly.
  Future<ClassDeclaration?> nonObjectSuperclassDeclarationOf(
    ClassDeclaration clazz,
  ) async {
    final superclass = clazz.superclass;

    if (superclass == null) {
      return null;
    }

    final superType =
        await resolve(NamedTypeAnnotationCode(name: superclass.identifier));

    final objectType = await _getObjectType();
    final isExtendingObject = await superType.isExactly(objectType);

    if (isExtendingObject) {
      return null;
    }

    final result = await unaliasedTypeDeclarationOf(superclass);

    if (result is! ClassDeclaration) {
      report(
        Diagnostic(
          DiagnosticMessage(
            'Cannot resolve the superclass.',
            target: clazz.asDiagnosticTarget,
          ),
          Severity.error,
        ),
      );

      throw Exception('Cannot resolve the superclass.');
    }

    return result;
  }

  Future<StaticType> _getObjectType() async {
    return resolve(
      NamedTypeAnnotationCode(
        // ignore: deprecated_member_use
        name: await resolveIdentifier(Uri.parse('dart:core'), 'Object'),
      ),
    );
  }
}
