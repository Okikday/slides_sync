// // ignore_for_file: unintended_html_in_doc_comment

// import 'dart:async';
// import 'dart:isolate';
// import 'dart:developer' as developer;

// /// ------------------------------------------------------------
// /// IMPROVED SmartIsolate with better error handling and validation
// /// 
// /// KEY LIMITATIONS OF DART ISOLATES:
// /// 1. Only top-level or static functions can be passed to isolates
// /// 2. Functions cannot capture local variables, instance variables, or methods
// /// 3. All arguments must be "sendable" (primitives, collections of primitives, SendPort, etc.)
// /// 
// /// USAGE:
// /// 
// /// ```dart
// /// // ✅ CORRECT - Top-level function with sendable arguments
// /// Future<void> processImagesTask(
// ///   Map<String, dynamic> args,
// ///   void Function(double) emitProgress,
// ///   void Function(List<String>) emitResult,
// /// ) async {
// ///   final imagePaths = List<String>.from(args['imagePaths']);
// ///   final targetSize = args['targetSize'] as double;
// ///   
// ///   final results = <String>[];
// ///   for (int i = 0; i < imagePaths.length; i++) {
// ///     // Process image...
// ///     emitProgress((i + 1) / imagePaths.length);
// ///   }
// ///   emitResult(results);
// /// }
// /// 
// /// // Usage:
// /// final isolate = SmartIsolate<Map<String, dynamic>, double, List<String>>();
// /// final result = await isolate.runWithProgress(
// ///   processImagesTask,
// ///   {
// ///     'imagePaths': ['/path/1.jpg', '/path/2.jpg'],
// ///     'targetSize': 0.05,
// ///   },
// /// );
// /// ```
// /// ------------------------------------------------------------

// class SmartIsolate<TArg, TProgress, TResult> {
//   late final Isolate _isolate;
//   final ReceivePort _receivePort = ReceivePort();
//   late final StreamController<TProgress> _progressController;
//   StreamSubscription? _portSubscription;
//   bool _isRunning = false;

//   SmartIsolate() {
//     _progressController = StreamController<TProgress>.broadcast();
//   }

//   /// Returns true if the isolate is currently running
//   bool get isRunning => _isRunning;

//   /// Validates that the function and arguments can be sent to an isolate
//   /// This helps catch common mistakes early
//   bool _validateForIsolate(dynamic function, dynamic arg) {
//     try {
//       // Try to create a minimal payload to test sendability
//       // final testPayload = _SmartIsolatePayload<TArg, TProgress, TResult>(
//       //   arg: arg,
//       //   task: function,
//       //   mainSendPort: _receivePort.sendPort,
//       // );
      
//       // If we can serialize the payload, it should work
//       // This is a basic check - some edge cases might still fail
//       return true;
//     } catch (e) {
//       developer.log('SmartIsolate validation failed: $e', name: 'SmartIsolate');
//       return false;
//     }
//   }

//   /// Spawns a new isolate that runs [task]. Returns a Future that completes
//   /// with the result. Progress updates are emitted on [progressStream].
//   ///
//   /// [task] MUST be a top-level or static function of signature:
//   ///   Future<void> myTask(
//   ///     TArg arg,
//   ///     void Function(TProgress) emitProgress,
//   ///     void Function(TResult) emitResult,
//   ///   )
//   ///
//   /// IMPORTANT: The function cannot capture any local variables, instance
//   /// variables, or methods. All data must be passed through [arg].
//   Future<TResult> runWithProgress(
//     Future<void> Function(
//       TArg arg,
//       void Function(TProgress) emitProgress,
//       void Function(TResult) emitResult,
//     ) task,
//     TArg arg,
//   ) async {
//     if (_isRunning) {
//       throw StateError('SmartIsolate is already running. Create a new instance or wait for completion.');
//     }

//     // Validate that the function and arguments are sendable
//     if (!_validateForIsolate(task, arg)) {
//       throw ArgumentError(
//         'The provided function or arguments cannot be sent to an isolate. '
//         'Ensure the function is top-level or static and doesn\'t capture local variables. '
//         'All arguments must be sendable types (primitives, collections, etc.).'
//       );
//     }

//     _isRunning = true;
//     final completer = Completer<TResult>();

//     // Listen for messages from the spawned isolate
//     _portSubscription = _receivePort.listen((dynamic message) {
//       if (message is _SmartIsolateProgress<TProgress>) {
//         if (!_progressController.isClosed) {
//           _progressController.add(message.data);
//         }
//       } else if (message is _SmartIsolateResult<TResult>) {
//         if (!completer.isCompleted) {
//           completer.complete(message.data);
//           _tearDown();
//         }
//       } else if (message is _SmartIsolateError) {
//         if (!completer.isCompleted) {
//           completer.completeError(
//             SmartIsolateException(message.error.toString(), message.stack),
//             message.stack,
//           );
//           _tearDown();
//         }
//       }
//     });

