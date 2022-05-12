// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_me_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserMeModelAdapter extends TypeAdapter<UserMeModel> {
  @override
  final int typeId = 5;

  @override
  UserMeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserMeModel(
      id: fields[0] as int?,
      username: fields[1] as String?,
      firstName: fields[2] as String?,
      lastName: fields[3] as String?,
      ip: fields[4] as String?,
      longitude: fields[5] as String?,
      latitude: fields[6] as String?,
      ipUp: fields[7] as bool?,
      lastIpUp: fields[8] as String?,
      lastDetectionM: fields[9] as String?,
      timestampLastDetectionM: fields[10] as String?,
      picture: fields[11] as String?,
      streamingUrl: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserMeModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.lastName)
      ..writeByte(4)
      ..write(obj.ip)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.latitude)
      ..writeByte(7)
      ..write(obj.ipUp)
      ..writeByte(8)
      ..write(obj.lastIpUp)
      ..writeByte(9)
      ..write(obj.lastDetectionM)
      ..writeByte(10)
      ..write(obj.timestampLastDetectionM)
      ..writeByte(11)
      ..write(obj.picture)
      ..writeByte(12)
      ..write(obj.streamingUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserMeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
