import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toy_village_app/core/utils/file_url.dart';
import 'package:toy_village_app/core/widgets/top_toast.dart';

bool isImageFileName(String name) {
  final n = name.toLowerCase();
  return n.endsWith('.jpg') || n.endsWith('.jpeg') || n.endsWith('.png');
}

bool isPdfFileName(String name) => name.toLowerCase().endsWith('.pdf');

Future<void> downloadFile(
  BuildContext context, {
  required String fileName,
  required String fileKey,
}) async {
  final overlay = Overlay.of(context, rootOverlay: true);
  final renderObject = context.findRenderObject();
  final box = renderObject is RenderBox ? renderObject : null;
  final url = documentFileUrl(fileKey);
  try {
    if (isImageFileName(fileName)) {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/$fileName';
      await Dio().download(url, path);
      await Gal.putImage(path);
      showTopToast(overlay, '사진에 저장했어요.');
    } else if (Platform.isAndroid) {
      await FileDownloader.downloadFile(url: url, name: fileName);
      showTopToast(overlay, '다운로드를 시작했어요.');
    } else {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/$fileName';
      await Dio().download(url, path);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(path)],
          sharePositionOrigin: box != null
              ? box.localToGlobal(Offset.zero) & box.size
              : null,
        ),
      );
    }
  } catch (_) {
    showTopToast(overlay, '다운로드에 실패했어요.', isError: true);
  }
}
