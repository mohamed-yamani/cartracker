// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localisation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalisationAdapter extends TypeAdapter<Localisation> {
  @override
  final int typeId = 4;

  @override
  Localisation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Localisation(
      fields[0] as String,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Localisation obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.longitude)
      ..writeByte(1)
      ..write(obj.latitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalisationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
