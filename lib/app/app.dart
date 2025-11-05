import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'router.dart';
import 'theme.dart';

class PocketBudgetApp extends ConsumerWidget {
  const PocketBudgetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Pocket Budget',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(routerProvider),
      locale: const Locale('en'),
      supportedLocales: const [Locale('en')],
      localizationsDelegates: [
// Material & Widgets localization
        DefaultWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
    );
  }
}