import 'dart:async';

mixin class FailureStreamMixin {
  final StreamController<Exception> _errorStreamController =
      StreamController<Exception>.broadcast();

  Stream<Exception> get failureStream => _errorStreamController.stream;

  void onFailure(Exception failure) {
    if (!_errorStreamController.isClosed) {
      _errorStreamController.add(failure);
    }
  }

  void closeFailureStream() {
    if (!_errorStreamController.isClosed) {
      _errorStreamController.close();
    }
  }
}
