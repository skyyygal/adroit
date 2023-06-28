import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tocha_app/app/modules/Chats/views/chats_view.dart';
import 'package:tocha_app/app/modules/Dashboard/controllers/dashboard_controller.dart';
import 'package:tocha_app/app/modules/Dashboard/views/dashboard_view.dart';
import 'package:tocha_app/app/modules/Todos/views/todos_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DashboardController _authController = DashboardController();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        primaryTextTheme: GoogleFonts.latoTextTheme(),
        fontFamily: GoogleFonts.lato().fontFamily,
        applyElevationOverlayColor: true,
      ),
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaleFactor: 1,
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      initialRoute: '/dashboard',
      getPages: [
        GetPage(
          name: '/dashboard',
          page: () => const DashboardView(),
          transition: Transition.cupertino,
        ),
        GetPage(
          name: '/home',
          page: () => TodosView(),
          transition: Transition.cupertino,
          binding: BindingsBuilder(() {
            Get.delete<DashboardController>();
            Get.put<DashboardController>(_authController);
          }),
        ),
        GetPage(
          name: '/chat',
          page: () => ChatsView(),
          transition: Transition.cupertino,
        ),
      ],
      initialBinding: BindingsBuilder(() {
        Get.put<DashboardController>(_authController);
        // Get.put<TodosController>(TodoController());
      }),
    );
  }
}
