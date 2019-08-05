///Utility class that decides whether we should fetch some data or not.
class RateLimiter {
  Map<String, int> timestamps = new Map();

  final int _timeout;

  ///[_timeout] : rate at which we should fetch data in minutes
//  RateLimiter(this._timeout);

  static final RateLimiter _rateLimiter = RateLimiter._internal();

  factory RateLimiter() {
    return _rateLimiter;
  }

  RateLimiter._internal([this._timeout = 15]);

  bool shouldFetch(String key) {
    int lastFetched = timestamps[key];
    var now = DateTime.now();
    if (lastFetched == null) {
      print('shouldFetch yes lastFetched == null');
      timestamps[key] = now.millisecond;
      return true;
    }

    if (now.millisecond - lastFetched >
        Duration(minutes: _timeout).inMilliseconds) {
      print('shouldFetch yes timeout');
      timestamps[key] = now.millisecond;
      return true;
    }

    print('shouldFetch false');
    return false;
  }

  void reset(String key) {
    timestamps.remove(key);
  }
}

RateLimiter getRateLimiter = RateLimiter();
