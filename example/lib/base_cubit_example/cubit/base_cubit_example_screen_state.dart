part of 'base_cubit_example_screen_cubit.dart';

@immutable
abstract class BaseCubitExampleScreenState {}

final class BaseCubitExampleScreenInitial extends BaseCubitExampleScreenState {}

final class BaseCubitExampleScreenData extends BaseCubitExampleScreenState {
  final int counter;

  BaseCubitExampleScreenData(this.counter);
}
