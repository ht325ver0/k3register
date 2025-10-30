import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:k3register/component/data_card.dart';
import 'package:k3register/provider/sales_data_provider.dart';

class SalesDataPage extends ConsumerStatefulWidget {
  const SalesDataPage({super.key});

  @override
  ConsumerState<SalesDataPage> createState() => _SalesDataPageState();
}

class _SalesDataPageState extends ConsumerState<SalesDataPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // 画面表示時に今日のデータを自動で取得する
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(salesDataProvider.notifier).changeDate(_selectedDate);
    });
  }

  // DateTimeを日付のみに正規化するヘルパー
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    final salesDataAsync = ref.watch(salesDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('yyyy/MM/dd').format(_selectedDate)),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2022),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null && pickedDate != _selectedDate) {
                setState(() {
                  _selectedDate = pickedDate;
                });
                ref.read(salesDataProvider.notifier).changeDate(pickedDate);
              }
            },
          ),
        ],
      ),
      body: salesDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラー: $err')),
        data: (allSalesData) {
          // 選択された日付に一致するデータのインデックスを探す
          final summaryIndex = allSalesData.indexWhere(
              (s) => _normalizeDate(s.date) == _normalizeDate(_selectedDate));

          // インデックスが見つからなかった場合（-1）はデータがないと判断
          if (summaryIndex == -1) {
            return const Center(
              child: Text(
                'データがありません',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // 見つかったインデックスを使ってデータを取得
          final summary = allSalesData[summaryIndex];

          final averagePrice = (summary.totalOrders == 0)
              ? 0
              : summary.totalSales ~/ summary.totalOrders;

          return LayoutBuilder(
            builder: (context, constraints) {
              // 画面幅に応じてレイアウトを調整
              final isPhoneLayout = constraints.maxWidth < 600;
              final crossAxisCount = isPhoneLayout ? 1 : 2;
              final childAspectRatio = isPhoneLayout ? 2.5 : 1.5;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: childAspectRatio,
                  children: [
                    DataCard(title: '売上総額', value: '¥${NumberFormat("#,###").format(summary.totalSales)}', icon: Icons.trending_up, color: Colors.green),
                    DataCard(title: '客数', value: '${summary.totalOrders}人', icon: Icons.people, color: Colors.blue),
                    DataCard(title: '販売本数', value: '${summary.totalItems}本', icon: Icons.kebab_dining, color: Colors.teal),
                    DataCard(title: '平均客単価', value: '¥${NumberFormat("#,###").format(averagePrice)}', icon: Icons.monetization_on, color: Colors.orange),
                    InkWell(
                      onTap: () => _showPartCountsDialog(context, summary.partCounts),
                      child: const DataCard(title: '部位別集計', value: '詳細を見る', icon: Icons.pie_chart, color: Colors.purple),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showPartCountsDialog(BuildContext context, Map<String, int> partCounts) {
    if (partCounts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('部位別の集計データがありません。')));
      return;
    }

    final sortedEntries = partCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('部位別 販売数'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: sortedEntries.length,
            itemBuilder: (context, index) {
              final entry = sortedEntries[index];
              return ListTile(
                title: Text(entry.key),
                trailing: Text('${entry.value} 本', style: const TextStyle(fontWeight: FontWeight.bold)),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('閉じる')),
        ],
      ),
    );
  }
}