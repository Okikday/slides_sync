import 'dart:developer';

enum ResultStatus { loading, success, error }

class Result<T> {
  final ResultStatus status;
  final T? data;
  final String? message;
  final StackTrace? stackTrace;

  const Result._({required this.status, this.data, this.message, this.stackTrace});

  const Result.loading() : this._(status: ResultStatus.loading);

  factory Result.success(T value, {String? logMsg}) {
    if (logMsg != null) log("success: $logMsg");
    return Result._(status: ResultStatus.success, data: value);
  }

  factory Result.error(String message, [StackTrace? st, bool logError = true]) {
   if(logError) log("error: $message", error: message, stackTrace: st);
    return Result._(status: ResultStatus.error, message: message, stackTrace: st);
  }

  bool get isLoading => status == ResultStatus.loading;
  bool get isSuccess => status == ResultStatus.success;
  bool get isError => status == ResultStatus.error;

  @override
  String toString() {
    switch (status) {
      case ResultStatus.loading:
        return 'Result<$T>: Loading';
      case ResultStatus.success:
        return 'Result<$T>: Success(data=$data)';
      case ResultStatus.error:
        return 'Result<$T>: Error(message=$message)';
    }
  }

  /// Runs [operation] and wraps the result in a [Result.success] or [Result.error] if it throws.
  static Future<Result<T?>> tryRunAsync<T>(Future<T?> Function() operation, {bool logError = true}) async {
    try {
      final value = await operation();
      return Result.success(value);
    } catch (e, st) {
      return Result.error(e.toString(), st, logError);
    }
  }

  static Result<T?> tryRun<T>(T? Function() operation, {bool logError = true}) {
    try {
      final value = operation();
      return Result.success(value);
    } catch (e, st) {
      return Result.error(e.toString(), st, logError);
    }
  }

  /// Runs [transform] only if this is a success. Otherwise propagates loading/error.
  Result<U> doNext<U>(U Function(T data) transform) {
    if (isSuccess) {
      return Result<U>.success(transform(data as T));
    } else if (isError) {
      return Result<U>.error(message!);
    } else {
      return Result<U>.loading();
    }
  }

  /// Runs [futureProducer] only if this is a success; otherwise propagates loading/error.
  Future<Result<U>> doNextAsync<U>(Future<Result<U>> Function(T data) futureProducer) async {
    if (isSuccess) {
      return await futureProducer(data as T);
    } else if (isError) {
      return Result<U>.error(message!);
    } else {
      return Result<U>.loading();
    }
  }

  Result<T> onError(void Function(String message, [StackTrace? st]) handler) {
    if (isError) {
      handler(message!, stackTrace);
    }
    return this;
  }
}
