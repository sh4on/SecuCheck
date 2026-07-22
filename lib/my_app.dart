import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'shared/bindings/initial_binding.dart';

// root application widget — wires together screenutil, getx routing, and the dark theme
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return ScreenUtilInit(
      // base design canvas size (standard android phone viewport)
      designSize: const Size(390, 844),
      // do not apply screenutil scaling to text — per project rules
      minTextAdapt: false,
      splitScreenMode: true,
      builder: (final _, final __) {
        return GetMaterialApp(
          title: 'SecuCheck',
          debugShowCheckedModeBanner: false,
          // apply the dark security dashboard theme
          theme: AppTheme.dark,
          // dashboard is the initial route on launch
          initialRoute: AppRoutes.dashboard,
          // register all named routes with their bindings
          getPages: AppPages.pages,
          // register app-level dependencies before any route loads
          initialBinding: InitialBinding(),
          // default transitions
          defaultTransition: Transition.cupertino,
        );
      },
    );
  }
}
