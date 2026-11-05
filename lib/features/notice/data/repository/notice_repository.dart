import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';
import 'package:toy_village_app/features/notice/data/model/notice_model.dart';

final noticeRepositoryProvider = Provider(
  (ref) => NoticeRepository(ref.read(dioProvider)),
);

class NoticeRepository {
  final Dio _dio;

  NoticeRepository(this._dio);

  Future<({List<NoticeModel> notices, int totalPages})> loadNotices({
    int page = 0,
    int size = 10,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.notice,
      queryParameters: {'page': page, 'size': size},
    );
    final data = response.data;
    final map = data is Map<String, dynamic> ? data : const <String, dynamic>{};
    final list = (data is Map<String, dynamic> ? data['notices'] : data) as List;
    final notices = list
        .map((e) => NoticeModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final totalPages = map['totalPageSize'] is int
        ? map['totalPageSize'] as int
        : (notices.length < size ? page : page + 1);
    return (notices: notices, totalPages: totalPages);
  }
}
