import 'dart:async';
import 'dart:io';

import 'constants.dart';


class Result<T> {
   Result._();
 factory Result.loading(T msg) = LoadingState<T>;

  factory Result.success(T value) = SuccessState<T>;

  factory Result.error(T msg) = ErrorState<T>;

}


class LoadingState<T> extends Result<T> {
  LoadingState(this.msg) : super._();
  final T msg;
}


class ErrorState<T> extends Result<T> {
  String msg = "";

  // String message;

  ErrorState(T error) : super._() {
    if (error is SocketException || error is TimeoutException) {
      // msg = (error).osError.message;
      msg = Constants.MSG_NO_INTERNET;
    }
    else {
      msg =error.toString();
    }

  }

// void setError(T msg) {
//   if (msg is SocketException) {
//     message = (msg as SocketException).osError.message;
//   }
// }
}

class SuccessState<T> extends Result<T> {
  SuccessState(this.value) : super._();
    // Succmsg = value.toString();
  final T value;
}
