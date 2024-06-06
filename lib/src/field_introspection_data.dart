import 'package:macros/macros.dart';

/// All useful data that can be obtained for a [FieldDeclaration].
class FieldIntrospectionData {
  /// The declaration of the field.
  final FieldDeclaration fieldDeclaration;

  /// The field's name.
  final String name;

  /// The resolved non-nullable type.
  final StaticType nonNullableStaticType;

  /// The resolved type.
  final StaticType staticType;

  /// The type declaration of the field after following all typedef's.
  final TypeDeclaration unaliasedTypeDeclaration;

  // ignore: public_member_api_docs
  FieldIntrospectionData({
    required this.fieldDeclaration,
    required this.name,
    required this.nonNullableStaticType,
    required this.staticType,
    required this.unaliasedTypeDeclaration,
  });
}
