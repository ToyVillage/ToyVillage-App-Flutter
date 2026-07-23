import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/task/data/model/task_model.dart';

final taskRepositoryProvider =
    Provider((ref) => TaskRepository(ref.read(dioProvider)));

class TaskRepository {
  final Dio _dio;

  TaskRepository(this._dio);

  Future<List<TaskModel>> loadTodayTasks() async {
    final response = await _dio.get(ApiEndpoints.task);
    final list = response.data as List;
    return list
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> submitReport({
    required int taskId,
    required String content,
  }) async {
    await _dio.post(
      '${ApiEndpoints.task}/$taskId/report',
      data: {'content': content},
    );
  }
}
