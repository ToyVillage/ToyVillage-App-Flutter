import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/task/data/model/task_model.dart';

final taskRepositoryProvider = Provider(
  (ref) => TaskRepository(ref.read(dioProvider)),
);

class TaskRepository {
  final Dio _dio;

  TaskRepository(this._dio);

  Future<List<TaskModel>> loadMyTasks({
    int page = 0,
    int size = 10,
    String sort = 'id,DESC',
  }) async {
    final response = await _dio.get(
      ApiEndpoints.tasksMy,
      queryParameters: {'page': page, 'size': size, 'sort': sort},
    );
    final data = response.data;
    final list = (data is Map<String, dynamic> ? data['tasks'] : data) as List;
    return list
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
