import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'block_event.dart';

class ThemeBloc extends Bloc<BlockEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.light) {
    on<ToggelEvent>((event, emit) {
      emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
    });
  }
}
