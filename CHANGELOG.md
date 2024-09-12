## 0.1.0-13.dev

* Enabled `ResolveIdentifiers` to resolve `Future`, `Object`, `bool`, `int`.

## 0.1.0-12.dev

* Recognize [`FieldPath`](https://pub.dev/documentation/cloud_firestore_platform_interface/latest/cloud_firestore_platform_interface/FieldPath-class.html) identifier of [`cloud_firestore_platform_interface`](https://pub.dev/packages/cloud_firestore_platform_interface).
* Recognize `AbstractFilter` and `QuerySourceType` of [`model_fetch_firestore`](https://pub.dev/packages/model_fetch_firestore) package.
* Require Dart 3.5 stable or above.

## 0.1.0-11.dev

* Renamed `unaliasedTypeDeclarationOf` and `unaliasedTypeDeclaration` to `deAliased...`, added deprecated aliases.

## 0.1.0-10.dev

* Added `@ResolveIdentifiers()` macro.

## 0.1.0-9.dev

* Added `FieldIntrospectionData.constructorOptionality` and `FieldIntrospectionData.constructorHandling`.

## 0.1.0-8.dev

* Return `FieldIntrospectionData` for `OmittedTypeAnnotation` instead of a diagnostic.

## 0.1.0-7.dev

* Deleted `FailedFieldIntrospectionData`.

## 0.1.0-6.dev

* Added `ResolvedFieldIntrospectionData`, `FailedFieldIntrospectionData`.

## 0.1.0-5.dev

* Added `Builder.reportError` extension method.
* Catching exceptions in `introspectField`.
* Renamed `introspectType` to `introspectFields`.

## 0.1.0-4.dev

* Added `FieldIntrospectionData.nonNullableStaticType`.
* Improved diagnostic messages.

## 0.1.0-3.dev

* Moved `introspectType` and `introspectField` to `MacroUtilDeclarationBuilderExtension`.
* Added `FieldIntrospectionData.StaticType`.

## 0.1.0-2.dev

* Added `DeclarationBuilder.nonObjectSuperclassDeclarationOf`.
* Changed `MacroUtilListExtension` to `MacroUtilIterableExtension`.

## 0.1.0-1.dev

* Initial release.
