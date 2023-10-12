import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:hasi_adike/cubit/api_cubit.dart';
import 'package:hasi_adike/cubit/sort_filter_cubit.dart';
import 'package:hasi_adike/pages/posts/information_collection_page.dart';
import 'package:hasi_adike/pages/posts/functions.dart';
import 'package:hasi_adike/pages/posts/models/model.dart';
import 'package:hasi_adike/utils/utils.dart';
import 'package:hasi_adike/widgets/widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class InterstedPostPage extends StatefulWidget {
  final String accType;
  const InterstedPostPage({super.key, required this.accType});

  @override
  State<InterstedPostPage> createState() => _InterstedPostPageState();
}

class _InterstedPostPageState extends State<InterstedPostPage> {
  List<PostDetailsModel> oldPostList = [];
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
      body: BlocConsumer<ApiCubit, ApiState>(
        listener: (context, state) {
          if (state is PostError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is CommonSucees) {
            context.read<ApiCubit>().fetchPost();
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
                                  ? const SizedBox()
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
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: state.postList.isEmpty
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
                            for (UserActionModel element in post.userActions) {
                              if (element.uid == 'uid559' &&
                                  element.category == 3) {
                                return Text('data');
                              }
                            }

                            return Container(
                              height: 200,
                              width: 200,
                              color: Colors.amber,
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
          return const Text('data');
        },
      ),
    );
  }
}



