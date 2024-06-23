import 'package:macros/macros.dart';

import '../../declaration_builder.dart';
import '../../field_introspection_data.dart';
import 'libraries_by_identifiers.dart';
import 'resolved_identifiers.dart';

/// Makes a data class of [Identifier] objects and generates `resolve`
/// factory to resolve them and construct the object.
macro class ResolveIdentifiers implements ClassDeclarationsMacro {
  /// Makes a data class of [Identifier] objects and generates `resolve`
  /// factory to resolve them and construct the object.
  const ResolveIdentifiers();

  @override
  Future<void> buildDeclarationsForClass(
    ClassDeclaration clazz,
    MemberDeclarationBuilder builder,
  ) async {
    final intr = await _introspect(clazz, builder);

    builder.declareInType(
      DeclarationCode.fromParts([
        ..._getConstructor(intr),
        ..._getResolve(intr),
      ]),
    );
  }

  List<Object> _getConstructor(_IntrospectionData intr) {
    return [
      //
      intr.clazz.identifier.name, '(',
      if (intr.fields.isNotEmpty) ...[
        //
        '{\n',
        for (final entry in intr.fields.entries) ...[
          //
          '  required this.', entry.key, ',\n',
        ],
        '}',
      ],
      ');\n',
    ];
  }

  List<Object> _getResolve(_IntrospectionData intr) {
    final name = intr.clazz.identifier.name;
    final fields = intr.fields.values.toList(growable: false);

    return [
      //
      'static ', intr.ids.Future, '<', name, '> resolve(',
      intr.ids.DeclarationBuilder, ' builder',
      ') async {\n',

      ..._getResolveLocalVariableCreation(intr),

      'return ', name, '(',
      for (int i = 0; i < intr.fields.length; i++) ...[
        //
        fields[i].name, ': ids[$i],\n',
      ],
      ');\n',
      '}\n',
    ];
  }

  List<Object> _getResolveLocalVariableCreation(_IntrospectionData intr) {
    if (intr.fields.isEmpty) {
      return [];
    }

    final result = <Object>['final ids = await ', intr.ids.Future, '.wait(['];
    for (final field in intr.fields.values) {
      result.addAll(_getResolveIdentifier(intr, field));
    }
    result.add(']);\n');
    return result;
  }

  List<Object> _getResolveIdentifier(
    _IntrospectionData intr,
    FieldIntrospectionData fieldIntr,
  ) {
    return [
      //
      'builder.resolveIdentifier(',
      intr.ids.Uri, '.parse("',
      librariesByIdentifiers[fieldIntr.name]!,
      '"), ',
      '"', fieldIntr.name, '"',
      '),\n',
    ];
  }
}

Future<_IntrospectionData> _introspect(
  ClassDeclaration clazz,
  MemberDeclarationBuilder builder,
) async {
  final (ids, fields) = await (
    ResolvedIdentifiers.resolve(builder),
    builder.introspectFields(clazz),
  ).wait;

  return _IntrospectionData(
    clazz: clazz,
    fields: fields,
    ids: ids,
  );
}

class _IntrospectionData {
  final ClassDeclaration clazz;
  final Map<String, FieldIntrospectionData> fields;
  final ResolvedIdentifiers ids;

  _IntrospectionData({
    required this.clazz,
    required this.fields,
    required this.ids,
  });
}
