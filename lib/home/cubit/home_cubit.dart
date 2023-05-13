import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superchat/core_utils/chat_exceptions.dart';
import 'package:superchat/home/repository/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {

  final HomeRepository repository;
  
  HomeCubit(this.repository) : super(const HomeState());

  Future<void> searchCategory({required String category}) async {
    try {
    emit(state.copyWith(status: HomeStatus.loading));
    
    int res = await repository.processCategory(term: category);

    if (res == 1) {
      emit(state.copyWith(status: HomeStatus.loaded, extra: {'result': '$res'}));
    }

    } on CategoryCreationException catch (e, _) {
      emit(state.copyWith(status: HomeStatus.error, extra: {'error': e.error}));
    }
  }

  Future<void> getUser() async {
    try {
      final user = await repository.getUser();
      emit(state.copyWith(extra: {'user': user}));
    } catch (e) {
      emit(state.copyWith());
    }
  }

  Stream<int> getActiveUsers() {
    return repository.getActiveUsers();
  }
  
}