import 'package:macros/macros.dart';

// ignore: public_member_api_docs
extension BuilderExtension on Builder {
  /// A shortcut for [report] with [Severity.error].
  void reportError(String message, {DiagnosticTarget? target}) {
    report(
      Diagnostic(
        DiagnosticMessage(message, target: target),
        Severity.error,
      ),
    );
  }
}
