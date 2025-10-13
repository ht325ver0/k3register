// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      taste: $enumDecodeNullable(_$TasteEnumMap, json['taste']),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'taste': _$TasteEnumMap[instance.taste],
      'quantity': instance.quantity,
    };

const _$TasteEnumMap = {
  Taste.solt: 'solt',
  Taste.amakuchi: 'amakuchi',
  Taste.chukara: 'chukara',
  Taste.karakuchi: 'karakuchi',
  Taste.death: 'death',
  Taste.none: 'none',
};
