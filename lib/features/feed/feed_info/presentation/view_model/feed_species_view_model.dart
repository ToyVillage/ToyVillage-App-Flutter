import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toy_village_app/features/feed/feed_info/data/model/feed_species.dart';

final feedSpeciesViewModelProvider =
    NotifierProvider<FeedSpeciesViewModel, List<FeedSpecies>>(
      FeedSpeciesViewModel.new,
    );

class FeedSpeciesViewModel extends Notifier<List<FeedSpecies>> {
  @override
  List<FeedSpecies> build() {
    return const [
      FeedSpecies(speciesName: '카피바라', category: '포유류'),
      FeedSpecies(speciesName: '원숭이', category: '포유류'),
      FeedSpecies(speciesName: '사막여우', category: '포유류'),
      FeedSpecies(speciesName: '흰동가리', category: '어류'),
      FeedSpecies(speciesName: '금붕어', category: '어류'),
      FeedSpecies(speciesName: '거북', category: '파충류'),
      FeedSpecies(speciesName: '이구아나', category: '파충류'),
      FeedSpecies(speciesName: '비둘기', category: '조류'),
      FeedSpecies(speciesName: '앵무', category: '조류'),
    ];
  }
}
