import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/notice/data/model/notice_model.dart';

final noticeRepositoryProvider =
    Provider((ref) => NoticeRepository(ref.read(dioProvider)));

class NoticeRepository {
  final Dio _dio;

  NoticeRepository(this._dio);

  Future<List<NoticeModel>> loadNotices({int page = 0, int size = 10}) async {
    final response = await _dio.get(
      ApiEndpoints.notice,
      queryParameters: {'page': page, 'size': size},
    );
    final list = response.data as List;
    return list
        .map((e) => NoticeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
