///Utility class that decides whether we should fetch some data or not.
class RateLimiter<KEY> {
  Map<KEY, int> timestamps = new Map();

  final int _timeout;

  ///[_timeout] : rate at which we should fetch data in minutes
  RateLimiter(this._timeout);

  bool shouldFetch(KEY key) {
    int lastFetched = timestamps[key];
    var now = DateTime.now();
    if (lastFetched == null) {
      print('lastFetched == null');
      timestamps[key] = now.millisecond;
      return true;
    }

    if (now.millisecond - lastFetched >
        Duration(minutes: _timeout).inMilliseconds) {
      print('now.millisecond - lastFetched > timeout');
      timestamps[key] = now.millisecond;
      return true;
    }

    print('now.millisecond - lastFetched > false');
    return false;
  }

  void reset(KEY key) {
    timestamps.remove(key);
  }
}
