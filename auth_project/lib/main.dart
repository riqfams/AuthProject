import 'package:auth_project/pages/home_screen.dart';
import 'package:auth_project/pages/login_screen.dart';
import 'package:auth_project/pages/product_add_screen.dart';
import 'package:auth_project/pages/product_edit_screen.dart';
import 'package:auth_project/providers/auth_provider.dart';
import 'package:auth_project/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (context) => ProductProvider(),
          update: (context, auth, products) => products!..updateToken(auth.token ?? '', auth.userId ?? ''),
        )
      ],
      builder: (context, child) => Consumer<AuthProvider>(
          builder: (context, auth, child) => MaterialApp(
            title: 'Auth Project',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
              useMaterial3: true,
            ),
            home: auth.isAuth
                ? HomePage()
                : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return const LoginPage();
                  }
                ),
            routes: {
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              AddProductScreen.routeName: (ctx) => AddProductScreen()
            },
          ),
      )

    );
  }
}
