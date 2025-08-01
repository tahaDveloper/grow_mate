// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 4;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: fields[2] as int,
      date: fields[3] as DateTime,
      category: fields[4] as Category,
      type: fields[5] as TransactionType,
      note: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 2;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.income;
      case 1:
        return TransactionType.expense;
      default:
        return TransactionType.income;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.income:
        writer.writeByte(0);
        break;
      case TransactionType.expense:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 3;

  @override
  Category read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Category.salary;
      case 1:
        return Category.business;
      case 2:
        return Category.investment;
      case 3:
        return Category.gift;
      case 4:
        return Category.other_income;
      case 5:
        return Category.food;
      case 6:
        return Category.shopping;
      case 7:
        return Category.transport;
      case 8:
        return Category.bills;
      case 9:
        return Category.entertainment;
      case 10:
        return Category.health;
      case 11:
        return Category.education;
      case 12:
        return Category.other_expense;
      default:
        return Category.salary;
    }
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    switch (obj) {
      case Category.salary:
        writer.writeByte(0);
        break;
      case Category.business:
        writer.writeByte(1);
        break;
      case Category.investment:
        writer.writeByte(2);
        break;
      case Category.gift:
        writer.writeByte(3);
        break;
      case Category.other_income:
        writer.writeByte(4);
        break;
      case Category.food:
        writer.writeByte(5);
        break;
      case Category.shopping:
        writer.writeByte(6);
        break;
      case Category.transport:
        writer.writeByte(7);
        break;
      case Category.bills:
        writer.writeByte(8);
        break;
      case Category.entertainment:
        writer.writeByte(9);
        break;
      case Category.health:
        writer.writeByte(10);
        break;
      case Category.education:
        writer.writeByte(11);
        break;
      case Category.other_expense:
        writer.writeByte(12);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
