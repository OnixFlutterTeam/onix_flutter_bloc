import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onix_flutter_bloc/src/arch/bloc/base_bloc/sr_bloc_mixin.dart';
import 'package:onix_flutter_bloc/src/arch/bloc/mixins/failure_stream_mixin.dart';
import 'package:onix_flutter_bloc/src/arch/bloc/mixins/progress_stream_mixin.dart';

abstract class BaseBloc<Event, State, SR> extends Bloc<Event, State>
    with
        SingleResultBlocMixin<Event, State, SR>,
        ProgressStreamMixin,
        FailureStreamMixin {
  BaseBloc(super.initialState);

  void dispose() {
    closeProgressStream();
    closeFailureStream();
  }
}
