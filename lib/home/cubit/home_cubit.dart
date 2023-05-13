import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superchat/home/repository/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {

  final HomeRepository repository;
  
  HomeCubit(this.repository) : super(const HomeState());

  Future<void> searchCategory({required String category}) async {
    emit(state.copyWith(status: HomeStatus.loading));
    await Future.delayed(const Duration(seconds: 3));
    final user = await repository.createUser();
    emit(state.copyWith(status: HomeStatus.loaded, searchCategory: user));
    // access repo/usecase
    // emit right/left based on result
  }
  
}