import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  
  HomeCubit() : super(const HomeState());

  Future<void> searchCategory({required String category}) async {
    emit(state.copyWith(status: HomeStatus.loading));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(status: HomeStatus.loaded));
    // access repo/usecase
    // emit right/left based on result
  }
  
}