import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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

class CompletedPostPage extends StatefulWidget {
  final String accType;
  const CompletedPostPage({super.key, required this.accType});

  @override
  State<CompletedPostPage> createState() => _CompletedPostPageState();
}

class _CompletedPostPageState extends State<CompletedPostPage> {
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('testHasiAdike')
              .where('userReaction.uid559', isEqualTo: 'uid559')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            print(FirebaseFirestore.instance
                .collection('testHasiAdike')
                .where('userReaction.uid559', isEqualTo: 'uid559')
                .obs);
            if (snapshot.hasData) {
              print('data there');
              return Container(
                height: 200,
                width: 200,
                color: Colors.amber,
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    print('...............$data');
                    return ListTile(
                      title: Text(data['userReaction'].toString()),
                      subtitle: Text(data['sonOf']),
                      // Add more widgets to display other data as needed
                    );
                  }).toList(),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
