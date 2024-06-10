import 'package:macros/macros.dart';

/// The result of an introspection on [fieldDeclaration].
sealed class FieldIntrospectionData {
  /// The declaration of the field.
  final FieldDeclaration fieldDeclaration;

  /// The field's name.
  final String name;

  // ignore: public_member_api_docs
  FieldIntrospectionData({
    required this.fieldDeclaration,
    required this.name,
  });
}

/// The result of a successful field introspection.
class ResolvedFieldIntrospectionData extends FieldIntrospectionData {
  /// The resolved non-nullable type.
  final StaticType nonNullableStaticType;

  /// The resolved type.
  final StaticType staticType;

  /// The type declaration of the field after following all typedef's.
  final TypeDeclaration unaliasedTypeDeclaration;

  // ignore: public_member_api_docs
  ResolvedFieldIntrospectionData({
    required super.fieldDeclaration,
    required super.name,
    required this.nonNullableStaticType,
    required this.staticType,
    required this.unaliasedTypeDeclaration,
  });
}

/// The result of a failed field introspection.
class FailedFieldIntrospectionData extends FieldIntrospectionData {
  // ignore: public_member_api_docs
  FailedFieldIntrospectionData({
    required super.fieldDeclaration,
    required super.name,
  });
}
