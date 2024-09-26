import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    if (kDebugMode) {
      print('AppBlocObserver::onEvent');
      print(event.toString());
    }
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('AppBlocObserver::onError');
      print(error);
      print(stackTrace);
    }
    super.onError(bloc, error, stackTrace);
  }
}
