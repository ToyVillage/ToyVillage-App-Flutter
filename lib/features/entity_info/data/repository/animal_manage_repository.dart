import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_detail.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_kind.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_kind_detail.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_summary.dart';
import 'package:toy_village_app/features/entity_info/data/model/animal_taxonomic.dart';
import 'package:toy_village_app/features/entity_info/data/model/observation.dart';
import 'package:toy_village_app/features/entity_info/data/model/page_result.dart';

final animalManageRepositoryProvider = Provider(
  (ref) => AnimalManageRepository(ref.read(dioProvider)),
);

class AnimalManageRepository {
  final Dio _dio;

  AnimalManageRepository(this._dio);

  Future<AnimalKindPage> loadKinds({
    AnimalTaxonomic? animalTaxonomic,
    String? keyword,
    int page = 0,
    int size = 10,
    String sort = 'id,desc',
  }) async {
    final response = await _dio.get(
      ApiEndpoints.animalManageKind,
      queryParameters: {
        if (animalTaxonomic != null) 'animalTaxonomic': animalTaxonomic.code,
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        'page': page,
        'size': size,
        'sort': sort,
      },
    );
    return AnimalKindPage.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AnimalKindDetail> loadKindDetail(int animalKindId) async {
    final response = await _dio.get(
      '${ApiEndpoints.animalManageKind}/$animalKindId',
    );
    return AnimalKindDetail.fromJson(response.data as Map<String, dynamic>);
  }

  Future<PageResult<AnimalSummary>> loadAnimals(
    int animalKindId, {
    String? keyword,
    int page = 0,
    int size = 10,
    String sort = 'id,desc',
  }) async {
    final response = await _dio.get(
      '${ApiEndpoints.animalManageKind}/$animalKindId/animal',
      queryParameters: {
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        'page': page,
        'size': size,
        'sort': sort,
      },
    );
    return PageResult.fromJson(
      response.data as Map<String, dynamic>,
      AnimalSummary.fromJson,
    );
  }

  Future<AnimalDetail> loadAnimalDetail(int animalManageId) async {
    final response = await _dio.get(
      '${ApiEndpoints.animalManage}/$animalManageId',
    );
    return AnimalDetail.fromJson(response.data as Map<String, dynamic>);
  }

  Future<PageResult<Observation>> loadObservations(
    int animalManageId, {
    int page = 0,
    int size = 10,
    String sort = 'id,desc',
  }) async {
    final response = await _dio.get(
      '${ApiEndpoints.animalManage}/$animalManageId/observations',
      queryParameters: {'page': page, 'size': size, 'sort': sort},
    );
    return PageResult.fromJson(
      response.data as Map<String, dynamic>,
      Observation.fromJson,
    );
  }

  Future<ObservationDetail> loadObservationDetail(
    int animalManageId,
    int observationId,
  ) async {
    final response = await _dio.get(
      '${ApiEndpoints.animalManage}/$animalManageId/observations/$observationId',
    );
    return ObservationDetail.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> createObservation(
    int animalManageId,
    ObservationRequest request,
  ) async {
    await _dio.post(
      '${ApiEndpoints.animalManage}/$animalManageId/observations',
      data: request.toJson(),
    );
  }
}
