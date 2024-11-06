import 'package:absensi_kegiatan/app/data/model/UserModel.dart';
import 'package:hive/hive.dart';

class HiveHelper{

  static const HIVE_APPNAME = "absensi_kegiatan";
  static const HIVE_OBJ_USER = "user";
  static const HIVE_IS_LOGGED_IN = "isLoggedIn";

  static final _hive = Hive.box<dynamic>(HIVE_APPNAME);

  static getData(String key, {dynamic defaultvalue}) {
    return _hive.get(key, defaultValue: defaultvalue);
  }

  static putData(String key, dynamic data) {
    return _hive.put(key, data);
  }

  static deleteData(String keyName) {
    return _hive.delete(keyName);
  }

  static bool checkKey(dynamic key) {
    bool check = _hive.containsKey(key);
    return check;
  }

}