// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int?,
      name: fields[1] as String?,
      phone: fields[3] as String?,
      media: fields[4] as Media?,
      balance: fields[5] as double?,
      deviceToken: fields[6] as String?,
      apiToken: fields[7] as String?,
      activeCount: fields[8] as int?,
    )
      ..createdAt = fields[9] as String?
      ..updatedAt = fields[10] as String?;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.media)
      ..writeByte(5)
      ..write(obj.balance)
      ..writeByte(6)
      ..write(obj.deviceToken)
      ..writeByte(7)
      ..write(obj.apiToken)
      ..writeByte(8)
      ..write(obj.activeCount)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
