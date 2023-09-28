import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hasi_adike/cubit/api_cubit.dart';
import 'package:hasi_adike/cubit/sort_filter_cubit.dart';
import 'package:hasi_adike/pages/posts/information_collection_page.dart';
import 'package:hasi_adike/pages/posts/post_list_page.dart';
import 'package:hasi_adike/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Mandi'),
      ),
      body: BlocListener<ApiCubit, ApiState>(
        listener: (context, state) {
          if (state is CommonLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CommonProgressIndicator();
              },
            );
          } else {
            Get.back();
            if (state is CommonError) {
              showCustomSnackBar(
                  context, state.error, Theme.of(context).colorScheme.error);
            } else if (state is CommonSucees) {
              if (state.message == 'ourWorker') {
                saveUserData("ourWorker", true);
                showCustomSnackBar(context, "Login Sucessfull",
                    Theme.of(context).colorScheme.primary);
                Get.offAll(
                  InformationCollectionPage(
                      accType: "ourWorker",
                      appBarTitle: 'Information Collection',
                      nameController: '',
                      sonOfController: '',
                      phoneNumberController: '',
                      villageController: '',
                      whatsappNumberController: '',
                      selectedHobali: 'Ulavi',
                      selectedNoOfAcres: '1',
                      selectedTaluk: 'Soraba',
                      selectedSellType: 'Cheni'),
                );
              } else if (state.message == 'vendor') {
                saveUserData("vendor", true);
                showCustomSnackBar(context, "Login Sucessfull",
                    Theme.of(context).colorScheme.primary);
                Get.offAll(
                  BlocProvider(
                    create: (context) => SortFilterCubit(),
                    child: const PostListPage(
                      accType: "vendor",
                    ),
                  ),
                );
              }
            }
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/onlineManddi.png'),
              ElevatedButton(
                onPressed: () {
                  showCustomSnackBar(
                      context,
                      "ಇದನ್ನು ಇನ್ನೂ ಕಾರ್ಯಗತಗೊಳಿಸಲಾಗಿಲ್ಲ,ಇದು ಮುಂದಿನ ಆವೃತ್ತಿಯಲ್ಲಿ ಲಭ್ಯವಿರುತ್ತದೆ.\nಧನ್ಯವಾದಗಳು",
                      Theme.of(context).colorScheme.primary);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  padding: const EdgeInsets.all(20.0),
                  minimumSize: const Size(200, 80),
                ),
                child: const Text(
                  'ರೈತ Login',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  TextEditingController vendorNumberController =
                      TextEditingController();
                  Get.defaultDialog(
                    title: 'ಮಾರಾಟಗಾರ Login',
                    titleStyle: Theme.of(context).textTheme.headlineMedium,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'ದಯವಿಟ್ಟು ನಿಮ್ಮ ನೋಂದಾಯಿತ ಮೊಬೈಲ್ ಸಂಖ್ಯೆಯನ್ನು +91 ಇಲ್ಲದೆ ನಮೂದಿಸಿ',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        TextField(
                          controller: vendorNumberController,
                          style: const TextStyle(
                            letterSpacing: 1.5,
                          ),
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Mobile Number',
                            contentPadding: EdgeInsets.all(12.0),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                          context.read<ApiCubit>().vendorPinValidation(
                              vendorNumberController.text.trim());
                        },
                        child: const Text(
                          'Login',
                        ),
                      ),
                    ],
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  padding: const EdgeInsets.all(20.0),
                  minimumSize: const Size(200, 80),
                ),
                child: const Text(
                  'ಮಾರಾಟಗಾರ Login',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showPasswordDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.tertiaryContainer,
                  padding: const EdgeInsets.all(20.0),
                  minimumSize: const Size(200, 80),
                ),
                child: const Text(
                  'ನಮ್ಮ ಪ್ರತಿನಿಧಿ Login',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showPasswordDialog(BuildContext context) {
    List<TextEditingController> textControllers =
        List.generate(4, (_) => TextEditingController());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Enter The Worker Pin',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 4; i++)
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: textControllers[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counterText: '',
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  String enteredPIN = textControllers
                      .map((controller) => controller.text)
                      .join();
                  context
                      .read<ApiCubit>()
                      .workerPinValidation(int.parse(enteredPIN));
                },
                child: const Text('Login'),
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> saveUserData(String accType, bool isLoggedIn) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('accType', accType);
  await prefs.setBool('isLoggedIn', isLoggedIn);
}
