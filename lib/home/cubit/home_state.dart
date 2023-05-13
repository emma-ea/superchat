part of 'home_cubit.dart';

class HomeState extends Equatable {

  final HomeStatus status;
  final String searchCategory;

  const HomeState({this.status = HomeStatus.initial, this.searchCategory = ''});

  HomeState copyWith({HomeStatus? status, String? searchCategory}) {
    return HomeState(
      status: status ?? this.status,
      searchCategory: searchCategory ?? this.searchCategory,
    );
  }

  @override
  List<Object?> get props => [status, searchCategory];

}

enum HomeStatus {
  initial,
  loading,
  loaded,
  error,
}