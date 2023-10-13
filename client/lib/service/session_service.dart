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
  String nickName = "";
  String eMail = "";

  void set(String id, String nickName, String eMail, String data) async {
    await _m!.acquire();
    // No other lock can be acquired until the lock is released
    try {
      // critical section with asynchronous code
      authData = data;
      this.id = id;
      this.nickName = nickName;
      this.eMail = eMail;
    } finally {
      _m!.release();
    }
  }

  Future<(String, String, String, String)> get() async {
    String authData = "";
    String id = "";
    String nickName = "";
    String eMail = "";

    await _m!.acquire();
    // No other lock can be acquired until the lock is released
    try {
      authData = this.authData;
      id = this.id;
      nickName = this.nickName;
      eMail = this.eMail;
      // critical section with asynchronous code
    } finally {
      _m!.release();
    }
    return (id, nickName, eMail, authData);
  }

  void logout() async {
    set("", "", "", "");
  }
}
