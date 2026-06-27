// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TransactionFilterState {
  String? get pocketId => throw _privateConstructorUsedError;
  TransactionType? get type => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  DateTimeRange<DateTime>? get range => throw _privateConstructorUsedError;

  /// Create a copy of TransactionFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionFilterStateCopyWith<TransactionFilterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionFilterStateCopyWith<$Res> {
  factory $TransactionFilterStateCopyWith(
    TransactionFilterState value,
    $Res Function(TransactionFilterState) then,
  ) = _$TransactionFilterStateCopyWithImpl<$Res, TransactionFilterState>;
  @useResult
  $Res call({
    String? pocketId,
    TransactionType? type,
    String? categoryId,
    DateTimeRange<DateTime>? range,
  });
}

/// @nodoc
class _$TransactionFilterStateCopyWithImpl<
  $Res,
  $Val extends TransactionFilterState
>
    implements $TransactionFilterStateCopyWith<$Res> {
  _$TransactionFilterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pocketId = freezed,
    Object? type = freezed,
    Object? categoryId = freezed,
    Object? range = freezed,
  }) {
    return _then(
      _value.copyWith(
            pocketId: freezed == pocketId
                ? _value.pocketId
                : pocketId // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as TransactionType?,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            range: freezed == range
                ? _value.range
                : range // ignore: cast_nullable_to_non_nullable
                      as DateTimeRange<DateTime>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransactionFilterStateImplCopyWith<$Res>
    implements $TransactionFilterStateCopyWith<$Res> {
  factory _$$TransactionFilterStateImplCopyWith(
    _$TransactionFilterStateImpl value,
    $Res Function(_$TransactionFilterStateImpl) then,
  ) = __$$TransactionFilterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? pocketId,
    TransactionType? type,
    String? categoryId,
    DateTimeRange<DateTime>? range,
  });
}

/// @nodoc
class __$$TransactionFilterStateImplCopyWithImpl<$Res>
    extends
        _$TransactionFilterStateCopyWithImpl<$Res, _$TransactionFilterStateImpl>
    implements _$$TransactionFilterStateImplCopyWith<$Res> {
  __$$TransactionFilterStateImplCopyWithImpl(
    _$TransactionFilterStateImpl _value,
    $Res Function(_$TransactionFilterStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransactionFilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pocketId = freezed,
    Object? type = freezed,
    Object? categoryId = freezed,
    Object? range = freezed,
  }) {
    return _then(
      _$TransactionFilterStateImpl(
        pocketId: freezed == pocketId
            ? _value.pocketId
            : pocketId // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as TransactionType?,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        range: freezed == range
            ? _value.range
            : range // ignore: cast_nullable_to_non_nullable
                  as DateTimeRange<DateTime>?,
      ),
    );
  }
}

/// @nodoc

class _$TransactionFilterStateImpl implements _TransactionFilterState {
  const _$TransactionFilterStateImpl({
    this.pocketId,
    this.type,
    this.categoryId,
    this.range,
  });

  @override
  final String? pocketId;
  @override
  final TransactionType? type;
  @override
  final String? categoryId;
  @override
  final DateTimeRange<DateTime>? range;

  @override
  String toString() {
    return 'TransactionFilterState(pocketId: $pocketId, type: $type, categoryId: $categoryId, range: $range)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionFilterStateImpl &&
            (identical(other.pocketId, pocketId) ||
                other.pocketId == pocketId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.range, range) || other.range == range));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, pocketId, type, categoryId, range);

  /// Create a copy of TransactionFilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionFilterStateImplCopyWith<_$TransactionFilterStateImpl>
  get copyWith =>
      __$$TransactionFilterStateImplCopyWithImpl<_$TransactionFilterStateImpl>(
        this,
        _$identity,
      );
}

abstract class _TransactionFilterState implements TransactionFilterState {
  const factory _TransactionFilterState({
    final String? pocketId,
    final TransactionType? type,
    final String? categoryId,
    final DateTimeRange<DateTime>? range,
  }) = _$TransactionFilterStateImpl;

  @override
  String? get pocketId;
  @override
  TransactionType? get type;
  @override
  String? get categoryId;
  @override
  DateTimeRange<DateTime>? get range;

  /// Create a copy of TransactionFilterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionFilterStateImplCopyWith<_$TransactionFilterStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
