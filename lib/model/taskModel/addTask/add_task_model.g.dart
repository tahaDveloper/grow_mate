// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FolderItemAdapter extends TypeAdapter<FolderItem> {
  @override
  final int typeId = 0;

  @override
  FolderItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FolderItem(
      id: fields[0] as String,
      title: fields[1] as String,
      filesCount: fields[2] as int, color: Color(0xff),
    )..colorValue = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, FolderItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.filesCount)
      ..writeByte(3)
      ..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
