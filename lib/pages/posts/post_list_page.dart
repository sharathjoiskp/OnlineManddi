import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hasi_adike/cubit/api_cubit.dart';
import 'package:hasi_adike/cubit/sort_filter_cubit.dart';
import 'package:hasi_adike/pages/posts/information_collection_page.dart';
import 'package:hasi_adike/pages/posts/functions.dart';
import 'package:hasi_adike/pages/authPage/main_login_page.dart';
import 'package:hasi_adike/pages/posts/models/model.dart';
import 'package:hasi_adike/utils/utils.dart';
import 'package:hasi_adike/widgets/widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PostListPage extends StatefulWidget {
  final String accType;
  const PostListPage({super.key, required this.accType});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  List<PostDeatils> oldPostList = [];
  bool isListAssigned = false;
  @override
  void initState() {
    super.initState();
    final postCubit = context.read<ApiCubit>();
    postCubit.fetchPost();
    postCubit.stream.listen((state) {
      if (state is PostLoaded && !isListAssigned) {
        oldPostList = state.postList;
        isListAssigned = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? titleLarge = Theme.of(context).textTheme.titleLarge;
    String selectedFilter = '';
    String selectedSort = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('List Of Post'),
        leading: widget.accType != 'vendor'
            ? IconButton(
                onPressed: () {
                  Get.offAll(
                    InformationCollectionPage(
                        accType: widget.accType,
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
                },
                icon: const Icon(Icons.arrow_back_outlined))
            : null,
        actions: [
          widget.accType == 'vendor'
              ? IconButton(
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
              : Container()
        ],
      ),
      body: BlocBuilder<ApiCubit, ApiState>(
        builder: (context, state) {
          final postCubit = context.read<ApiCubit>();

          if (state is PostLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PostLoaded) {
            return Column(
              children: [
                BlocBuilder<SortFilterCubit, SortFilterState>(
                  builder: (context, sortFilterState) {
                    final sortFilterCubit = context.read<SortFilterCubit>();
                    if (sortFilterState is SelectedFilter) {
                      selectedFilter = sortFilterState.selectedFilter;
                    } else if (sortFilterState is SelectedSort) {
                      if (sortFilterState.selectedSort ==
                          PostSortType.byNumberOfAcres) {
                        selectedSort = 'Sort by No Acres';
                      }
                      selectedSort = 'Sort by Posted Date';
                    }
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.filter_alt),
                                itemBuilder: (BuildContext context) {
                                  return <PopupMenuEntry<String>>[
                                    for (String option in [
                                      "below 1 Acre",
                                      "1 Acre",
                                      "2 Acre",
                                      "3 Acre",
                                      "4 Acre",
                                      "5 to 7 Acre",
                                      "7 to 9 Acre",
                                      "10 Above Acre",
                                      "SellType Cheni",
                                      "SellType Thuka",
                                      "SellType KG",
                                      "SellType Only Hasi Adike",
                                      "SellType Only Kemp Adike",
                                      "All the above"
                                    ])
                                      PopupMenuItem<String>(
                                        value: option,
                                        child: Text(option),
                                      ),
                                  ];
                                },
                                onSelected: (String value) {
                                  sortFilterCubit.selectedFilter(value);

                                  postCubit.filterPosts(oldPostList, value);
                                },
                              ),
                              selectedFilter.isEmpty
                                  ? SizedBox()
                                  : OutlinedButton.icon(
                                      onPressed: () {
                                        postCubit.fetchPost();
                                        sortFilterCubit.selectedFilter('');
                                      },
                                      icon: const Icon(Icons.close),
                                      label: Text(selectedFilter)),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                selectedSort,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              PopupMenuButton(
                                icon: const Icon(Icons.sort),
                                itemBuilder: (BuildContext context) {
                                  return [
                                    const PopupMenuItem(
                                      value: PostSortType.byPostedDate,
                                      child: Text('Posted Date'),
                                    ),
                                    const PopupMenuItem(
                                      value: PostSortType.byNumberOfAcres,
                                      child: Text('No Of Acres'),
                                    ),
                                  ];
                                },
                                onSelected: (value) {
                                  sortFilterCubit.selectedSort(value);
                                  postCubit.sortPosts(state.postList, value);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: state.postList.length == 0
                      ? Center(
                          child: Icon(
                            Icons.error_outline,
                            size: 50,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        )
                      : ListView.builder(
                          itemCount: state.postList.length,
                          itemBuilder: (context, index) {
                            final post = state.postList[index];

                            return Slidable(
                              startActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: ((context) {
                                      launchPhone(post.phoneNumber);
                                    }),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .tertiaryContainer,
                                    icon: Icons.call,
                                  ),
                                ],
                              ),
                              endActionPane: widget.accType != 'vendor'
                                  ? ActionPane(
                                      motion: const StretchMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: ((context) => Get.to(
                                                InformationCollectionPage(
                                                    accType: widget.accType,
                                                    appBarTitle:
                                                        'Edit Information',
                                                    nameController: post.name,
                                                    sonOfController: post.sonOf,
                                                    phoneNumberController:
                                                        post.phoneNumber,
                                                    villageController:
                                                        post.location.village,
                                                    whatsappNumberController:
                                                        post.whatsappNumber,
                                                    selectedHobali:
                                                        post.location.hobali,
                                                    selectedNoOfAcres:
                                                        post.numberOfAcres,
                                                    selectedTaluk:
                                                        post.location.taluk,
                                                    selectedSellType:
                                                        post.sellType),
                                              )),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .tertiaryContainer,
                                          icon: Icons.edit,
                                        ),
                                      ],
                                    )
                                  : null,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      padding: const EdgeInsets.all(16),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                          )),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            post.id,
                                            style: titleLarge!.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                          ),
                                          Text(
                                            DateFormat('dd-MM-yy').format(
                                                post.createdOn.toLocal()),
                                            style: titleLarge.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16, bottom: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text('Personal Details',
                                              style: titleLarge),
                                          const SizedBox(height: 8),
                                          InfoRow(
                                            icon: Icons.person,
                                            text: 'Name: ${post.name}',
                                            iconColor: Theme.of(context)
                                                .colorScheme
                                                .onTertiaryContainer,
                                          ),
                                          InfoRow(
                                            icon: Icons.people,
                                            text: 'Son of: ${post.sonOf}',
                                            iconColor: Theme.of(context)
                                                .colorScheme
                                                .onTertiaryContainer,
                                          ),
                                          InfoRow(
                                            icon: Icons.phone,
                                            text:
                                                'Phone Number: ${post.phoneNumber}',
                                            iconColor: Theme.of(context)
                                                .colorScheme
                                                .onTertiaryContainer,
                                          ),
                                          InfoRow(
                                            icon: Icons.message,
                                            text:
                                                'WhatsApp Number: ${post.whatsappNumber}',
                                            iconColor: Theme.of(context)
                                                .colorScheme
                                                .onTertiaryContainer,
                                          ),
                                          const SizedBox(height: 16),
                                          Text('Land Information',
                                              style: titleLarge),
                                          const SizedBox(height: 8),
                                          InfoRow(
                                            icon: Icons.landscape,
                                            text:
                                                'Number of Acres: ${post.numberOfAcres}',
                                            iconColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          InfoRow(
                                            icon: Icons.shopping_cart,
                                            text: 'Sell Type: ${post.sellType}',
                                            iconColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          InfoRow(
                                              icon: Icons.location_on,
                                              text:
                                                  'Location: ${post.location.taluk} '
                                                  ' ${post.location.hobali}  '
                                                  ' ${post.location.village}',
                                              iconColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                ),
              ],
            );
          } else if (state is PostError) {
            return Center(
                child: Text(
              state.error,
              style: Theme.of(context).textTheme.headlineLarge,
            ));
          }
          return Text('data');
        },
      ),
    );
  }
}
