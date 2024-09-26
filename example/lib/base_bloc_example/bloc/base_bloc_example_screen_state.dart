part of 'base_bloc_example_screen_bloc.dart';

@immutable
abstract class BaseBlocExampleScreenState {}

final class BaseBlocExampleScreenInitial extends BaseBlocExampleScreenState {}

final class BaseBlocExampleScreenData extends BaseBlocExampleScreenState {
  final int counter;

  BaseBlocExampleScreenData(this.counter);
}
