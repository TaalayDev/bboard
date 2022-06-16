// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FilterAdapter extends TypeAdapter<Filter> {
  @override
  final int typeId = 3;

  @override
  Filter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Filter(
      categoryId: fields[0] as int?,
      regionId: fields[1] as int?,
      sortBy: fields[2] as String?,
      hasPhoto: fields[3] as bool,
      hasVideo: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Filter obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.categoryId)
      ..writeByte(1)
      ..write(obj.regionId)
      ..writeByte(2)
      ..write(obj.sortBy)
      ..writeByte(3)
      ..write(obj.hasPhoto)
      ..writeByte(4)
      ..write(obj.hasVideo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
