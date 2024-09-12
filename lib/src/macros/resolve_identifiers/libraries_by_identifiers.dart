const _async = 'dart:async';
const _core = 'dart:core';
const _cloudFirestore = 'package:cloud_firestore/cloud_firestore.dart';
const _cloudFirestorePlatformInterfaceFieldPath =
    'package:cloud_firestore_platform_interface/src/field_path.dart';
const _modelFetchAbstractFilter =
    'package:model_fetch/src/abstract_filter.dart';
const _modelFetchFirestoreLoaderFactoriesAbstract =
    'package:model_fetch_firestore/src/loader_factories/abstract.dart';
const _modelFetchFirestoreQueryBuilder =
    'package:model_fetch_firestore/src/query_builder.dart';
const _modelFetchFirestoreQuerySourceType =
    'package:model_fetch_firestore/src/enums/query_source_type.dart';

/// Translates common identifiers to the libraries where they are defined.
const librariesByIdentifiers = {
  'AbstractFilter': _modelFetchAbstractFilter,
  'AbstractFirestoreLoaderFactory': _modelFetchFirestoreLoaderFactoriesAbstract,
  'CollectionReference': _cloudFirestore,
  'DocumentSnapshot': _cloudFirestore,
  'FieldPath': _cloudFirestorePlatformInterfaceFieldPath,
  'FirebaseFirestore': _cloudFirestore,
  'Future': _async,
  'Map': _core,
  'Object': _core,
  'Query': _cloudFirestore,
  'QueryBuilder': _modelFetchFirestoreQueryBuilder,
  'QuerySourceType': _modelFetchFirestoreQuerySourceType,
  'SnapshotOptions': _cloudFirestore,
  'String': _core,
  'UnimplementedError': _core,
  'bool': _core,
  'dynamic': _core,
  'int': _core,
  'override': _core,
};