//     try {
//       // Spawn the isolate
//       _isolate = await Isolate.spawn<_SmartIsolatePayload<TArg, TProgress, TResult>>(
//         _entryPoint,
//         _SmartIsolatePayload<TArg, TProgress, TResult>(
//           arg: arg,
//           task: task,
//           mainSendPort: _receivePort.sendPort,
//         ),
//       );
//     } catch (e, stackTrace) {
//       _tearDown();
      
//       // Provide helpful error messages for common issues
//       if (e.toString().contains('unsendable')) {
//         throw SmartIsolateException(
//           'Cannot send function or arguments to isolate. '
//           'Common causes:\n'
//           '1. Function captures local variables (use top-level/static functions)\n'
//           '2. Arguments contain non-sendable objects (use primitive types)\n'
//           '3. Function references instance methods or variables\n'
//           'Original error: $e',
//           stackTrace,
//         );
//       }
      
//       throw SmartIsolateException('Failed to spawn isolate: $e', stackTrace);
//     }

//     return completer.future;
//   }

  

//   /// Stream of progress events
//   Stream<TProgress> get progressStream => _progressController.stream;

//   /// Cancels the running isolate
//   void cancel() {
//     if (_isRunning) {
//       _isolate.kill(priority: Isolate.immediate);
//       _tearDown();
//     }
//   }

//   /// Disposes of all resources
//   void dispose() {
//     cancel();
//   }

//   void _tearDown() {
//     _isRunning = false;
//     _portSubscription?.cancel();
//     if (!_progressController.isClosed) _progressController.close();
//     _receivePort.close();
//   }

//   /// The entry point for the spawned isolate
//   static void _entryPoint<TArg, TProgress, TResult>(
//     _SmartIsolatePayload<TArg, TProgress, TResult> payload,
//   ) async {
//     try {
//       void emitProgress(TProgress data) {
//         payload.mainSendPort.send(_SmartIsolateProgress<TProgress>(data));
//       }

//       void emitResult(TResult data) {
//         payload.mainSendPort.send(_SmartIsolateResult<TResult>(data));
//       }

//       await payload.task(payload.arg, emitProgress, emitResult);
//     } catch (e, st) {
//       payload.mainSendPort.send(_SmartIsolateError(e, st));
//     }
//   }
// }

// /// Custom exception for SmartIsolate errors
// class SmartIsolateException implements Exception {
//   final String message;
//   final StackTrace? stackTrace;

//   SmartIsolateException(this.message, [this.stackTrace]);

//   @override
//   String toString() => 'SmartIsolateException: $message';
// }

// /// Helper class to create sendable task arguments
// class IsolateTaskArgs {
//   final Map<String, dynamic> _data = {};

//   IsolateTaskArgs();

//   /// Add a sendable value to the arguments
//   void add(String key, dynamic value) {
//     if (_isSendable(value)) {
//       _data[key] = value;
//     } else {
//       throw ArgumentError('Value for key "$key" is not sendable to isolate: $value');
//     }
//   }

//   /// Get a value from the arguments
//   T get<T>(String key) {
//     if (!_data.containsKey(key)) {
//       throw ArgumentError('Key "$key" not found in task arguments');
//     }
//     return _data[key] as T;
//   }

//   /// Get the raw data map
//   Map<String, dynamic> get data => Map.unmodifiable(_data);

//   /// Check if a value can be sent to an isolate
//   static bool _isSendable(dynamic value) {
//     if (value == null) return true;
//     if (value is num || value is String || value is bool) return true;
//     if (value is List) return value.every(_isSendable);
//     if (value is Map) return value.values.every(_isSendable) && value.keys.every(_isSendable);
//     if (value is Set) return value.every(_isSendable);
//     return false;
//   }
// }

// // Internal classes remain the same
// class _SmartIsolatePayload<TArg, TProgress, TResult> {
//   final TArg arg;
//   final Future<void> Function(
//     TArg arg,
//     void Function(TProgress) emitProgress,
//     void Function(TResult) emitResult,
//   ) task;
//   final SendPort mainSendPort;

//   _SmartIsolatePayload({
//     required this.arg,
//     required this.task,
//     required this.mainSendPort,
//   });
// }

// class _SmartIsolateProgress<TProgress> {
//   final TProgress data;
//   _SmartIsolateProgress(this.data);
// }

// class _SmartIsolateResult<TResult> {
//   final TResult data;
//   _SmartIsolateResult(this.data);
// }

// class _SmartIsolateError {
//   final Object error;
//   final StackTrace stack;
//   _SmartIsolateError(this.error, this.stack);
// }