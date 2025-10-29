import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:k3register/model/order_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    // idもモデルに含めておくと便利
    int? id,
    @JsonKey(name: 'order_items') required List<OrderItem> items,
    @JsonKey(name: 'total_price') required int totalPrice,
    @Default('waiting') @JsonKey(name: 'has_provided') String hasProvided,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}