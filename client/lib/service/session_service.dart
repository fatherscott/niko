import 'package:mutex/mutex.dart';

class SessionService {
  Mutex? _m;

  static final SessionService _instance = SessionService._internal();

  factory SessionService() {
    return _instance;
  }

  SessionService._internal() {
    // 클래스가 최초 생성될 때, 1회 발생
    // 초기화 코드
    _m = Mutex();
  }

  String authData = "";
  String id = "";

  void setAuthData(String id, String data) async {
    await _m!.acquire();
    // No other lock can be acquired until the lock is released
    try {
      // critical section with asynchronous code
      authData = data;
      this.id = id;
    } finally {
      _m!.release();
    }
  }

  Future<(String, String)> getAuthData() async {
    String authData = "";
    String id = "";
    await _m!.acquire();
    // No other lock can be acquired until the lock is released
    try {
      authData = this.authData;
      id = this.id;
      // critical section with asynchronous code
    } finally {
      _m!.release();
    }
    return (id, authData);
  }

  void logout() async {
    setAuthData("", "");
  }
}
