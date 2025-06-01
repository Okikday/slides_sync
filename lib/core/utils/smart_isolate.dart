// ignore_for_file: unintended_html_in_doc_comment

import 'dart:async';
import 'dart:isolate';

/// ------------------------------------------------------------
/// USAGE:
///
///   /// 1. Define your top-level or static task function:
///   Future<void> decodeImageTask(
///     String path,
///     void Function(double) emitProgress,
///     void Function(List<int>) emitResult,
///   ) async {
///     final fileBytes = <int>[];
///     final file = File(path);
///     final total = file.lengthSync();
///     int read = 0;
///
///     final stream = file.openRead();
///     await for (final chunk in stream) {
///       fileBytes.addAll(chunk);
///       read += chunk.length;
///       emitProgress(read / total);
///     }
///     emitResult(fileBytes);
///   }
///
///   /// 2. Create an instance and run:
///   final smart = SmartIsolate<String, double, List<int>>();
///   smart.progressStream.listen((percent) {
///     print('Progress: ${(percent * 100).toStringAsFixed(0)}%');
///   });
///   final bytes = await smart.runWithProgress(
///     decodeImageTask,
///     '/path/to/large_image.png',
///   );
///
///   /// 3. If you need to cancel mid-flight:
///   smart.cancel();
/// ------------------------------------------------------------
class SmartIsolate<TArg, TProgress, TResult> {
  late final Isolate _isolate;
  final ReceivePort _receivePort = ReceivePort();
  late final StreamController<TProgress> _progressController;
  StreamSubscription? _portSubscription;

  SmartIsolate() {
    // Use a single-listener controller for slightly lower overhead (if only one subscriber)
    _progressController = StreamController<TProgress>();
  }

  /// Spawns a new isolate that runs [task].  Returns a Future that completes
  /// with the result.  Progress updates (of type TProgress) are emitted on
  /// [progressStream].
  ///
  /// [task] MUST be a top‐level or static function of signature:
  ///   Future<void> myTask(
  ///     TArg arg,
  ///     void Function(TProgress) emitProgress,
  ///     void Function(TResult) emitResult,
  ///   )
  ///
  /// You cannot pass closures that “capture” local variables into an isolate.
  Future<TResult> runWithProgress(
    Future<void> Function(
      TArg arg,
      void Function(TProgress) emitProgress,
      void Function(TResult) emitResult,
    ) task,
    TArg arg,
  ) async {
    final completer = Completer<TResult>();

    // Listen for messages from the spawned isolate:
    _portSubscription = _receivePort.listen((dynamic message) {
      if (message is _SmartIsolateProgress<TProgress>) {
        // emit a progress update
        if (!_progressController.isClosed) {
          _progressController.add(message.data);
        }
      } else if (message is _SmartIsolateResult<TResult>) {
        // got final result ▶ complete and tear down
        if (!completer.isCompleted) {
          completer.complete(message.data);
          _tearDown();
        }
      } else if (message is _SmartIsolateError) {
        // got an error ▶ propagate it
        if (!completer.isCompleted) {
          completer.completeError(message.error, message.stack);
          _tearDown();
        }
      }
      // any other message types can be ignored or logged
    });

    // Spawn the isolate using _entryPoint.  We must pass a payload that
    // contains: (arg, the task function (which must be top-level), and a SendPort).
    _isolate = await Isolate.spawn<_SmartIsolatePayload<TArg, TProgress, TResult>>(
      _entryPoint,
      _SmartIsolatePayload<TArg, TProgress, TResult>(
        arg: arg,
        task: task,
        mainSendPort: _receivePort.sendPort,
      ),
    );

    return completer.future;
  }

  /// Stream of progress events (only works _after_ you call runWithProgress).
  Stream<TProgress> get progressStream => _progressController.stream;

  /// Requests cancellation of the running isolate. If the isolate is already
  /// finished, this is a no-op.
  void cancel() {
    _isolate.kill(priority: Isolate.immediate);
    _tearDown();
  }

  void _tearDown() {
    // Make sure to cancel the port subscription before closing ports/controllers.
    _portSubscription?.cancel();
    if (!_progressController.isClosed) _progressController.close();
    _receivePort.close();
  }

  /// The actual entry point for the spawned isolate.  This must be a
  /// top‐level or static function.
  static void _entryPoint<TArg, TProgress, TResult>(
    _SmartIsolatePayload<TArg, TProgress, TResult> payload,
  ) async {
    try {
      // Helper closures that wrap sending typed messages back to main isolate:
      void emitProgress(TProgress data) {
        payload.mainSendPort.send(_SmartIsolateProgress<TProgress>(data));
      }

      void emitResult(TResult data) {
        payload.mainSendPort.send(_SmartIsolateResult<TResult>(data));
      }

      // Run the user‐provided task:
      await payload.task(payload.arg, emitProgress, emitResult);
    } catch (e, st) {
      payload.mainSendPort.send(_SmartIsolateError(e, st));
    }
  }
}

class _SmartIsolatePayload<TArg, TProgress, TResult> {
  final TArg arg;
  final Future<void> Function(
    TArg arg,
    void Function(TProgress) emitProgress,
    void Function(TResult) emitResult,
  ) task;
  final SendPort mainSendPort;

  _SmartIsolatePayload({
    required this.arg,
    required this.task,
    required this.mainSendPort,
  });
}

class _SmartIsolateProgress<TProgress> {
  final TProgress data;
  _SmartIsolateProgress(this.data);
}

class _SmartIsolateResult<TResult> {
  final TResult data;
  _SmartIsolateResult(this.data);
}

class _SmartIsolateError {
  final Object error;
  final StackTrace stack;
  _SmartIsolateError(this.error, this.stack);
}
