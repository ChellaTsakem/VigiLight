import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vigilight/app_theme.dart';
import 'package:vigilight/home_screen.dart';
import 'package:vigilight/login_screen.dart';
import 'package:vigilight/map_screen.dart';
import 'package:vigilight/notifications_screen.dart';
import 'package:vigilight/alerts_screen.dart';
import 'package:vigilight/incidents_screen.dart';
import 'package:vigilight/onboarding_screen.dart';
import 'package:vigilight/register_screen.dart';
import 'package:vigilight/report_screen.dart';
import 'package:vigilight/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0A0A),
    ),
  );

  runApp(const VigiLightApp());
}

class VigiLightApp extends StatelessWidget {
  const VigiLightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VigiLight',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/onboarding',
      onGenerateRoute: (settings) {
        final routes = {
          '/onboarding':     (_) => const OnboardingScreen(),
          '/login':          (_) => const LoginScreen(),
          '/register':       (_) => const RegisterScreen(),
          '/home':           (_) => const HomeScreen(),
          '/map':            (_) => const MapScreen(),
          '/report':         (_) => const ReportScreen(),
          '/notifications':  (_) => const NotificationsScreen(),
          '/alerts':         (_) => const AlertsScreen(),
          '/incidents':      (_) => const IncidentsScreen(),
          '/profile':        (_) => const ProfileScreen(),
        };

        final builder = routes[settings.name];
        if (builder == null) return null;

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (ctx, _, __) => builder(ctx),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 280),
        );
      },
    );
  }
}