// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pocket_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PocketModel _$PocketModelFromJson(Map<String, dynamic> json) {
  return _PocketModel.fromJson(json);
}

/// @nodoc
mixin _$PocketModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  PocketType get type => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String? get institution => throw _privateConstructorUsedError;
  String? get lastFour => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;

  /// Serializes this PocketModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PocketModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PocketModelCopyWith<PocketModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PocketModelCopyWith<$Res> {
  factory $PocketModelCopyWith(
    PocketModel value,
    $Res Function(PocketModel) then,
  ) = _$PocketModelCopyWithImpl<$Res, PocketModel>;
  @useResult
  $Res call({
    String id,
    String name,
    PocketType type,
    double balance,
    int color,
    String icon,
    String? institution,
    String? lastFour,
    bool isDefault,
  });
}

/// @nodoc
class _$PocketModelCopyWithImpl<$Res, $Val extends PocketModel>
    implements $PocketModelCopyWith<$Res> {
  _$PocketModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PocketModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? balance = null,
    Object? color = null,
    Object? icon = null,
    Object? institution = freezed,
    Object? lastFour = freezed,
    Object? isDefault = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as PocketType,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as double,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as int,
            icon: null == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String,
            institution: freezed == institution
                ? _value.institution
                : institution // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastFour: freezed == lastFour
                ? _value.lastFour
                : lastFour // ignore: cast_nullable_to_non_nullable
                      as String?,
            isDefault: null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PocketModelImplCopyWith<$Res>
    implements $PocketModelCopyWith<$Res> {
  factory _$$PocketModelImplCopyWith(
    _$PocketModelImpl value,
    $Res Function(_$PocketModelImpl) then,
  ) = __$$PocketModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    PocketType type,
    double balance,
    int color,
    String icon,
    String? institution,
    String? lastFour,
    bool isDefault,
  });
}

/// @nodoc
class __$$PocketModelImplCopyWithImpl<$Res>
    extends _$PocketModelCopyWithImpl<$Res, _$PocketModelImpl>
    implements _$$PocketModelImplCopyWith<$Res> {
  __$$PocketModelImplCopyWithImpl(
    _$PocketModelImpl _value,
    $Res Function(_$PocketModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PocketModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? balance = null,
    Object? color = null,
    Object? icon = null,
    Object? institution = freezed,
    Object? lastFour = freezed,
    Object? isDefault = null,
  }) {
    return _then(
      _$PocketModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as PocketType,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as double,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as int,
        icon: null == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String,
        institution: freezed == institution
            ? _value.institution
            : institution // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastFour: freezed == lastFour
            ? _value.lastFour
            : lastFour // ignore: cast_nullable_to_non_nullable
                  as String?,
        isDefault: null == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PocketModelImpl implements _PocketModel {
  const _$PocketModelImpl({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.color,
    required this.icon,
    this.institution,
    this.lastFour,
    required this.isDefault,
  });

  factory _$PocketModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PocketModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final PocketType type;
  @override
  final double balance;
  @override
  final int color;
  @override
  final String icon;
  @override
  final String? institution;
  @override
  final String? lastFour;
  @override
  final bool isDefault;

  @override
  String toString() {
    return 'PocketModel(id: $id, name: $name, type: $type, balance: $balance, color: $color, icon: $icon, institution: $institution, lastFour: $lastFour, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PocketModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.institution, institution) ||
                other.institution == institution) &&
            (identical(other.lastFour, lastFour) ||
                other.lastFour == lastFour) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    type,
    balance,
    color,
    icon,
    institution,
    lastFour,
    isDefault,
  );

  /// Create a copy of PocketModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PocketModelImplCopyWith<_$PocketModelImpl> get copyWith =>
      __$$PocketModelImplCopyWithImpl<_$PocketModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PocketModelImplToJson(this);
  }
}

abstract class _PocketModel implements PocketModel {
  const factory _PocketModel({
    required final String id,
    required final String name,
    required final PocketType type,
    required final double balance,
    required final int color,
    required final String icon,
    final String? institution,
    final String? lastFour,
    required final bool isDefault,
  }) = _$PocketModelImpl;

  factory _PocketModel.fromJson(Map<String, dynamic> json) =
      _$PocketModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  PocketType get type;
  @override
  double get balance;
  @override
  int get color;
  @override
  String get icon;
  @override
  String? get institution;
  @override
  String? get lastFour;
  @override
  bool get isDefault;

  /// Create a copy of PocketModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PocketModelImplCopyWith<_$PocketModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
