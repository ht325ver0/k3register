import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        final productMap = {for (var p in products) p.id: p};

        final Map<String, int> partCounts = {};
        for (final order in orders) {
          for (final item in order.items) {
            final product = productMap[item.productId];
            if (product != null) {
              partCounts.update(
                product.name,
                (value) => value + item.quantity,
                ifAbsent: () => item.quantity,
              );
            }
          }
        }

        // 本数が多い順にソート
        final sortedParts = partCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        if (sortedParts.isEmpty) {
          return const Center(
            child: Text('調理待ちの注文はありません'),
          );
        }

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