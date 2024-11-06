import 'package:absensi_kegiatan/app/data/model/UserModel.dart';
import 'package:absensi_kegiatan/app/data/repository/HiveHelper.dart';
import 'package:hive/hive.dart';

class HiveProvider {
  saveUser(UserModel user){
    HiveHelper.putData(HiveHelper.HIVE_OBJ_USER, user);
  }

  login(UserModel user) {
    saveUser(user);
    HiveHelper.putData(HiveHelper.HIVE_IS_LOGGED_IN, true);
  }

  bool isLoggedIn(){
    return HiveHelper.getData(HiveHelper.HIVE_IS_LOGGED_IN, defaultvalue: false);
  }

  UserModel? getUserModel(){
    return HiveHelper.getData(HiveHelper.HIVE_OBJ_USER, defaultvalue: null);
  }
}
