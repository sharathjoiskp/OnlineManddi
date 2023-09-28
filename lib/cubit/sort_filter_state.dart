part of 'sort_filter_cubit.dart';

@immutable
class SortFilterState {}

class SortFilterInitial extends SortFilterState {}

class SelectedFilter extends SortFilterState {
  final String selectedFilter;

  SelectedFilter(this.selectedFilter);
}

class SelectedSort extends SortFilterState {
  PostSortType selectedSort;

  SelectedSort(this.selectedSort);
}
