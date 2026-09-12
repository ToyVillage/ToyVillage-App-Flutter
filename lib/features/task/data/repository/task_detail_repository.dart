import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/task/data/model/task_detail_model.dart';

final taskDetailRepositoryProvider = Provider(
  (ref) => TaskDetailRepository(ref.read(dioProvider)),
);

class TaskDetailRepository {
  final Dio _dio;

  TaskDetailRepository(this._dio);

  Future<TaskDetailModel> loadTaskDetail({required int id}) async {
    final response = await _dio.get('${ApiEndpoints.tasks}/$id');
    return TaskDetailModel.fromJson(response.data as Map<String, dynamic>);
  }
}
