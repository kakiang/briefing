///Utility class that decides whether we should fetch some data or not.
import 'package:briefing/repository/repository.dart';

class RateLimiter {
  Map<String, int> timestamps = new Map();

  final int _timeout;

  ///[_timeout] : rate at which we should fetch data in minutes
//  RateLimiter(this._timeout);

  static final RateLimiter _rateLimiter = RateLimiter._internal();

  factory RateLimiter() {
    return _rateLimiter;
  }

  RateLimiter._internal([this._timeout = 2]);

  Future<bool> shouldFetch(String key) async {
    int lastFetched = await RepositoryCommon.getValue(key);
//    print('lastFetched $lastFetched');
    var now = DateTime.now();
//    print('now ${now.millisecondsSinceEpoch}');
    if (lastFetched == 0) {
//      print('shouldFetch yes lastFetched == null');
      await RepositoryCommon.insertMetadata(key);
      return true;
    }

    if (now.millisecondsSinceEpoch - lastFetched >
        Duration(minutes: _timeout).inMilliseconds) {
//      print('shouldFetch yes timeout');
      await RepositoryCommon.insertMetadata(key);
      return true;
    }

//    print('shouldFetch false');
    return false;
  }

  Future<int> reset(String key) async {
    return await RepositoryCommon.deleteMetadata(key);
  }
}

RateLimiter getRateLimiter = RateLimiter();
