import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/network/file_repository.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/task/data/model/report_attachment.dart';

const _maxBytes = 50 * 1024 * 1024;

enum _PickSource { camera, gallery, file }

Future<ReportAttachment?> pickAndUploadAttachment(
  BuildContext context,
  WidgetRef ref,
) async {
  final overlay = Overlay.of(context, rootOverlay: true);
  final source = await _showSourceSheet(context);
  if (source == null) return null;

  final picked = await _pick(source);
  if (picked == null) return null;

  if (picked.size > _maxBytes) {
    showTopToast(overlay, '50MB가 넘는 파일은 첨부할 수 없어요.', isError: true);
    return null;
  }

  try {
    final key = await ref
        .read(fileRepositoryProvider)
        .upload(picked.path, picked.name);
    return ReportAttachment(fileName: picked.name, fileKey: key);
  } catch (_) {
    showTopToast(overlay, '파일 업로드에 실패했어요.', isError: true);
    return null;
  }
}

Future<({String path, String name, int size})?> _pick(_PickSource source) async {
  if (source == _PickSource.file) {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return null;
    final file = result.files.first;
    if (file.path == null) return null;
    return (path: file.path!, name: file.name, size: file.size);
  }

  final image = await ImagePicker().pickImage(
    source: source == _PickSource.camera
        ? ImageSource.camera
        : ImageSource.gallery,
  );
  if (image == null) return null;
  final size = await image.length();
  return (path: image.path, name: image.name, size: size);
}

Future<_PickSource?> _showSourceSheet(BuildContext context) {
  if (Platform.isIOS) {
    return showCupertinoModalPopup<_PickSource>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx, _PickSource.camera),
            child: Text('사진 찍기', style: ToyVillageTextStyle.body3),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx, _PickSource.gallery),
            child: Text('사진 보관함', style: ToyVillageTextStyle.body3),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx, _PickSource.file),
            child: Text('파일 선택', style: ToyVillageTextStyle.body3),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: Text('취소', style: ToyVillageTextStyle.body3),
        ),
      ),
    );
  }

  return showModalBottomSheet<_PickSource>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            tileColor: ToyVillageColor.white,
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('사진 찍기'),
            onTap: () => Navigator.pop(ctx, _PickSource.camera),
          ),
          ListTile(
            tileColor: ToyVillageColor.white,
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('사진 보관함'),
            onTap: () => Navigator.pop(ctx, _PickSource.gallery),
          ),
          ListTile(
            tileColor: ToyVillageColor.white,
            leading: const Icon(Icons.folder_outlined),
            title: const Text('파일 선택'),
            onTap: () => Navigator.pop(ctx, _PickSource.file),
          ),
        ],
      ),
    ),
  );
}
