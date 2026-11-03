import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/task_assignment/data/model/employee.dart';
import 'package:toy_village_app/features/task_assignment/data/repository/employee_repository.dart';

final employeeListViewModelProvider =
    AsyncNotifierProvider.autoDispose<EmployeeListViewModel, List<Employee>>(
      () => EmployeeListViewModel(),
    );

class EmployeeListViewModel extends AsyncNotifier<List<Employee>> {
  @override
  Future<List<Employee>> build() {
    return ref.read(employeeRepositoryProvider).loadEmployees();
  }
}
