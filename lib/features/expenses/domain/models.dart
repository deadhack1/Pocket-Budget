// lib/features/expenses/domain/models.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    required String id,
    required int amountCents,
    required String currency,
    required DateTime date,
    String? note,
    String? categoryId,
    String? receiptUri,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isDirty,
    DateTime? deletedAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
}

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required int color,
    int? monthlyBudgetCents,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
}
