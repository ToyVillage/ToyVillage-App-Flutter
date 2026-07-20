import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/document/data/model/document_detail_model.dart';
import 'package:toy_village_app/features/document/data/repository/document_detail_repository.dart';

final documentDetailViewModelProvider =
    AsyncNotifierProvider.family<
      DocumentDetailViewModel,
      DocumentDetailModel,
      int
    >(DocumentDetailViewModel.new);

class DocumentDetailViewModel extends AsyncNotifier<DocumentDetailModel> {
  final int id;

  DocumentDetailViewModel(this.id);

  @override
  FutureOr<DocumentDetailModel> build() {
    return ref
        .read(documentDetailRepositoryProvider)
        .loadDocumentDetail(id: id);
  }
}
