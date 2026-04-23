import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vigilight/app_theme.dart';
import 'package:vigilight/home_screen.dart';
import 'package:vigilight/login_screen.dart';
import 'package:vigilight/map_screen.dart';
import 'package:vigilight/notifications_screen.dart';
import 'package:vigilight/onboarding_screen.dart';
import 'package:vigilight/register_screen.dart';
import 'package:vigilight/report_screen.dart';
/*import 'core/theme/app_theme.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/home/home_screen.dart';
import 'features/map/map_screen.dart';
import 'features/report/report_screen.dart';
import 'features/notifications/notifications_screen.dart';*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Orientation portrait uniquement
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Barre de statut transparente
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF080D1A),
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
          '/onboarding': (_) => const OnboardingScreen(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/home': (_) => const HomeScreen(),
          '/map': (_) => const MapScreen(),
          '/report': (_) => const ReportScreen(),
          '/notifications': (_) => const NotificationsScreen(),
        };

        final builder = routes[settings.name];
        if (builder == null) return null;

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (ctx, _, __) => builder(ctx),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}