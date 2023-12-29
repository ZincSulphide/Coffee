import 'package:coffee/common/widgets/bottom_bar.dart';
import 'package:coffee/constants/global_variables.dart';
import 'package:coffee/features/admin/screens/admin_screen.dart';
import 'package:coffee/features/auth/screens/auth_screen.dart';
import 'package:coffee/features/auth/services/auth_service.dart';
import 'package:coffee/providers/user_provider.dart';
import 'package:coffee/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/src/';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Coffee Shop',
        theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          colorScheme: const ColorScheme.light(
            primary: GlobalVariables.secondaryColor,
          ),
          appBarTheme: const AppBarTheme(
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black,
              )),
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: Provider.of<UserProvider>(context).user.token.isNotEmpty
            ? Provider.of<UserProvider>(context).user.type == 'user'
                ? const BottomBar()
                : const AdminScreen()
            : const AuthScreen());
  }
}
