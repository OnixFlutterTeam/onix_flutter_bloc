import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:onix_flutter_bloc/src/bloc/base_bloc/base_bloc.dart';
import 'package:onix_flutter_bloc/src/bloc/bloc_typedefs.dart';
import 'package:onix_flutter_bloc/src/bloc/mixins/bloc_builders_mixin.dart';
import 'package:onix_flutter_bloc/src/bloc/stream_listener.dart';
import 'package:onix_flutter_core_models/onix_flutter_core_models.dart';

abstract class BaseState<S, B extends BaseBloc<dynamic, S, SR>, SR,
        W extends StatefulWidget> extends State<W>
    with BlocBuildersMixin<B, S, SR> {
  bool _listenersAttached = false;
  bool lazyBloc = false;
  B? _bloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: (context) {
        final bloc = createBloc();
        _bloc = bloc;
        return bloc;
      },
      lazy: lazyBloc,
      child: Builder(
        builder: (context) {
          if (_bloc != null) {
            if (!_listenersAttached) {
              _listenersAttached = true;
              _attachListeners(context);
            }
            onBlocCreated(context, _bloc!);
          }
          initParams(context);
          return buildWidget(context);
        },
      ),
    );
  }

  @override
  void dispose() {
    if (_bloc != null) {
      _bloc?.dispose();
    }
    if (context.mounted) {
      context.loaderOverlay.hide();
    }
    super.dispose();
  }

  B blocOf(BuildContext context) => context.read<B>();

  B createBloc();

  Widget srObserver({
    required BuildContext context,
    required Widget child,
    required SingleResultListener<SR> onSR,
  }) {
    return StreamListener<SR>(
      stream: (_bloc ?? blocOf(context)).singleResults,
      onData: (data) {
        onSR(context, data);
      },
      child: child,
    );
  }

  void onBlocCreated(BuildContext context, B bloc) {}

  void onFailure(BuildContext context, Exception failure) {}

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

  // ignore: no-empty-block
  void initParams(BuildContext context) {}

  Widget buildWidget(BuildContext context);

  void _attachListeners(BuildContext context) {
    _bloc?.failureStream.listen((failure) {
      if (!context.mounted) return;
      onFailure(context, failure);
    });

    _bloc?.singleResults.listen((sr) {
      if (!context.mounted) return;
      onSR(context, sr);
    });

    _bloc?.progressStream.listen((progress) {
      if (!context.mounted) return;
      onProgress(context, progress);
    });
  }
}
