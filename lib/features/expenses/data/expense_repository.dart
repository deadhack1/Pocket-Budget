import 'package:drift/drift.dart' hide Column;
import 'package:pocket_budget/features/expenses/data/database.dart';
import 'package:uuid/uuid.dart';

final _uuid = const Uuid();

class ExpenseRepository {
  ExpenseRepository(this.db);
  final AppDatabase db;

  Future<List<Expense>> listAll() async {
    final rows = await db.select(db.expenses).get();
    return rows
        .where((e) => e.deletedAt == null)
        .map((e) => Expense(
            id: e.id,
            note: e.note,
            categoryId: e.categoryId,
            receiptUri: e.receiptUri,
            amountCents: e.amountCents,
            currency: e.currency,
            date: e.date,
            createdAt: e.createdAt,
            updatedAt: e.updatedAt,
            isDirty: e.isDirty))
        .toList();
  }

  Future<void> upsert(Expense exp) async {
    await db.into(db.expenses).insertOnConflictUpdate(ExpensesCompanion(
          id: Value(exp.id.isEmpty ? _uuid.v4() : exp.id),
          amountCents: Value(exp.amountCents),
          currency: Value(exp.currency),
          date: Value(exp.date),
          note: Value(exp.note),
          categoryId: Value(exp.categoryId),
          receiptUri: Value(exp.receiptUri),
          createdAt: Value(exp.createdAt),
          updatedAt: Value(DateTime.now()),
          isDirty: const Value(true),
          deletedAt: Value(exp.deletedAt),
        ));
  }

  Future<void> softDelete(String id) async {
    await (db.update(db.expenses)..where((t) => t.id.equals(id))).write(
      ExpensesCompanion(
        deletedAt: Value(DateTime.now()),
        isDirty: const Value(true),
      ),
    );
  }
}