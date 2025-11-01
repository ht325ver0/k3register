import 'package:k3register/infrastructure/orders_repository.dart';
import 'package:k3register/model/sales_summary.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sales_data_provider.g.dart';

@Riverpod(keepAlive: true)
class SalesData extends _$SalesData {
  @override
  Future<List<SalesSummary>> build() async {
    return [];
  } 

  // DateTimeを日付のみに正規化するヘルパー
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// 日付を指定してデータを再取得する
  Future<void> changeDate(DateTime newDate) async {
    final normalizedNewDate = _normalizeDate(newDate);

    // stateが値を持っていて、かつ既にその日付のデータがキャッシュ（List）に存在する場合は何もしない
    if (state.hasValue &&
        state.value!
            .any((summary) => _normalizeDate(summary.date) == normalizedNewDate)) {
      return;
    }

    // ローディング状態にする
    state = const AsyncValue.loading();

    // データを取得し、状態を更新する
    state = await AsyncValue.guard(() async {
      final repository = ref.read(orderRepositoryProvider);
      final summary = await repository.fetchSalesSummaryByDate(normalizedNewDate);

      // 既存のキャッシュを取得（なければ空のリスト）
      final currentData = state.value ?? [];
      // 新しいデータをListに追加して、新しいListを作成
      return [
        ...currentData,
        summary,
      ];
    });
  }
}
