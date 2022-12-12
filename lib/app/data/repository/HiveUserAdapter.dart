import 'package:absensi_kegiatan/app/data/model/UserModel.dart';
import 'package:absensi_kegiatan/app/utils/constant.dart';
import 'package:hive/hive.dart';

/// Sebuah Kelas adapter untuk mengatur koneksi terkait Hive pada sebuah model
///
/// nb : Ketika menambahkan atau mengurangi field, jangan lupa untuk menyesuaikan field pada UserModel.kt
class HiveUserAdapter extends TypeAdapter<UserModel> {
  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
        id: fields[0] as int?,
        name: fields[1] as String?,
        username: fields[1] as String?,
        email: fields[2] as String?,
        createdAt: fields[3] as DateTime?,
        updatedAt: fields[4] as DateTime?,
        token: fields[5] as String?);
  }

  @override
  int get typeId => HIVE_USER_ID;

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..write(obj.id)
      ..write(obj.name)
      ..write(obj.username)
      ..write(obj.email)
      ..write(obj.createdAt)
      ..write(obj.updatedAt)
      ..write(obj.token);
  }
}
