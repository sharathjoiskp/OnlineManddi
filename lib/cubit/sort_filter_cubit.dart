import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../utils/utils.dart';

part 'sort_filter_state.dart';

class SortFilterCubit extends Cubit<SortFilterState> {
  SortFilterCubit() : super(SortFilterInitial(
    
  ));

  void selectedFilter(String selectedFilterValue) {
    emit(SelectedFilter(selectedFilterValue));
  }

  void selectedSort(PostSortType selectedSortValue) {
    emit(SelectedSort(selectedSortValue));
  }
}
