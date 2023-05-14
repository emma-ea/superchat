import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superchat/core_utils/chat_exceptions.dart';
import 'package:superchat/core_utils/constants.dart';
import 'package:superchat/home/repository/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {

  final HomeRepository repository;
  
  HomeCubit(this.repository) : super(const HomeState());

  Future<void> searchCategory({required String category}) async {
    try {
    emit(state.copyWith(status: HomeStatus.loading));
    
    int ret = await repository.generateTopic(term: category.toLowerCase());

    if (ret == AppConstants.addUserToTopic) {
      emit(state.copyWith(status: HomeStatus.loaded, searchCategory: category));
    } else {
      emit(state.copyWith(status: HomeStatus.error, extra: {'error': AppConstants.unknown}));
    }

    } on CategoryCreationException catch (e, _) {
      emit(state.copyWith(status: HomeStatus.error, extra: {'error': e.error}));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.error, extra: {'error': e.toString()}));
    }
  }

  Future<void> getUser() async {
    try {
      emit(state.copyWith(status: HomeStatus.userLoading));
      final user = await repository.getUser();
      emit(state.copyWith(status: HomeStatus.userLoaded, userId: user));
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.userError, extra: {'error': '$e'}));
    }
  }

  Future<void> updateUserStatus({required String userId, bool isActive = false, bool inChat = false}) async {
    await repository.updateUserStatus(userId: userId, isActive: isActive, inChat: inChat);
  }

  Future<void> deleteUser() async {
    await repository.deleteUser(state.userId);
  }

  Stream<int> getActiveUsers() {
    return repository.getActiveUsers();
  }
  
}