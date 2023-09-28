import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hasi_adike/cubit/api_cubit.dart';
import 'package:hasi_adike/cubit/sort_filter_cubit.dart';
import 'package:hasi_adike/pages/posts/functions.dart';
import 'package:hasi_adike/pages/authPage/main_login_page.dart';
import 'package:hasi_adike/pages/posts/models/model.dart';
import 'package:hasi_adike/pages/posts/post_list_page.dart';
import 'package:hasi_adike/widgets/widget.dart';

class InformationCollectionPage extends StatefulWidget {
  final String accType;
  String appBarTitle;
  String nameController;
  String sonOfController;
  String phoneNumberController;
  String whatsappNumberController;
  String villageController;
  String selectedNoOfAcres;
  String selectedSellType;
  String selectedTaluk;
  String selectedHobali;
  InformationCollectionPage(
      {required this.appBarTitle,
      required this.nameController,
      required this.sonOfController,
      required this.phoneNumberController,
      required this.villageController,
      required this.whatsappNumberController,
      required this.selectedHobali,
      required this.selectedNoOfAcres,
      required this.selectedTaluk,
      required this.selectedSellType,
      super.key,
      required this.accType});

  @override
  State<InformationCollectionPage> createState() => _InformationCollectionPageState();
}

class _InformationCollectionPageState extends State<InformationCollectionPage> {
  late TextEditingController nameController;
  late TextEditingController sonOfController;
  late TextEditingController phoneNumberController;
  late TextEditingController whatsappNumberController;
  late TextEditingController villageController;
  late String selectedNoOfAcres;
  late String selectedSellType;
  late String selectedTaluk;
  late String selectedHobali;
  final _formKey = GlobalKey<FormState>();
  bool sameNumber = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.nameController);
    sonOfController = TextEditingController(text: widget.sonOfController);
    phoneNumberController =
        TextEditingController(text: widget.phoneNumberController);
    whatsappNumberController =
        TextEditingController(text: widget.whatsappNumberController);

    villageController = TextEditingController(text: widget.villageController);

    selectedNoOfAcres = widget.selectedNoOfAcres;
    selectedSellType = widget.selectedSellType;
    selectedTaluk = widget.selectedTaluk;
    selectedHobali = widget.selectedHobali;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? bodylarge = Theme.of(context).textTheme.bodyLarge;
    final postCubit = context.read<ApiCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appBarTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                    title: 'Want To LogOut 👋🏻👋🏻',
                    titleStyle: Theme.of(context).textTheme.headlineMedium,
                    content: const Text(''),
                    actions: [
                      OutlinedButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('No')),
                      OutlinedButton(
                          onPressed: () async {
                            await saveUserData("", false);
                            Get.offAll(MainLoginPage());
                          },
                          child: const Text('yes'))
                    ]);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: BlocConsumer<ApiCubit, ApiState>(
        listener: (context, state) {
          if (state is PostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is PostAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Information',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 10),
                            InformationField(
                              keyboardType: TextInputType.name,
                              label: 'Name',
                              placeholder: 'Enter your name',
                              controller: nameController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            InformationField(
                              keyboardType: TextInputType.name,
                              label: 'Son of',
                              placeholder: 'Enter your father\'s name',
                              controller: sonOfController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter father\'s name';
                                }
                                return null;
                              },
                            ),
                            InformationField(
                              keyboardType: TextInputType.number,
                              label: 'Phone Number',
                              placeholder: 'Enter your phone number',
                              controller: phoneNumberController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter phone number';
                                }
                                return null;
                              },
                            ),
                            CheckboxListTile(
                              value: sameNumber,
                              onChanged: (value) {
                                setState(() {
                                  sameNumber = value!;
                                  if (sameNumber) {
                                    whatsappNumberController.text =
                                        phoneNumberController.text;
                                  }
                                });
                              },
                              title: Text('Same Number', style: bodylarge),
                            ),
                            InformationField(
                              keyboardType: TextInputType.number,
                              label: 'WhatsApp Number',
                              placeholder: 'Enter your WhatsApp number',
                              controller: whatsappNumberController,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Land Information',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Select Number of Acres',
                                    style: bodylarge),
                                DropdownButton<String>(
                                  value: selectedNoOfAcres,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedNoOfAcres = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    "below 1",
                                    "1",
                                    "2",
                                    "3",
                                    "4",
                                    "5-7",
                                    "7-9",
                                    "10 above"
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Select Sell Type', style: bodylarge),
                                DropdownButton<String>(
                                  value: selectedSellType,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedSellType = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    "Cheni",
                                    "Thuka",
                                    "Kg",
                                    "Only Hasi Adike",
                                    "Only Kemp Adike",
                                    "All the above",
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Select Taluk', style: bodylarge),
                                DropdownButton<String>(
                                  value: selectedTaluk,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedTaluk = newValue!;
                                    });
                                  },
                                  items: <String>["Soraba"]
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Select Hobali', style: bodylarge),
                                DropdownButton<String>(
                                  value: selectedHobali,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedHobali = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    "Ulavi",
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            InformationField(
                              label: 'Village',
                              placeholder: 'Enter your location',
                              controller: villageController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter location';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      widget.appBarTitle == 'Information Collection'
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      PostDeatils postDetails = PostDeatils(
                                        name: nameController.text,
                                        sonOf: sonOfController.text,
                                        phoneNumber: phoneNumberController.text,
                                        whatsappNumber:
                                            whatsappNumberController.text,
                                        location: Location(
                                            taluk: selectedTaluk,
                                            hobali: selectedHobali,
                                            village:
                                                villageController.text.trim()),
                                        numberOfAcres: selectedNoOfAcres,
                                        id: 'P00${phoneNumberController.text.substring(phoneNumberController.text.length - 4)}',
                                        sellType: selectedSellType,
                                        createdOn: DateTime.now(),
                                        isActive: true,
                                      );

                                      String phoneNumber =
                                          whatsappNumberController.text.trim();
                                      String message = "🌾 Dear Farmer,\n"
                                          "Your information has been successfully edited in our app with the following details:\n"
                                          "Id: P00${phoneNumberController.text.substring(phoneNumberController.text.length - 4)}\n"
                                          "👤 Name: ${nameController.text}\n"
                                          "👨‍👦 Father's Name: ${sonOfController.text}\n"
                                          "📞 Phone Number: ${phoneNumberController.text}\n"
                                          "💬 WhatsApp Number: ${whatsappNumberController.text}\n"
                                          "🌱 Number of Acres: ${selectedNoOfAcres.toString()}\n"
                                          "💰 Sell Type: $selectedSellType\n"
                                          "🏡 Location: $selectedTaluk $selectedHobali ${villageController.text}\n\n"
                                          "Please feel free to contact us at your convenience. Thank you! 🌾🚜\n\n"
                                          "*Message from Online Manddi*\n"
                                          "----------------------------------------------\n\n"
                                          "ನಿಮ್ಮ ಮಾಹಿತಿಯನ್ನು ಈ ಕೆಳಗಿನ ವಿವರಗಳೊಂದಿಗೆ ನಮ್ಮ ಅಪ್ಲಿಕೇಶನ್‌ನಲ್ಲಿ ಯಶಸ್ವಿಯಾಗಿ ಸಂಪಾದಿಸಲಾಗಿದೆ:\n"
                                          "ಐಡಿ: P00${phoneNumberController.text.substring(phoneNumberController.text.length - 4)}\n"
                                          "👤 ಹೆಸರು: ${nameController.text}\n"
                                          "👨‍👦 ತಂದೆಯ ಹೆಸರು: ${sonOfController.text}\n"
                                          "📞 ಫೋನ್ ಸಂಖ್ಯೆ: ${phoneNumberController.text}\n"
                                          "💬 ವಾಟ್ಸಪ್ ಸಂಖ್ಯೆ: ${whatsappNumberController.text}\n"
                                          "🌱 ಎಕರೆಗಳ ಸಂಖ್ಯೆ: ${selectedNoOfAcres.toString()}\n"
                                          "💰 ಮಾರಾಟ ರೀತಿ: $selectedSellType\n"
                                          "🏡 ಸ್ಥಳ: $selectedTaluk $selectedHobali ${villageController.text}\n\n"
                                          "ದಯವಿಟ್ಟು ನಿಮ್ಮ ಅನುಕೂಲಕ್ಕೆ ತಕ್ಕಂತೆ ನಮ್ಮನ್ನು ಸಂಪರ್ಕಿಸಲು ಮುಕ್ತವಾಗಿರಿ. ಧನ್ಯವಾದಗಳು! 🌾🚜\n\n"
                                          "*ಆನ್ಲೈನ್ ಮಂಡಿಯಿಂದ ಸಂದೇಶ*\n";

                                      postCubit.createPost(postDetails);

                                      if (whatsappNumberController
                                          .text.isNotEmpty) {
                                        sendWhatsAppMessage(
                                            int.parse(phoneNumber), message);
                                      }

                                      _formKey.currentState!.reset();
                                      nameController.clear();
                                      sonOfController.clear();
                                      phoneNumberController.clear();
                                      whatsappNumberController.clear();
                                      villageController.clear();
                                      sameNumber = false;
                                    }
                                  },
                                  child: const Text('Submit'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(BlocProvider(
                                      create: (context) => SortFilterCubit(),
                                      child: PostListPage(
                                        accType: widget.accType,
                                      ),
                                    ));
                                  },
                                  child: const Text('See Post '),
                                )
                              ],
                            )
                          : Center(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      PostDeatils postDetails = PostDeatils(
                                        name: nameController.text,
                                        sonOf: sonOfController.text,
                                        phoneNumber: phoneNumberController.text,
                                        whatsappNumber:
                                            whatsappNumberController.text,
                                        location: Location(
                                            taluk: selectedTaluk,
                                            hobali: selectedHobali,
                                            village:
                                                villageController.text.trim()),
                                        numberOfAcres: selectedNoOfAcres,
                                        id: 'P00${phoneNumberController.text.substring(phoneNumberController.text.length - 4)}',
                                        sellType: selectedSellType,
                                        createdOn: DateTime.now(),
                                        isActive: true,
                                      );

                                      String phoneNumber =
                                          whatsappNumberController.text.trim();
                                      String message = "🌾 Dear Farmer,\n"
                                          "Your information has been successfully edited in our app with the following details:\n"
                                          "Id: P00${phoneNumberController.text.substring(phoneNumberController.text.length - 4)}\n"
                                          "👤 Name: ${nameController.text}\n"
                                          "👨‍👦 Father's Name: ${sonOfController.text}\n"
                                          "📞 Phone Number: ${phoneNumberController.text}\n"
                                          "💬 WhatsApp Number: ${whatsappNumberController.text}\n"
                                          "🌱 Number of Acres: ${selectedNoOfAcres.toString()}\n"
                                          "💰 Sell Type: $selectedSellType\n"
                                          "🏡 Location: $selectedTaluk $selectedHobali ${villageController.text}\n\n"
                                          "Please feel free to contact us at your convenience. Thank you! 🌾🚜\n\n"
                                          "*Message from Online Manddi*\n"
                                          "----------------------------------------------\n\n"
                                          "ನಿಮ್ಮ ಮಾಹಿತಿಯನ್ನು ಈ ಕೆಳಗಿನ ವಿವರಗಳೊಂದಿಗೆ ನಮ್ಮ ಅಪ್ಲಿಕೇಶನ್‌ನಲ್ಲಿ ಯಶಸ್ವಿಯಾಗಿ ಸಂಪಾದಿಸಲಾಗಿದೆ:\n"
                                          "ಐಡಿ: P00${phoneNumberController.text.substring(phoneNumberController.text.length - 4)}\n"
                                          "👤 ಹೆಸರು: ${nameController.text}\n"
                                          "👨‍👦 ತಂದೆಯ ಹೆಸರು: ${sonOfController.text}\n"
                                          "📞 ಫೋನ್ ಸಂಖ್ಯೆ: ${phoneNumberController.text}\n"
                                          "💬 ವಾಟ್ಸಪ್ ಸಂಖ್ಯೆ: ${whatsappNumberController.text}\n"
                                          "🌱 ಎಕರೆಗಳ ಸಂಖ್ಯೆ: ${selectedNoOfAcres.toString()}\n"
                                          "💰 ಮಾರಾಟ ರೀತಿ: $selectedSellType\n"
                                          "🏡 ಸ್ಥಳ: $selectedTaluk $selectedHobali ${villageController.text}\n\n"
                                          "ದಯವಿಟ್ಟು ನಿಮ್ಮ ಅನುಕೂಲಕ್ಕೆ ತಕ್ಕಂತೆ ನಮ್ಮನ್ನು ಸಂಪರ್ಕಿಸಲು ಮುಕ್ತವಾಗಿರಿ. ಧನ್ಯವಾದಗಳು! 🌾🚜\n\n"
                                          "*ಆನ್ಲೈನ್ ಮಂಡಿಯಿಂದ ಸಂದೇಶ*\n";

                                      await postCubit.updatePost(postDetails);
                                      Get.to(BlocProvider(
                                        create: (context) => SortFilterCubit(),
                                        child: PostListPage(
                                          accType: widget.accType,
                                        ),
                                      ));
                                      if (whatsappNumberController
                                          .text.isNotEmpty) {
                                        sendWhatsAppMessage(
                                            int.parse(phoneNumber), message);
                                      }

                                      _formKey.currentState!.reset();
                                      nameController.clear();
                                      sonOfController.clear();
                                      phoneNumberController.clear();
                                      whatsappNumberController.clear();
                                      villageController.clear();
                                      sameNumber = false;
                                    }
                                  },
                                  child: const Text('Edit Post')))
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
