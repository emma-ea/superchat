part of 'home_cubit.dart';

class HomeState extends Equatable {

  final HomeStatus _status;
  final String _searchCategory;

  const HomeState({HomeStatus status = HomeStatus.initial, String category = ''}) 
    : _status = status, 
    _searchCategory = category;

  HomeState copyWith({HomeStatus? status, String? searchCategory}) {
    return HomeState(
      status: status ?? _status,
      category: searchCategory ?? _searchCategory,
    );
  }

  @override
  List<Object?> get props => [_status, _searchCategory];

}

enum HomeStatus {
  initial,
  loading,
  loaded,
  error,
}