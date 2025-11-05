import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/presentation/edit_expense_page.dart';
import '../features/presentation/expense_list_page.dart';

final routerProvider = Provider<GoRouter>((ref){
  return GoRouter(routes: [
    GoRoute(path: '/',
    builder: (ctx,state)=> const ExpensesListPage(),
      routes: [
        GoRoute(path: 'edit',
        builder: (ctx,state){
          final id =state.uri.queryParameters['id'];
          return EditExpensePage(expenseId:id);
        })
      ]
    )

  ]);
});
