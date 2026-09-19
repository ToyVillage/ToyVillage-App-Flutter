import 'dart:io';

import 'package:flutter/material.dart';
import 'package:toy_village_app/core/widgets/app_loading_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';
import 'package:toy_village_app/core/utils/file_download.dart';
import 'package:toy_village_app/core/utils/file_url.dart';
import 'package:toy_village_app/core/widgets/custom_async_value.dart';
import 'package:toy_village_app/features/document/data/model/document_detail_model.dart';
import 'package:toy_village_app/features/document/presentation/view_model/document_detail_view_model.dart';

void showDocumentPreview(
  BuildContext context, {
  required int id,
  required String title,
  required String type,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (_) => _DocumentPreviewModal(id: id, title: title, type: type),
  );
}

class _DocumentPreviewModal extends ConsumerWidget {
  final int id;
  final String title;
  final String type;

  const _DocumentPreviewModal({
    required this.id,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(documentDetailViewModelProvider(id));
    final detail = async.asData?.value;
    final file = (detail != null && detail.files.isNotEmpty)
        ? detail.files.first
        : null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (file != null)
                    _pillButton(
                      icon: Symbols.download,
                      label: '다운로드',
                      onTap: () => downloadFile(
                        context,
                        fileName: file.fileName,
                        fileKey: file.fileKey,
                      ),
                    ),
                  const SizedBox(width: 8),
                  _iconButton(
                    icon: Icons.close_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: ToyVillageColor.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CustomAsyncValue(
                    value: async,
                    loading: const _PreviewLoading(),
                    onRetry: () =>
                        ref.invalidate(documentDetailViewModelProvider(id)),
                    data: (detail) {
                      final file = detail.files.isNotEmpty
                          ? detail.files.first
                          : null;
                      return file == null
                          ? const _EmptyPreview()
                          : _FilePreview(file: file);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pillButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(40),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: ToyVillageColor.white, size: 24),
            const SizedBox(width: 6),
            Text(
              label,
              style: ToyVillageTextStyle.button4.copyWith(
                color: ToyVillageColor.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: ToyVillageColor.white, size: 22),
      ),
    );
  }
}

class _FilePreview extends StatelessWidget {
  final DocumentFileModel file;

  const _FilePreview({required this.file});

  @override
  Widget build(BuildContext context) {
    final url = documentFileUrl(file.fileKey);
    if (isPdfFileName(file.fileName)) return _WebDocPreview(url: url);
    if (isPptFileName(file.fileName)) {
      return _WebDocPreview(url: url, alwaysGView: true);
    }
    if (!isImageFileName(file.fileName)) {
      return _UnsupportedPreview(fileName: file.fileName);
    }

    return InteractiveViewer(
      child: Image.network(
        url,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const _PreviewLoading();
        },
        errorBuilder: (context, error, stackTrace) => const _EmptyPreview(),
      ),
    );
  }
}

class _WebDocPreview extends StatefulWidget {
  final String url;
  final bool alwaysGView;

  const _WebDocPreview({required this.url, this.alwaysGView = false});

  @override
  State<_WebDocPreview> createState() => _WebDocPreviewState();
}

class _WebDocPreviewState extends State<_WebDocPreview> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    final useGView = widget.alwaysGView || Platform.isAndroid;
    final target = useGView
        ? 'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(widget.url)}'
        : widget.url;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => _loading = false),
          onWebResourceError: (error) {
            if (error.isForMainFrame == false) return;
            setState(() {
              _loading = false;
              _error = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(target));
  }

  @override
  Widget build(BuildContext context) {
    if (_error) return const _EmptyPreview();
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_loading) const _PreviewLoading(),
      ],
    );
  }
}

class _PreviewLoading extends StatelessWidget {
  const _PreviewLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: AppLoadingIndicator());
  }
}

class _UnsupportedPreview extends StatelessWidget {
  final String fileName;

  const _UnsupportedPreview({required this.fileName});

  String get _extension {
    final dot = fileName.lastIndexOf('.');
    if (dot == -1 || dot == fileName.length - 1) return 'FILE';
    return fileName.substring(dot + 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: ToyVillageColor.gray10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _extension,
              style: ToyVillageTextStyle.subTitle3.copyWith(
                color: ToyVillageColor.gray100,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '미리보기를 지원하지 않는 형식이에요.',
            style: ToyVillageTextStyle.body5.copyWith(
              color: ToyVillageColor.gray60,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '다운로드 후 확인해주세요.',
            style: ToyVillageTextStyle.caption3.copyWith(
              color: ToyVillageColor.gray40,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPreview extends StatelessWidget {
  const _EmptyPreview();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '미리보기를 불러오지 못했어요.',
        style: ToyVillageTextStyle.body5.copyWith(
          color: ToyVillageColor.gray60,
        ),
      ),
    );
  }
}
