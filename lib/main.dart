import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyPortfolio',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.paper,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accent,
          onPrimary: AppColors.paper,
          secondary: AppColors.accentDark,
          onSecondary: AppColors.paper,
          surface: AppColors.paper,
          onSurface: AppColors.ink,
          outline: AppColors.line,
        ),
      ),
      home: MyHomePage(),
    );
  }
}