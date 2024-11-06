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
        username: fields[2] as String?,
        email: fields[3] as String?,
        createdAt: fields[4] as DateTime?,
        updatedAt: fields[5] as DateTime?,
        token: fields[6] as String?,
        roleId: fields[7] as int?,
        dinasId: fields[8] as int?,
        bidangId: fields[9] as int?,
        phone: fields[10] as String?,
    );
  }

  @override
  int get typeId => HIVE_USER_ID;

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.token)
      ..writeByte(7)
      ..write(obj.roleId)
      ..writeByte(8)
      ..write(obj.dinasId)
      ..writeByte(9)
      ..write(obj.bidangId)
      ..writeByte(10)
      ..write(obj.phone);
  }
}
