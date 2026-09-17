import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/entity_info/data/model/observation.dart';
import 'package:toy_village_app/features/entity_info/data/repository/animal_manage_repository.dart';

const _defaultErrorMessage = '저장에 실패했어요. 다시 시도해주세요.';

final observationCreateViewModelProvider =
    AsyncNotifierProvider<ObservationCreateViewModel, void>(
      ObservationCreateViewModel.new,
    );

class ObservationCreateViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<String?> create(int animalManageId, ObservationRequest request) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(animalManageRepositoryProvider)
          .createObservation(animalManageId, request);
      state = const AsyncData(null);
      return null;
    } on DioException catch (e, stackTrace) {
      debugPrint('[Observation Create Error] animalManageId=$animalManageId: $e');
      debugPrint('$stackTrace');
      state = AsyncError(e, stackTrace);
      return _errorMessage(e);
    } catch (e, stackTrace) {
      debugPrint('[Observation Create Error] animalManageId=$animalManageId: $e');
      debugPrint('$stackTrace');
      state = AsyncError(e, stackTrace);
      return _defaultErrorMessage;
    }
  }

  String _errorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return _defaultErrorMessage;
  }
}
