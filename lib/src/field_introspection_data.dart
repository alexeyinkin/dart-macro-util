import 'package:macros/macros.dart';

import 'declaration_builder.dart';

/// All useful data that can be obtained for a [FieldDeclaration].
class FieldIntrospectionData {
  /// The declaration of the field.
  final FieldDeclaration fieldDeclaration;

  /// The field's name.
  final String name;

  /// The type declaration of the field after following all typedef's.
  final TypeDeclaration unaliasedTypeDeclaration;

  // ignore: public_member_api_docs
  FieldIntrospectionData({
    required this.fieldDeclaration,
    required this.name,
    required this.unaliasedTypeDeclaration,
  });

  /// Introspects [type] and returns [FieldIntrospectionData] for all its fields
  /// mapped by their names.
  static Future<Map<String, FieldIntrospectionData>> introspectType(
    TypeDeclaration type,
    MemberDeclarationBuilder builder,
  ) async {
    final fields = await builder.fieldsOf(type);
    final futures = <String, Future<FieldIntrospectionData?>>{};

    for (final field in fields) {
      futures[field.identifier.name] = introspectField(field, builder);
    }

    return (await _waitMap(futures)).whereNotNull();
  }

  /// Introspects the [field].
  static Future<FieldIntrospectionData?> introspectField(
    FieldDeclaration field,
    MemberDeclarationBuilder builder,
  ) async {
    final type = _checkNamedType(field.type, builder);

    if (type == null) {
      builder.report(
        Diagnostic(
          DiagnosticMessage(
            'Only classes are supported as field types for serializable '
            'classes',
            target: field.asDiagnosticTarget,
          ),
          Severity.error,
        ),
      );
      return null;
    }

    final typeDecl = await builder.unaliasedTypeDeclarationOf(type);

    return FieldIntrospectionData(
      fieldDeclaration: field,
      name: field.identifier.name,
      unaliasedTypeDeclaration: typeDecl,
    );
  }

  static NamedTypeAnnotation? _checkNamedType(
    TypeAnnotation type,
    Builder builder,
  ) {
    if (type is NamedTypeAnnotation) {
      return type;
    }

    builder.report(
      Diagnostic(
        DiagnosticMessage(
          'Only fields with explicit named types are allowed here.',
          target: type.asDiagnosticTarget,
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
