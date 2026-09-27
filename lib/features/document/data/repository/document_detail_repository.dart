import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/document/data/model/document_detail_model.dart';

final documentDetailRepositoryProvider =
    Provider((ref) => DocumentDetailRepository(ref.read(dioProvider)));

class DocumentDetailRepository {
  final Dio _dio;

  DocumentDetailRepository(this._dio);

  Future<DocumentDetailModel> loadDocumentDetail({required int id}) async {
    final res = await _dio.get('${ApiEndpoints.documents}/$id');
    return DocumentDetailModel.fromJson(res.data as Map<String, dynamic>);
  }
}
