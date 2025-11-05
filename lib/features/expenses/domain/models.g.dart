// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: json['id'] as String,
  amountCents: (json['amountCents'] as num).toInt(),
  currency: json['currency'] as String,
  date: DateTime.parse(json['date'] as String),
  note: json['note'] as String?,
  categoryId: json['categoryId'] as String?,
  receiptUri: json['receiptUri'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  isDirty: json['isDirty'] as bool? ?? false,
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  'id': instance.id,
  'amountCents': instance.amountCents,
  'currency': instance.currency,
  'date': instance.date.toIso8601String(),
  'note': instance.note,
  'categoryId': instance.categoryId,
  'receiptUri': instance.receiptUri,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'isDirty': instance.isDirty,
  'deletedAt': instance.deletedAt?.toIso8601String(),
};

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: json['id'] as String,
  name: json['name'] as String,
  color: (json['color'] as num).toInt(),
  monthlyBudgetCents: (json['monthlyBudgetCents'] as num?)?.toInt(),
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'color': instance.color,
  'monthlyBudgetCents': instance.monthlyBudgetCents,
};
