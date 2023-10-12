import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hasi_adike/cubit/api_cubit.dart';

import 'package:hasi_adike/pages/posts/models/model.dart';

class FollowUpPostPage extends StatefulWidget {
  final String accType;
  const FollowUpPostPage({super.key, required this.accType});

  @override
  State<FollowUpPostPage> createState() => _FollowUpPostPageState();
}

class _FollowUpPostPageState extends State<FollowUpPostPage> {
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

    return
    
    Scaffold(
      body: Container(
        height: 12,width: 450,color: Colors.amber,
      ),
    );
  }
}
