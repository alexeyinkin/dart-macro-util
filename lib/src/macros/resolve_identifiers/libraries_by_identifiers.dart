const _core = 'dart:core';
const _cloudFirestore = 'package:cloud_firestore/cloud_firestore.dart';
const _modelFetchFirestoreLoaderFactoriesAbstract =
    'package:model_fetch_firestore/src/loader_factories/abstract.dart';
const _modelFetchFirestoreQueryBuilder =
    'package:model_fetch_firestore/src/query_builder.dart';

/// Translates common identifiers to the libraries where they are defined.
const librariesByIdentifiers = {
  'AbstractFirestoreLoaderFactory': _modelFetchFirestoreLoaderFactoriesAbstract,
  'CollectionReference': _cloudFirestore,
  'DocumentSnapshot': _cloudFirestore,
  'FirebaseFirestore': _cloudFirestore,
  'Map': _core,
  'Query': _cloudFirestore,
  'QueryBuilder': _modelFetchFirestoreQueryBuilder,
  'SnapshotOptions': _cloudFirestore,
  'String': _core,
  'UnimplementedError': _core,
  'dynamic': _core,
  'override': _core,
};
