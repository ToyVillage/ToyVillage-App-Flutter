import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/document/data/model/document_model.dart';

final documentRepositoryProvider =
    Provider((ref) => DocumentRepository(ref.read(dioProvider)));

class DocumentRepository {
  final Dio _dio;

  DocumentRepository(this._dio);

  Future<List<DocumentModel>> loadDocuments({
    int page = 0,
    int size = 10,
    String? keyword,
    String orderDirection = 'DESC',
  }) async {
    final res = await _dio.get(
      ApiEndpoints.documents,
      queryParameters: {
        'page': page,
        'size': size,
        'orderDirection': orderDirection,
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
      },
    );
    final list = res.data as List;
    return list
        .map((e) => DocumentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
