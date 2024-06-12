import 'package:macros/macros.dart';

/// The result of an introspection on [fieldDeclaration].
class FieldIntrospectionData {
  /// The declaration of the field.
  final FieldDeclaration fieldDeclaration;

  /// The field's name.
  final String name;

  // ignore: public_member_api_docs
  FieldIntrospectionData({
    required this.fieldDeclaration,
    required this.name,
  });

  /// Whether this field can or must be initialized.
  FieldConstructorOptionality get constructorOptionality {
    if (fieldDeclaration.hasStatic) {
      return FieldConstructorOptionality.disallowed;
    }

    if (fieldDeclaration.hasInitializer) {
      return fieldDeclaration.hasFinal
          ? FieldConstructorOptionality.disallowed
          : FieldConstructorOptionality.optional;
    }

    return fieldDeclaration.type.isNullable
        ? FieldConstructorOptionality.optional
        : FieldConstructorOptionality.required;
  }

  /// How this field should be handled by generated constructors.
  FieldConstructorHandling get constructorHandling {
    if (constructorOptionality == FieldConstructorOptionality.disallowed) {
      return FieldConstructorHandling.none;
    }

    return name.startsWith('_')
        ? FieldConstructorHandling.positional
        : FieldConstructorHandling.namedOrPositional;
  }
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

/// Whether this field can or must be initialized.
enum FieldConstructorOptionality {
  /// This field must be initialized in a constructor.
  required,

  /// This field can be initialized in a constructor.
  optional,

  /// This field cannot be initialized in a constructor.
  disallowed,
}

/// How this field should be handled by generated constructors.
enum FieldConstructorHandling {
  /// This field cannot be in a constructor.
  none,

  /// This field cannot only be a positional argument in a constructor.
  positional,

  /// This field can be either a named or positional argument in a constructor.
  namedOrPositional,
}
