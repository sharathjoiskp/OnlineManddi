import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hasi_adike/pages/authPage/functions.dart';
import 'package:hasi_adike/pages/authPage/main_login_page.dart';
import 'package:hasi_adike/pages/posts/completed_post_page.dart';
import 'package:hasi_adike/pages/posts/follow_up_post_page.dart';
import 'package:hasi_adike/pages/posts/intersted_post_page.dart';
import 'package:hasi_adike/pages/posts/not_int_post_page.dart';
import 'package:hasi_adike/pages/posts/all_post_page.dart';
import 'package:hasi_adike/utils/utils.dart';

class LandingPostsPage extends StatefulWidget {
  int tabIndex;
  LandingPostsPage({required this.tabIndex, super.key});

  @override
  State<LandingPostsPage> createState() => _LandingPostsPageState();
}

class _LandingPostsPageState extends State<LandingPostsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: widget.tabIndex,
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Welcome Vendor   $uid'),
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
                                await saveUserData("", false, uid: '');
                                Get.offAll(MainLoginPage());
                              },
                              child: const Text('yes'))
                        ]);
                  },
                  icon: const Icon(Icons.logout))
            ],
            bottom: const TabBar(isScrollable: true, tabs: [
              Tab(
                child: Text('All'),
              ),
              Tab(
                child: Text('Intersted'),
              ),
              Tab(
                child: Text('Follow Up'),
              ),
              Tab(
                child: Text('Completed'),
              ),
              Tab(
                child: Text('Not In'),
              ),
            ]),
          ),
          body: const TabBarView(children: [
            AllPostPage(accType: 'vendor'),
            InterstedPostPage(accType: 'vendor'),
            FollowUpPostPage(accType: 'vendor'),
            CompletedPostPage(accType: 'vendor'),
            NotInterstedPostPage(accType: 'vendor'),
          ]),
        ));
  }
}
