import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onix_flutter_bloc/src/bloc/base_cubit/base_cubit.dart';
import 'package:onix_flutter_bloc/src/bloc/bloc_typedefs.dart';
import 'package:onix_flutter_bloc/src/bloc/mixins/bloc_builders_mixin.dart';
import 'package:onix_flutter_bloc/src/bloc/stream_listener.dart';
import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

abstract class BaseCubitState<S, C extends BaseCubit<S, SR>, SR,
        W extends StatefulWidget> extends State<W>
    with BlocBuildersMixin<C, S, SR> {
  bool _listenersAttached = false;
  bool lazyCubit = false;
  C? _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<C>(
      create: (context) {
        final cubit = createCubit();
        onCubitCreated(context, cubit);
        _cubit = cubit;
        return cubit;
      },
      lazy: lazyCubit,
      child: Builder(
        builder: (context) {
          if (!_listenersAttached) {
            _listenersAttached = true;
            _attachListeners(context);
          }
          initParams(context);
          return buildWidget(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_cubit != null) {
      _cubit?.dispose();
    }
    if (context.mounted) {
      context.loaderOverlay.hide();
    }
    super.dispose();
  }

  C cubitOf(BuildContext context) => context.read<C>();

  C createCubit();

  Widget srObserver({
    required BuildContext context,
    required Widget child,
    required SingleResultListener<SR> onSR,
  }) {
    return StreamListener<SR>(
      stream: (_cubit ?? cubitOf(context)).singleResults,
      onData: (data) {
        onSR(context, data);
      },
      child: child,
    );
  }

  void onCubitCreated(BuildContext context, C cubit) {}

  void onFailure(BuildContext context, Failure failure) {}

  void onSR(BuildContext context, SR sr) {}

  void onProgress(BuildContext context, BaseProgressState progress) {
    if (progress is DefaultProgressState) {
      if (progress.showProgress) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    }
  }

  void _attachListeners(BuildContext context) {
    _cubit?.failureStream.listen((failure) {
      if (!context.mounted) return;
      onFailure(context, failure);
    });

    _cubit?.singleResults.listen((sr) {
      if (!context.mounted) return;
      onSR(context, sr);
    });

    _cubit?.progressStream.listen((progress) {
      if (!context.mounted) return;
      onProgress(context, progress);
    });
  }

// ignore: no-empty-block
  void initParams(BuildContext context) {}

  Widget buildWidget(BuildContext context);
}
