import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/document/data/model/document_model.dart';
import 'package:toy_village_app/features/document/data/repository/document_repository.dart';
import 'package:toy_village_app/features/document/presentation/widget/sort_dropdown.dart';

final documentViewModelProvider =
    AsyncNotifierProvider<DocumentViewModel, List<DocumentModel>>(
      () => DocumentViewModel(),
    );

class DocumentViewModel extends AsyncNotifier<List<DocumentModel>> {
  SortOrder _order = SortOrder.latest;

  SortOrder get order => _order;

  @override
  FutureOr<List<DocumentModel>> build() {
    return _load();
  }

  Future<List<DocumentModel>> _load() {
    return ref
        .read(documentRepositoryProvider)
        .loadDocuments(orderDirection: _order.direction);
  }

  Future<void> changeOrder(SortOrder order) async {
    if (_order == order) return;
    _order = order;
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}
