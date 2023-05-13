part of 'home_cubit.dart';

class HomeState extends Equatable {

  final HomeStatus status;
  final String searchCategory;
  final Map<String, dynamic> extra;

  const HomeState({this.status = HomeStatus.initial, this.searchCategory = '', this.extra = const {}});

  HomeState copyWith({HomeStatus? status, String? searchCategory, Map<String, String>? extra}) {
    return HomeState(
      status: status ?? this.status,
      searchCategory: searchCategory ?? this.searchCategory,
      extra: extra ?? this.extra,
    );
  }

  @override
  List<Object?> get props => [status, searchCategory];

}

enum HomeStatus {
  initial,
  loading,
  userLoaded,
  loaded,
  error,
}