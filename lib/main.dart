import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gamers_arena/data/source/dio.dart';
import 'package:gamers_arena/routes/page_index.dart';
import 'package:get/get.dart';
import 'controllers/app_controller.dart';
import 'controllers/bindings/bindings.dart';
import 'routes/routes_helper.dart';
import 'themes/themes.dart';
import 'utils/app_constants.dart';
import 'utils/services/localstorage/init_hive.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'views/widgets/time_custom_message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await initHive();
  await DioFinalHelper.init();

  timeago.setLocaleMessages('ar', MyCustomMessages());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Get.put(AppController()).themeManager();
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          initialBinding: InitBindings(),
          locale:Locale('ar'),
          themeMode: Get.put(AppController()).themeManager(),
          // initialRoute: RoutesName.initial,
          getPages: RouteHelper.routes(),
          home: SplashScreen(),
        );
      },
    );
  }
}
