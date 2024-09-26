import 'package:example/base_bloc_example/bloc/base_bloc_example_screen_bloc.dart';
import 'package:example/base_cubit_example/cubit/base_cubit_example_screen_cubit.dart';
import 'package:get_it/get_it.dart';

void initializeDi(GetIt getIt) {
  // Registering the BLoC class
  getIt.registerFactory<BaseBlocExampleScreenBloc>(
      BaseBlocExampleScreenBloc.new);

  // Registering the Cubit class
  getIt.registerFactory<BaseCubitExampleScreenCubit>(
      BaseCubitExampleScreenCubit.new);
}
