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
      'files': MultipartFile.fromBytes(
        bytes,
        filename: fileName,
        contentType: DioMediaType.parse(_mimeType(fileName)),
      ),
    });
    final res = await _dio.post(ApiEndpoints.file, data: formData);
    return res.data['fileKey'] as String;
  }

  String _mimeType(String fileName) {
    final ext = fileName.toLowerCase().split('.').last;
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }
}
