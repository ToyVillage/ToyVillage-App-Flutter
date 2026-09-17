import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:toy_village_app/core/widgets/app_bar/app_bar.dart';
import 'package:toy_village_app/core/widgets/button/toy_village_button.dart';
import 'package:toy_village_app/core/widgets/text/label.dart';
import 'package:toy_village_app/core/widgets/text_field/text_field.dart';
import 'package:toy_village_app/core/widgets/toast/top_toast.dart';
import 'package:toy_village_app/features/entity_info/data/model/observation.dart';
import 'package:toy_village_app/features/entity_info/presentation/view_model/observation_create_view_model.dart';
import 'package:toy_village_app/features/task/data/model/report_attachment.dart';
import 'package:toy_village_app/features/task/presentation/widget/attachment_editor.dart';
import 'package:toy_village_app/features/task/presentation/widget/attachment_picker.dart';

class EntityNoteWriteView extends ConsumerStatefulWidget {
  final int animalManageId;

  const EntityNoteWriteView({super.key, required this.animalManageId});

  @override
  ConsumerState<EntityNoteWriteView> createState() =>
      _EntityNoteWriteViewState();
}

class _EntityNoteWriteViewState extends ConsumerState<EntityNoteWriteView> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  List<ReportAttachment> _files = [];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _addAttachment() async {
    final attachment = await pickAndUploadAttachment(context, ref);
    if (attachment == null || !mounted) return;
    setState(() => _files = [..._files, attachment]);
  }

  void _deleteAttachment(int index) {
    setState(() => _files = [..._files]..removeAt(index));
  }

  Future<void> _save() async {
    if (ref.read(observationCreateViewModelProvider).isLoading) return;
    final overlay = Overlay.of(context, rootOverlay: true);
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      showTopToast(overlay, '제목과 내용을 입력해주세요.', isError: true);
      return;
    }

    final request = ObservationRequest(
      title: title,
      content: content,
      fileKeys: [for (final file in _files) file.fileKey],
    );

    final success = await ref
        .read(observationCreateViewModelProvider.notifier)
        .create(widget.animalManageId, request);
    if (!mounted) return;

    if (success) {
      context.pop();
    } else {
      showTopToast(overlay, '저장에 실패했어요. 다시 시도해주세요.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    const spacing = SizedBox(height: 20);
    final isSaving = ref.watch(observationCreateViewModelProvider).isLoading;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const ToyVillageAppBar(hasIcon: true),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ToyVillageTextField(
                                label: '제목',
                                hintText: '제목 입력',
                                controller: _titleController,
                              ),
                              spacing,
                              ToyVillageTextField(
                                label: '내용',
                                hintText: '내용 입력',
                                minLines: 7,
                                controller: _contentController,
                              ),
                              spacing,
                              const ToyVillageLabel(
                                label: '첨부파일',
                                isOptional: true,
                              ),
                              const SizedBox(height: 8),
                              AttachmentEditor(
                                files: _files,
                                onAdd: _addAttachment,
                                onDelete: _deleteAttachment,
                              ),
                              spacing,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: ToyVillageButton(
                  label: isSaving ? '저장 중...' : '저장하기',
                  onTap: _save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
