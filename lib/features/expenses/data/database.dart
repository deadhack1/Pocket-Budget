import 'package:drift/drift.dart';



// Pulls in openConnection() from the correct platform file
import 'connection/connection.dart' show openConnection;
part 'database.g.dart';
class Expenses extends Table {
  TextColumn get id => text()();
  IntColumn get amountCents => integer()();
  TextColumn get currency => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get receiptUri => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDirty => boolean().withDefault(const Constant(false))();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  @override
  Set<Column<Object>>? get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get color => integer()();
  IntColumn get monthlyBudgetCents => integer().nullable()();
  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DriftDatabase(tables: [Expenses, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());
  @override
  int get schemaVersion => 1;
}
