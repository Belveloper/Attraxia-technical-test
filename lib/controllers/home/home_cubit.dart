import 'package:attraxiachat/controllers/home/home_state.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit getCubit(BuildContext context) => BlocProvider.of(context);


  int currentPageIndex = 0;

  void setPageIndex(int index) {
    currentPageIndex = index;
    emit(HomeSetNavigatipnIndexState());
  }
}
