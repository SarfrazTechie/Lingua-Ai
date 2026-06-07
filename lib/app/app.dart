import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router.dart';
import 'theme.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class LinguaAIApp extends ConsumerWidget {
  const LinguaAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'LinguaAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), Locale('ur'), Locale('ar'), Locale('fr'),
        Locale('es'), Locale('de'), Locale('zh'), Locale('ja'),
        Locale('ko'), Locale('hi'), Locale('tr'), Locale('it'),
        Locale('pt'), Locale('ru'),
      ],
      routerConfig: appRouter,
    );
  }
}
