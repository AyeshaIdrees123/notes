part of 'block_bloc.dart';

abstract class BlockState {}

class BlockInitial extends BlockState {}

class ToggelState extends BlockState {
  final bool isDarkTheme;
  ToggelState(this.isDarkTheme);
}
