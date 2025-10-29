import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:k3register/component/order_product_card.dart';
import 'package:k3register/model/order.dart';
import 'package:k3register/provider/product_provider.dart';
import 'package:collection/collection.dart';

class CookingCounter extends ConsumerWidget {
  final List<Order> orders;

  const CookingCounter({super.key, required this.orders});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    if (orders.isEmpty) {
      return const Center(
        child: Text('調理待ちの注文はありません'),
      );
    }

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('商品情報の取得に失敗しました: $err')),
      data: (products) {
        // 部位ごとの本数を集計するMap
        final Map<String, int> partCounts = {};

        // 全ての注文をループ
        for (final order in orders) {
          // 注文内の各商品をループ
          for (final item in order.items) {
            // 商品IDに対応する商品情報を探す
            final product =
                products.firstWhereOrNull((p) => p.id == item.productId);

            if (product != null) {
              // 商品名（部位）をキーとして数量を加算
              partCounts.update(
                product.name,
                (value) => value + item.quantity,
                ifAbsent: () => item.quantity,
              );
            }
          }
        }

        final sortedParts = partCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: sortedParts.length,
          itemBuilder: (context, index) {
            final entry = sortedParts[index];
            return ListTile(
              title: Text(entry.key, style: Theme.of(context).textTheme.titleLarge),
              trailing: Text('${entry.value} 本', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
        );
      },
    );
  }
}