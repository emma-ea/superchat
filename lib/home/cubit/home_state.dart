part of 'home_cubit.dart';

class HomeState extends Equatable {

  final HomeStatus status;
  final String userId;
  final String searchCategory;
  final Map<String, dynamic> extra;

  const HomeState({this.status = HomeStatus.initial, this.searchCategory = '', this.userId = '', this.extra = const {}});

  HomeState copyWith({HomeStatus? status, String? userId, String? searchCategory, Map<String, String>? extra}) {
    return HomeState(
      status: status ?? this.status,
      searchCategory: searchCategory ?? this.searchCategory,
      extra: extra ?? this.extra,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [status, searchCategory, extra, userId];

}

enum HomeStatus {
  initial,
  loading,
  userLoaded,
  userLoading,
  userError,
  loaded,
  error,
}