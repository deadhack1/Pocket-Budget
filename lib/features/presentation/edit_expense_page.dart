import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../expenses/data/database.dart';
import 'expense_list_page.dart';

// reuse repository provider

class EditExpensePage extends ConsumerStatefulWidget {
  const EditExpensePage({super.key, this.expenseId});
  final String? expenseId;

  @override
  ConsumerState<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends ConsumerState<EditExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  String _currency = 'USD';
  DateTime? _date;
  String _id = const Uuid().v4();
  bool _loading = false;
  Expense? _existingExpense;

  bool get _isEditing => widget.expenseId != null;

  @override
  void initState() {
    super.initState();
    _date = DateTime.now(); // default for new items
    if (_isEditing) {
      _id = widget.expenseId!;
      _loadExisting();
    }
  }

  Future<void> _loadExisting() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(repoProvider);
      final all = await repo.listAll();
      final e = all.where((x) => x.id == _id).cast<Expense?>().firstWhere(
            (x) => x != null,
        orElse: () => null,
      );
      if (e != null) {
        _existingExpense = e;
        _amountCtrl.text = (e.amountCents / 100).toStringAsFixed(2);
        _noteCtrl.text = e.note ?? '';
        _currency = e.currency;
        _date = e.date;
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return 'Pick a date';
    return DateFormat('yyyy-MM-dd').format(d.toLocal());
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 100),
      initialDate: _date ?? DateTime.now(),
    );
    if (picked != null && mounted) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(repoProvider);

    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter a valid amount')));
      return;
    }

    final cents = (amount * 100).round();
    final now = DateTime.now();
    final exp = Expense(
      id: _id,
      amountCents: cents,
      currency: _currency,
      date: _date ?? DateTime.now(),
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      categoryId: null,
      receiptUri: null,
      createdAt: _existingExpense?.createdAt ?? now,
      updatedAt: now,
      isDirty: true,
    );

    await repo.upsert(exp);
    if (!mounted) return;
    ref.invalidate(expensesProvider);
    context.go('/');
  }

  Future<void> _delete() async {
    final repo = ref.read(repoProvider);
    await repo.softDelete(_id);
    if (!mounted) return;
    ref.invalidate(expensesProvider);
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditing ? 'Edit Expense' : 'Add Expense';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (_isEditing)
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Delete this expense?'),
                    content:
                    const Text('This will remove it from your list.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await _delete();
                }
              },
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Amount + Currency
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amountCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        hintText: 'e.g. 12.50',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType:
                      const TextInputType.numberWithOptions(
                        signed: false,
                        decimal: true,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Amount is required';
                        }
                        final parsed = double.tryParse(v.trim());
                        if (parsed == null || parsed <= 0) {
                          return 'Enter a valid positive number';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _save(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: _currency,
                    onChanged: (v) => setState(() => _currency = v!),
                    items: const [
                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                      DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                      DropdownMenuItem(value: 'INR', child: Text('INR')),
                      DropdownMenuItem(value: 'GBP', child: Text('GBP')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Note
              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  hintText: 'Optional description',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 12),

              // Date
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${_fmtDate(_date)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: const Text('Change'),
                    onPressed: _pickDate,
                  ),
                ],
              ),
              const Spacer(),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/'),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save'),
                      onPressed: _save,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
