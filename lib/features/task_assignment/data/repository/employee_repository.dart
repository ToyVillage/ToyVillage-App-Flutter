import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/task_assignment/data/model/employee.dart';

final employeeRepositoryProvider = Provider(
  (ref) => EmployeeRepository(ref.read(dioProvider)),
);

class EmployeeRepository {
  final Dio _dio;

  EmployeeRepository(this._dio);

  Future<List<Employee>> loadEmployees() async {
    final response = await _dio.get(ApiEndpoints.employees);
    final list = response.data as List;
    return list
        .map((e) => Employee.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
