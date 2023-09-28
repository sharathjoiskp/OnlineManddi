import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hasi_adike/theme/color_schemes.g.dart';
import 'package:hasi_adike/cubit/api_cubit.dart';
import 'package:hasi_adike/cubit/sort_filter_cubit.dart';
import 'package:hasi_adike/pages/posts/information_collection_page.dart';
import 'package:hasi_adike/firebase_options.dart';
import 'package:hasi_adike/pages/authPage/main_login_page.dart';
import 'package:hasi_adike/pages/posts/post_list_page.dart';
import 'package:hasi_adike/theme/text_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String accType = prefs.getString('accType') ?? '';

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    accType: accType,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String accType;
  const MyApp({super.key, required this.isLoggedIn, required this.accType});

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (context) => ApiCubit(),
      child: GetMaterialApp(
          title: 'Hasi Adike',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
            textTheme: myTextTheme,
          ),
          home: isLoggedIn
              ? accType == "ourWorker"
                  ? InformationCollectionPage(
                      accType: accType,
                      appBarTitle: 'Information Collection',
                      nameController: '',
                      sonOfController: '',
                      phoneNumberController: '',
                      villageController: '',
                      whatsappNumberController: '',
                      selectedHobali: 'Ulavi',
                      selectedNoOfAcres: '1',
                      selectedTaluk: 'Soraba',
                      selectedSellType: 'Cheni')
                  : BlocProvider(
                      create: (context) => SortFilterCubit(),
                      child: PostListPage(
                        accType: accType,
                      ),
                    )
              : MainLoginPage()),
    );
  }
}
