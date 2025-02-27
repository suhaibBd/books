// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'books_favorites_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BooksFavoritesModelAdapter extends TypeAdapter<BooksFavoritesModel> {
  @override
  final int typeId = 0;

  @override
  BooksFavoritesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BooksFavoritesModel(
      desc: fields[0] as String?,
      author: fields[1] as String?,
      title: fields[2] as String?,
      id: fields[3] as String?,
      publicationDate: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BooksFavoritesModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.desc)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.publicationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BooksFavoritesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
