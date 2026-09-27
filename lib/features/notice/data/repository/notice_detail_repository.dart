import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/notice/data/model/notice_detail_model.dart';

final noticeDetailRepositoryProvider =
    Provider((ref) => NoticeDetailRepository(ref.read(dioProvider)));

class NoticeDetailRepository {
  final Dio _dio;

  NoticeDetailRepository(this._dio);

  Future<NoticeDetailModel> loadDetailNotice({required int id}) async {
    final response = await _dio.get(
      '${ApiEndpoints.notice}/$id'
    );
    return NoticeDetailModel.fromJson(response.data as Map<String, dynamic>);
  }
}