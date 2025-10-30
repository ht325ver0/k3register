// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sales_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SalesSummary _$SalesSummaryFromJson(Map<String, dynamic> json) {
  return _SalesSummary.fromJson(json);
}

/// @nodoc
mixin _$SalesSummary {
  DateTime get date =>
      throw _privateConstructorUsedError; // The date this summary is for
  @JsonKey(name: 'total_sales')
  int get totalSales => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_orders')
  int get totalOrders => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_items')
  int get totalItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'part_counts')
  Map<String, int> get partCounts => throw _privateConstructorUsedError;

  /// Serializes this SalesSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SalesSummaryCopyWith<SalesSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SalesSummaryCopyWith<$Res> {
  factory $SalesSummaryCopyWith(
          SalesSummary value, $Res Function(SalesSummary) then) =
      _$SalesSummaryCopyWithImpl<$Res, SalesSummary>;
  @useResult
  $Res call(
      {DateTime date,
      @JsonKey(name: 'total_sales') int totalSales,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'total_items') int totalItems,
      @JsonKey(name: 'part_counts') Map<String, int> partCounts});
}

/// @nodoc
class _$SalesSummaryCopyWithImpl<$Res, $Val extends SalesSummary>
    implements $SalesSummaryCopyWith<$Res> {
  _$SalesSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalSales = null,
    Object? totalOrders = null,
    Object? totalItems = null,
    Object? partCounts = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as int,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      partCounts: null == partCounts
          ? _value.partCounts
          : partCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SalesSummaryImplCopyWith<$Res>
    implements $SalesSummaryCopyWith<$Res> {
  factory _$$SalesSummaryImplCopyWith(
          _$SalesSummaryImpl value, $Res Function(_$SalesSummaryImpl) then) =
      __$$SalesSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      @JsonKey(name: 'total_sales') int totalSales,
      @JsonKey(name: 'total_orders') int totalOrders,
      @JsonKey(name: 'total_items') int totalItems,
      @JsonKey(name: 'part_counts') Map<String, int> partCounts});
}

/// @nodoc
class __$$SalesSummaryImplCopyWithImpl<$Res>
    extends _$SalesSummaryCopyWithImpl<$Res, _$SalesSummaryImpl>
    implements _$$SalesSummaryImplCopyWith<$Res> {
  __$$SalesSummaryImplCopyWithImpl(
      _$SalesSummaryImpl _value, $Res Function(_$SalesSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of SalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalSales = null,
    Object? totalOrders = null,
    Object? totalItems = null,
    Object? partCounts = null,
  }) {
    return _then(_$SalesSummaryImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as int,
      totalOrders: null == totalOrders
          ? _value.totalOrders
          : totalOrders // ignore: cast_nullable_to_non_nullable
              as int,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      partCounts: null == partCounts
          ? _value._partCounts
          : partCounts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SalesSummaryImpl implements _SalesSummary {
  const _$SalesSummaryImpl(
      {required this.date,
      @JsonKey(name: 'total_sales') this.totalSales = 0,
      @JsonKey(name: 'total_orders') this.totalOrders = 0,
      @JsonKey(name: 'total_items') this.totalItems = 0,
      @JsonKey(name: 'part_counts')
      final Map<String, int> partCounts = const {}})
      : _partCounts = partCounts;

  factory _$SalesSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SalesSummaryImplFromJson(json);

  @override
  final DateTime date;
// The date this summary is for
  @override
  @JsonKey(name: 'total_sales')
  final int totalSales;
  @override
  @JsonKey(name: 'total_orders')
  final int totalOrders;
  @override
  @JsonKey(name: 'total_items')
  final int totalItems;
  final Map<String, int> _partCounts;
  @override
  @JsonKey(name: 'part_counts')
  Map<String, int> get partCounts {
    if (_partCounts is EqualUnmodifiableMapView) return _partCounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_partCounts);
  }

  @override
  String toString() {
    return 'SalesSummary(date: $date, totalSales: $totalSales, totalOrders: $totalOrders, totalItems: $totalItems, partCounts: $partCounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SalesSummaryImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            const DeepCollectionEquality()
                .equals(other._partCounts, _partCounts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, totalSales, totalOrders,
      totalItems, const DeepCollectionEquality().hash(_partCounts));

  /// Create a copy of SalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SalesSummaryImplCopyWith<_$SalesSummaryImpl> get copyWith =>
      __$$SalesSummaryImplCopyWithImpl<_$SalesSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SalesSummaryImplToJson(
      this,
    );
  }
}

abstract class _SalesSummary implements SalesSummary {
  const factory _SalesSummary(
          {required final DateTime date,
          @JsonKey(name: 'total_sales') final int totalSales,
          @JsonKey(name: 'total_orders') final int totalOrders,
          @JsonKey(name: 'total_items') final int totalItems,
          @JsonKey(name: 'part_counts') final Map<String, int> partCounts}) =
      _$SalesSummaryImpl;

  factory _SalesSummary.fromJson(Map<String, dynamic> json) =
      _$SalesSummaryImpl.fromJson;

  @override
  DateTime get date; // The date this summary is for
  @override
  @JsonKey(name: 'total_sales')
  int get totalSales;
  @override
  @JsonKey(name: 'total_orders')
  int get totalOrders;
  @override
  @JsonKey(name: 'total_items')
  int get totalItems;
  @override
  @JsonKey(name: 'part_counts')
  Map<String, int> get partCounts;

  /// Create a copy of SalesSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SalesSummaryImplCopyWith<_$SalesSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
