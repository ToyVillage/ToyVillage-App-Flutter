import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/task/data/model/task_model.dart';
import 'package:toy_village_app/features/task_assignment/data/model/assignment_request.dart';

final assignmentRepositoryProvider = Provider(
  (ref) => AssignmentRepository(ref.read(dioProvider)),
);

class AssignmentRepository {
  final Dio _dio;

  AssignmentRepository(this._dio);

  Future<List<TaskModel>> loadAssignments({
    int page = 0,
    int size = 50,
    String sort = 'id,DESC',
  }) async {
    final response = await _dio.get(
      ApiEndpoints.tasks,
      queryParameters: {'page': page, 'size': size, 'sort': sort},
    );
    final data = response.data;
    final list = (data is Map<String, dynamic> ? data['tasks'] : data) as List;
    return list
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> createAssignment(AssignmentRequest request) async {
    await _dio.post(ApiEndpoints.tasks, data: request.toJson());
  }

  Future<void> updateAssignment(int id, AssignmentRequest request) async {
    await _dio.put('${ApiEndpoints.tasks}/$id', data: request.toJson());
  }

  Future<void> deleteAssignment(int id) async {
    await _dio.delete('${ApiEndpoints.tasks}/$id');
  }
}
