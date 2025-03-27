import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:health_care_app/auth/login_page_template.dart';
import 'package:health_care_app/blank_scaffold.dart';
import 'package:health_care_app/firebase_options.dart';
import 'package:health_care_app/global.dart';
import 'package:health_care_app/widgets/action_container.dart';
import 'package:health_care_app/widgets/message.dart';
import 'package:health_care_app/widgets/search_bar_container.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (!kIsWeb) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health Care App',
      theme: ThemeData(
        dialogTheme: const DialogTheme(elevation: 0),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const LoginPageTemplate(),
      supportedLocales: const [Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, IconData>> filteredActions = [];

  @override
  void initState() {
    super.initState();
    filteredActions = homePageActions;
    searchController.addListener(() {
      filterActions();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterActions() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredActions = homePageActions;
      });
    } else {
      setState(() {
        filteredActions =
            homePageActions
                .where(
                  (action) => action.keys.first.toLowerCase().contains(query),
                )
                .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlankScaffold(
      showLeading: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 90,
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: SearchBarContainer(search: searchController),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: StaggeredGrid.extent(
                    maxCrossAxisExtent: 750,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children:
                        filteredActions.map((action) {
                          String title = action.keys.first;
                          return ActionContainer(
                            title: title,
                            iconData: action[title]!,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => getActionRoute(title),
                                ),
                              );
                            },
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 30,
            right: 15,
            child: IconButton(
              icon: Ink(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.logout_outlined,
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();

                  User? user = FirebaseAuth.instance.currentUser;

                  if (user == null) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPageTemplate(),
                      ),
                      (route) => false,
                    );
                  } else {
                    displayErrorMotionToast('Failed to log out.', context);
                  }
                } catch (e) {
                  displayErrorMotionToast('Failed to log out.', context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
