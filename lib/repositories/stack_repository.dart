// lib/repositories/stack_repository.dart
import '../models/stack_item.dart';
import '../utils/api_client.dart';

class StackRepository {
  final ApiClient apiClient;

  StackRepository({required this.apiClient});

  Future<List<StackItem>> getStackItems() async {
    final data = await apiClient.fetchData();
    List<dynamic> itemsJson = data['items'];
    return itemsJson.map((item) => StackItem.fromJson(item)).toList();
  }
}
