// Mocks generated by Mockito 5.3.0 from annotations
// in crumbs/test/local_storage_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:io' as _i2;

import 'package:crumbs/utilities/local_storage.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFile_0 extends _i1.SmartFake implements _i2.File {
  _FakeFile_0(Object parent, Invocation parentInvocation)
      : super(parent, parentInvocation);
}

/// A class which mocks [LocalStorage].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalStorage extends _i1.Mock implements _i3.LocalStorage {
  MockLocalStorage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<String> get documentsDirectory =>
      (super.noSuchMethod(Invocation.getter(#documentsDirectory),
          returnValue: _i4.Future<String>.value('')) as _i4.Future<String>);
  @override
  _i4.Future<_i2.File> createFile(String? filePath) => (super.noSuchMethod(
          Invocation.method(#createFile, [filePath]),
          returnValue: _i4.Future<_i2.File>.value(
              _FakeFile_0(this, Invocation.method(#createFile, [filePath]))))
      as _i4.Future<_i2.File>);
  @override
  _i4.Future<_i2.File> writeContent(String? content, _i2.File? file) =>
      (super.noSuchMethod(Invocation.method(#writeContent, [content, file]),
              returnValue: _i4.Future<_i2.File>.value(_FakeFile_0(
                  this, Invocation.method(#writeContent, [content, file]))))
          as _i4.Future<_i2.File>);
  @override
  _i4.Future<String> readContent(_i2.File? file) =>
      (super.noSuchMethod(Invocation.method(#readContent, [file]),
          returnValue: _i4.Future<String>.value('')) as _i4.Future<String>);
}