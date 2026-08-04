import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/core/network/api_endpoints.dart';
import 'package:toy_village_app/core/network/dio_provider.dart';

final fileRepositoryProvider =
    Provider((ref) => FileRepository(ref.read(dioProvider)));

class FileRepository {
  final Dio _dio;

  FileRepository(this._dio);

  Future<String> upload(Uint8List bytes, String fileName) async {
    final formData = FormData.fromMap({
      'files': MultipartFile.fromBytes(bytes, filename: fileName),
    });
    final res = await _dio.post(ApiEndpoints.file, data: formData);
    return res.data['fileKey'] as String;
  }
}
