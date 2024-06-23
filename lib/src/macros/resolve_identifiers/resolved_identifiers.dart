// ignore_for_file: public_member_api_docs
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use

import 'dart:core' as core;

import 'package:macros/macros.dart' as m;

import '../../libraries.dart';

class ResolvedIdentifiers {
  final m.Identifier DeclarationBuilder;
  final m.Identifier Future;
  final m.Identifier Uri;

  ResolvedIdentifiers({
    required this.DeclarationBuilder,
    required this.Future,
    required this.Uri,
  });

  static core.Future<ResolvedIdentifiers> resolve(
    m.DeclarationBuilder builder,
  ) async {
    final (
      DeclarationBuilder,
      Future,
      Uri,
    ) = await (
      builder.resolveIdentifier(Libraries.macrosApi, 'DeclarationBuilder'),
      builder.resolveIdentifier(Libraries.async, 'Future'),
      builder.resolveIdentifier(Libraries.core, 'Uri'),
    ).wait;

    return ResolvedIdentifiers(
      DeclarationBuilder: DeclarationBuilder,
      Future: Future,
      Uri: Uri,
    );
  }
}
