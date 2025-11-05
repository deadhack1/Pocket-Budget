import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/empty_state.dart';
import '../expenses/data/database.dart';
import '../expenses/data/expense_repository.dart';

final dbProvider = Provider<AppDatabase>((ref) => AppDatabase());
final repoProvider = Provider<ExpenseRepository>((ref) => ExpenseRepository(ref.watch(dbProvider)));
final expensesProvider = FutureProvider.autoDispose<List<Expense>>((ref) async {
  return ref.watch(repoProvider).listAll();
});

class ExpensesListPage extends ConsumerWidget {
  const ExpensesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(expensesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Pocket Budget')),
      body: async.when(
        data: (items) => items.isEmpty
            ? EmptyState(
                message: 'No expenses yet',
                action: FilledButton(
                  onPressed: () => context.go('/edit'),
                  child: const Text('Add your first expense'),
                ),
              )
            : RefreshIndicator(
                onRefresh: () => ref.refresh(expensesProvider.future),
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final e = items[i];
                    return ListTile(
                      title: Text(_money(e.amountCents, e.currency)),
                      subtitle: Text(e.note ?? ''),
                      trailing: Text(_fmtDate(e.date)),
                      onTap: () => context.go('/edit?id=${e.id}'),
                    );
                  },
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/edit'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

String _fmtDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
String _money(int cents, String cur) => '$cur ${(cents / 100).toStringAsFixed(2)}';
