// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthFormState {
  bool get isLoginMode => throw _privateConstructorUsedError;
  bool get isCodeSent => throw _privateConstructorUsedError;
  int get selectedAuthMethod => throw _privateConstructorUsedError;
  String? get verificationId => throw _privateConstructorUsedError;

  /// Create a copy of AuthFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthFormStateCopyWith<AuthFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthFormStateCopyWith<$Res> {
  factory $AuthFormStateCopyWith(
          AuthFormState value, $Res Function(AuthFormState) then) =
      _$AuthFormStateCopyWithImpl<$Res, AuthFormState>;
  @useResult
  $Res call(
      {bool isLoginMode,
      bool isCodeSent,
      int selectedAuthMethod,
      String? verificationId});
}

/// @nodoc
class _$AuthFormStateCopyWithImpl<$Res, $Val extends AuthFormState>
    implements $AuthFormStateCopyWith<$Res> {
  _$AuthFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoginMode = null,
    Object? isCodeSent = null,
    Object? selectedAuthMethod = null,
    Object? verificationId = freezed,
  }) {
    return _then(_value.copyWith(
      isLoginMode: null == isLoginMode
          ? _value.isLoginMode
          : isLoginMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isCodeSent: null == isCodeSent
          ? _value.isCodeSent
          : isCodeSent // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedAuthMethod: null == selectedAuthMethod
          ? _value.selectedAuthMethod
          : selectedAuthMethod // ignore: cast_nullable_to_non_nullable
              as int,
      verificationId: freezed == verificationId
          ? _value.verificationId
          : verificationId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthFormStateImplCopyWith<$Res>
    implements $AuthFormStateCopyWith<$Res> {
  factory _$$AuthFormStateImplCopyWith(
          _$AuthFormStateImpl value, $Res Function(_$AuthFormStateImpl) then) =
      __$$AuthFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoginMode,
      bool isCodeSent,
      int selectedAuthMethod,
      String? verificationId});
}

/// @nodoc
class __$$AuthFormStateImplCopyWithImpl<$Res>
    extends _$AuthFormStateCopyWithImpl<$Res, _$AuthFormStateImpl>
    implements _$$AuthFormStateImplCopyWith<$Res> {
  __$$AuthFormStateImplCopyWithImpl(
      _$AuthFormStateImpl _value, $Res Function(_$AuthFormStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoginMode = null,
    Object? isCodeSent = null,
    Object? selectedAuthMethod = null,
    Object? verificationId = freezed,
  }) {
    return _then(_$AuthFormStateImpl(
      isLoginMode: null == isLoginMode
          ? _value.isLoginMode
          : isLoginMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isCodeSent: null == isCodeSent
          ? _value.isCodeSent
          : isCodeSent // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedAuthMethod: null == selectedAuthMethod
          ? _value.selectedAuthMethod
          : selectedAuthMethod // ignore: cast_nullable_to_non_nullable
              as int,
      verificationId: freezed == verificationId
          ? _value.verificationId
          : verificationId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AuthFormStateImpl implements _AuthFormState {
  const _$AuthFormStateImpl(
      {this.isLoginMode = true,
      this.isCodeSent = false,
      this.selectedAuthMethod = 0,
      this.verificationId});

  @override
  @JsonKey()
  final bool isLoginMode;
  @override
  @JsonKey()
  final bool isCodeSent;
  @override
  @JsonKey()
  final int selectedAuthMethod;
  @override
  final String? verificationId;

  @override
  String toString() {
    return 'AuthFormState(isLoginMode: $isLoginMode, isCodeSent: $isCodeSent, selectedAuthMethod: $selectedAuthMethod, verificationId: $verificationId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthFormStateImpl &&
            (identical(other.isLoginMode, isLoginMode) ||
                other.isLoginMode == isLoginMode) &&
            (identical(other.isCodeSent, isCodeSent) ||
                other.isCodeSent == isCodeSent) &&
            (identical(other.selectedAuthMethod, selectedAuthMethod) ||
                other.selectedAuthMethod == selectedAuthMethod) &&
            (identical(other.verificationId, verificationId) ||
                other.verificationId == verificationId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isLoginMode, isCodeSent, selectedAuthMethod, verificationId);

  /// Create a copy of AuthFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthFormStateImplCopyWith<_$AuthFormStateImpl> get copyWith =>
      __$$AuthFormStateImplCopyWithImpl<_$AuthFormStateImpl>(this, _$identity);
}

abstract class _AuthFormState implements AuthFormState {
  const factory _AuthFormState(
      {final bool isLoginMode,
      final bool isCodeSent,
      final int selectedAuthMethod,
      final String? verificationId}) = _$AuthFormStateImpl;

  @override
  bool get isLoginMode;
  @override
  bool get isCodeSent;
  @override
  int get selectedAuthMethod;
  @override
  String? get verificationId;

  /// Create a copy of AuthFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthFormStateImplCopyWith<_$AuthFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
