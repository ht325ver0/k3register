// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalesSummaryImpl _$$SalesSummaryImplFromJson(Map<String, dynamic> json) =>
    _$SalesSummaryImpl(
      date: DateTime.parse(json['date'] as String),
      totalSales: (json['total_sales'] as num?)?.toInt() ?? 0,
      totalOrders: (json['total_orders'] as num?)?.toInt() ?? 0,
      totalItems: (json['total_items'] as num?)?.toInt() ?? 0,
      partCounts: (json['part_counts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$SalesSummaryImplToJson(_$SalesSummaryImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'total_sales': instance.totalSales,
      'total_orders': instance.totalOrders,
      'total_items': instance.totalItems,
      'part_counts': instance.partCounts,
    };
