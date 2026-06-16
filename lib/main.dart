import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
  url: const String.fromEnvironment('SUPABASE_URL',
      defaultValue: 'https://zvvaofnsfmhiiqdcwraa.supabase.co'),
  anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY',
      defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp2dmFvZm5zZm1oaWlxZGN3cmFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA1NTQ1OTcsImV4cCI6MjA5NjEzMDU5N30.K1YjzXb-jGRTrZJWhrwP2plM1AVdXKK473mhIcpM7kI'),
  authOptions: const FlutterAuthClientOptions(
    authFlowType: AuthFlowType.pkce,
  ),
);

  runApp(
    const ProviderScope(
      child: LinguaAIApp(),
    ),
  );
}