// Slidable(
//                                   startActionPane: ActionPane(
//                                     motion: const StretchMotion(),
//                                     children: [
//                                       SlidableAction(
//                                         onPressed: ((context) {
//                                           launchPhone(post.phoneNumber);
//                                         }),
//                                         backgroundColor: Theme.of(context)
//                                             .colorScheme
//                                             .tertiaryContainer,
//                                         icon: Icons.call,
//                                       ),
//                                     ],
//                                   ),
//                                   endActionPane: widget.accType != 'vendor'
//                                       ? ActionPane(
//                                           motion: const StretchMotion(),
//                                           children: [
//                                             SlidableAction(
//                                               onPressed: ((context) => Get.to(
//                                                     InformationCollectionPage(
//                                                         accType: widget.accType,
//                                                         appBarTitle:
//                                                             'Edit Information',
//                                                         nameController:
//                                                             post.name,
//                                                         sonOfController:
//                                                             post.sonOf,
//                                                         phoneNumberController:
//                                                             post.phoneNumber,
//                                                         villageController: post
//                                                             .location.village,
//                                                         whatsappNumberController:
//                                                             post.whatsappNumber,
//                                                         selectedHobali: post
//                                                             .location.hobali,
//                                                         selectedNoOfAcres:
//                                                             post.numberOfAcres,
//                                                         selectedTaluk:
//                                                             post.location.taluk,
//                                                         selectedSellType:
//                                                             post.sellType),
//                                                   )),
//                                               backgroundColor: Theme.of(context)
//                                                   .colorScheme
//                                                   .tertiaryContainer,
//                                               icon: Icons.edit,
//                                             )
//                                           ],
//                                         )
//                                       : null,
//                                   child: Container(
//                                     margin: const EdgeInsets.symmetric(
//                                         vertical: 8, horizontal: 16),
//                                     decoration: BoxDecoration(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .secondaryContainer,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Column(
//                                       children: [
//                                         Container(
//                                           padding: const EdgeInsets.all(16),
//                                           width:
//                                               MediaQuery.of(context).size.width,
//                                           decoration: BoxDecoration(
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .secondary,
//                                               borderRadius:
//                                                   const BorderRadius.only(
//                                                 topLeft: Radius.circular(12),
//                                                 topRight: Radius.circular(12),
//                                               )),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text(
//                                                 post.id,
//                                                 style: titleLarge!.copyWith(
//                                                     color: Theme.of(context)
//                                                         .colorScheme
//                                                         .onPrimary),
//                                               ),
//                                               Container(
//                                                 padding:
//                                                     const EdgeInsets.all(10),
//                                                 decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             4),
//                                                     color: category(
//                                                         context, post)[1]),
//                                                 child: Text(
//                                                   category(context, post)[0],
//                                                   style: titleLarge.copyWith(
//                                                       color: Theme.of(context)
//                                                           .colorScheme
//                                                           .onBackground),
//                                                 ),
//                                               ),
//                                               Text(
//                                                 DateFormat('dd-MM-yy').format(
//                                                     post.createdOn.toLocal()),
//                                                 style: titleLarge.copyWith(
//                                                     color: Theme.of(context)
//                                                         .colorScheme
//                                                         .onPrimary),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 16, right: 16, bottom: 16),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               const SizedBox(
//                                                 height: 10,
//                                               ),
//                                               Text('Personal Details',
//                                                   style: titleLarge),
//                                               const SizedBox(height: 8),
//                                               InfoRow(
//                                                 icon: Icons.person,
//                                                 text: 'Name: ${post.name}',
//                                                 iconColor: Theme.of(context)
//                                                     .colorScheme
//                                                     .onTertiaryContainer,
//                                               ),
//                                               InfoRow(
//                                                 icon: Icons.people,
//                                                 text: 'Son of: ${post.sonOf}',
//                                                 iconColor: Theme.of(context)
//                                                     .colorScheme
//                                                     .onTertiaryContainer,
//                                               ),
//                                               InfoRow(
//                                                 icon: Icons.phone,
//                                                 text:
//                                                     'Phone Number: ${post.phoneNumber}',
//                                                 iconColor: Theme.of(context)
//                                                     .colorScheme
//                                                     .onTertiaryContainer,
//                                               ),
//                                               InfoRow(
//                                                 icon: Icons.message,
//                                                 text:
//                                                     'WhatsApp Number: ${post.whatsappNumber}',
//                                                 iconColor: Theme.of(context)
//                                                     .colorScheme
//                                                     .onTertiaryContainer,
//                                               ),
//                                               const SizedBox(height: 16),
//                                               Text('Land Information',
//                                                   style: titleLarge),
//                                               const SizedBox(height: 8),
//                                               InfoRow(
//                                                 icon: Icons.landscape,
//                                                 text:
//                                                     'Number of Acres: ${post.numberOfAcres}',
//                                                 iconColor: Theme.of(context)
//                                                     .colorScheme
//                                                     .primary,
//                                               ),
//                                               InfoRow(
//                                                 icon: Icons.shopping_cart,
//                                                 text:
//                                                     'Sell Type: ${post.sellType}',
//                                                 iconColor: Theme.of(context)
//                                                     .colorScheme
//                                                     .primary,
//                                               ),
//                                               InfoRow(
//                                                   icon: Icons.location_on,
//                                                   text:
//                                                       'Location: ${post.location.taluk} '
//                                                       ' ${post.location.hobali}  '
//                                                       ' ${post.location.village}',
//                                                   iconColor: Theme.of(context)
//                                                       .colorScheme
//                                                       .primary),
//                                               Align(
//                                                 alignment:
//                                                     Alignment.bottomRight,
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                       border:
//                                                           Border.all(width: 1),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               8)),
//                                                   padding:
//                                                       const EdgeInsets.all(5),
//                                                   child: PopupMenuButton(
//                                                     child: Text(
//                                                       'Move To',
//                                                       style: Theme.of(context)
//                                                           .textTheme
//                                                           .titleLarge,
//                                                     ),
//                                                     itemBuilder:
//                                                         (BuildContext context) {
//                                                       return [
//                                                         const PopupMenuItem(
//                                                           value: 0,
//                                                           child:
//                                                               Text('Intersted'),
//                                                         ),
//                                                         const PopupMenuItem(
//                                                           value: 1,
//                                                           child:
//                                                               Text('Follow Up'),
//                                                         ),
//                                                         const PopupMenuItem(
//                                                           value: 2,
//                                                           child:
//                                                               Text('Completed'),
//                                                         ),
//                                                         const PopupMenuItem(
//                                                           value: 3,
//                                                           child: Text(
//                                                               'Not Intersted'),
//                                                         ),
//                                                       ];
//                                                     },
//                                                     onSelected: (value) {
//                                                       switch (value) {
//                                                         case 0:
//                                                           postCubit.movePost(
//                                                               postId: post
//                                                                   .phoneNumber,
//                                                               userId: uid,
//                                                               moveTo: 0);
//                                                           break;
//                                                         case 1:
//                                                           postCubit.movePost(
//                                                               postId: post
//                                                                   .phoneNumber,
//                                                               userId: uid,
//                                                               moveTo: 1);
//                                                           break;
//                                                         case 2:
//                                                           postCubit.movePost(
//                                                               postId: post
//                                                                   .phoneNumber,
//                                                               userId: uid,
//                                                               moveTo: 2);
//                                                           break;
//                                                         case 3:
//                                                           postCubit.movePost(
//                                                               postId: post
//                                                                   .phoneNumber,
//                                                               userId: uid,
//                                                               moveTo: 3);
//                                                           break;
//                                                       }
//                                                     },
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );