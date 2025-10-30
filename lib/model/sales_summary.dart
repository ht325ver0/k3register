import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_summary.freezed.dart';
part 'sales_summary.g.dart';

@freezed
class SalesSummary with _$SalesSummary {
  const factory SalesSummary({
    required DateTime date, // The date this summary is for
    @JsonKey(name: 'total_sales') @Default(0) int totalSales,
    @JsonKey(name: 'total_orders') @Default(0) int totalOrders,
    @JsonKey(name: 'total_items') @Default(0) int totalItems,
    @JsonKey(name: 'part_counts') @Default({}) Map<String, int> partCounts,
  }) = _SalesSummary;

  factory SalesSummary.fromJson(Map<String, dynamic> json) =>
      _$SalesSummaryFromJson(json);
}