import 'package:macros/macros.dart';

import 'field_introspection_data.dart';

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

  /// Introspects [type] and returns [FieldIntrospectionData] for all its fields
  /// mapped by their names.
  Future<Map<String, FieldIntrospectionData>> introspectType(
    TypeDeclaration type,
  ) async {
    final fields = await fieldsOf(type);
    final futures = <String, Future<FieldIntrospectionData?>>{};

    for (final field in fields) {
      futures[field.identifier.name] = introspectField(field);
    }

    return (await _waitMap(futures)).whereNotNull();
  }

  /// Introspects the [field].
  Future<FieldIntrospectionData?> introspectField(
    FieldDeclaration field,
  ) async {
    final type = _checkNamedType(field);

    if (type == null) {
      return null;
    }

    final (staticType, typeDecl) = await (
      resolve(type.code),
      unaliasedTypeDeclarationOf(type),
    ).wait;

    final nonNullableStaticType =
        type.isNullable ? await resolve(type.code.asNonNullable) : staticType;

    return FieldIntrospectionData(
      fieldDeclaration: field,
      name: field.identifier.name,
      nonNullableStaticType: nonNullableStaticType,
      staticType: staticType,
      unaliasedTypeDeclaration: typeDecl,
    );
  }

  NamedTypeAnnotation? _checkNamedType(
    FieldDeclaration field,
  ) {
    final type = field.type;

    if (type is NamedTypeAnnotation) {
      return type;
    }

    report(
      Diagnostic(
        DiagnosticMessage(
          'Only fields with explicit named types are allowed here, '
          '$type given.',
          target: field.asDiagnosticTarget,
        ),
        Severity.error,
      ),
    );

    return null;
  }
}

Future<Map<K, V>> _waitMap<K, V>(Map<K, Future<V>> futures) async {
  final keys = futures.keys.toList(growable: false);
  final values = await Future.wait(futures.values);
  final n = futures.length;

  return {
    for (int i = 0; i < n; i++) keys[i]: values[i],
  };
}

extension _NullableMapExtension<K, V> on Map<K, V?> {
  Map<K, V> whereNotNull() {
    return {
      for (final entry in entries)
        if (entry.value is V) entry.key: entry.value as V,
    };
  }
}
