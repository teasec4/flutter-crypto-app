import 'dart:math' as math;

abstract interface class RetryStrategy {
  /// Execute operation with retry logic
  /// Throws the last exception if all retries are exhausted
  Future<T> execute<T>(Future<T> Function() operation);
}

class ExponentialBackoffRetry implements RetryStrategy {
  final int maxAttempts;
  final Duration initialDelay;
  final double backoffMultiplier;

  ExponentialBackoffRetry({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 5),
    this.backoffMultiplier = 2.0,
  });

  @override
  Future<T> execute<T>(Future<T> Function() operation) async {
    int attempt = 0;
    Exception? lastException;

    while (attempt < maxAttempts) {
      try {
        return await operation();
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        attempt++;

        if (attempt >= maxAttempts) {
          break;
        }

        // Calculate delay: 5s, 10s, 20s, etc.
        final delayMs =
            (initialDelay.inMilliseconds *
                    math.pow(backoffMultiplier, attempt - 1))
                .toInt();
        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }

    throw lastException ?? Exception('Max retries exceeded');
  }
}

class NoRetry implements RetryStrategy {
  @override
  Future<T> execute<T>(Future<T> Function() operation) async {
    return await operation();
  }
}
