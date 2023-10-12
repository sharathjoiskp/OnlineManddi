import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hasi_adike/pages/authPage/functions.dart';
import 'package:hasi_adike/pages/posts/models/model.dart';
import 'package:hasi_adike/utils/utils.dart';
part 'api_state.dart';

String hasiAdike = BackEndConfig().hasiAdike;
String ourWorkerPin = BackEndConfig().ourWorkerPin;
String vendorAccounts = BackEndConfig().vendorAccounts;
String vendorRequest = BackEndConfig().vendorRequest;

class ApiCubit extends Cubit<ApiState> {
  ApiCubit() : super(PostInitial());

  Future<void> createPost(PostDetailsModel data) async {
    emit(PostLoading());

    try {
      await FirebaseFirestore.instance
          .collection(hasiAdike)
          .doc(data.phoneNumber)
          .set(data.toMap());

      emit(PostAdded('Your Details Posted'));
    } catch (e) {
      emit(PostError('Error: ${e.toString()}'));
    }
  }

  Future<void> movePost(
      {required String postId,
      required String userId,
      required int moveTo}) async {
    emit(PostLoading());
    try {
      await FirebaseFirestore.instance
          .collection(hasiAdike)
          .doc(postId)
          .collection('userActions')
          .doc(userId)
          .set({
        'uid': userId,
        'category': moveTo,
      });
      emit(CommonSucees(moveTo.toString()));
    } catch (e) {
      emit(PostError('Error: ${e.toString()}'));
    }
  }

  Future<void> updatePost(PostDetailsModel updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection(hasiAdike)
          .doc(updatedData.phoneNumber)
          .update(updatedData.toMap());

      // emit(PostAdded('Your Details Updated'));
    } catch (e) {
      emit(PostError('Error: ${e.toString()}'));
    }
  }

  Future<void> fetchPost() async {
    print('fun calling');
    emit(PostLoading());

    List<PostDetailsModel> listPostInstances = [];
    final db = FirebaseFirestore.instance.collection(hasiAdike);

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await db.get();
      for (var docSnapshot in querySnapshot.docs) {
        var postInstance = PostDetailsModel.fromMap(docSnapshot.data());
        var userAction = <UserActionModel>[];

        QuerySnapshot<Map<String, dynamic>> subCollectionSnapshot =
            await db.doc(docSnapshot.id).collection('userActions').get();

        for (var docSubSnap in subCollectionSnapshot.docs) {
          var userData = docSubSnap.data();
          userAction.add(UserActionModel.fromMap(userData));

          // print('');
          // if (userData['uid'] == 'uid559' && userData['category'] == 1) {
          //   print(userData);

          //   // break;
          // }
        }

        postInstance.userActions = userAction;
        listPostInstances.add(postInstance);
      }
      for (var element in listPostInstances) {
        print('post list ');
        print(element.id);
        print('vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv');
      }

      emit(PostLoaded(listPostInstances));
    } catch (e) {
      emit(PostError('Error: $e'));
    }
  }

  sortPosts(List<PostDetailsModel> posts, PostSortType sortType) {
    final sortOrder = [
      "below 1",
      "1",
      "2",
      "3",
      "4",
      "5-7",
      "7-9",
      "10 above",
    ];
    emit(PostLoading());
    switch (sortType) {
      case PostSortType.byNumberOfAcres:
        posts.sort((a, b) {
          final indexA = sortOrder.indexOf(a.numberOfAcres);
          final indexB = sortOrder.indexOf(b.numberOfAcres);
          return indexB.compareTo(indexA);
        });
        break;
      case PostSortType.byPostedDate:
        posts.sort((a, b) => b.createdOn.compareTo(a.createdOn));
        break;
    }
    emit(PostLoaded(posts));
  }

  filterPosts(List<PostDetailsModel> posts, filterType) {
    emit(PostLoading());
    List<PostDetailsModel> filteredPosts = [];
    switch (filterType) {
      case "below 1 Acre":
        filteredPosts
            .addAll(posts.where((post) => post.numberOfAcres == "below 1"));
        break;
      case "1 Acre":
        filteredPosts.addAll(posts.where((post) => post.numberOfAcres == "1"));
        break;
      case "2 Acre":
        filteredPosts.addAll(posts.where((post) => post.numberOfAcres == "2"));
        break;
      case "3 Acre":
        filteredPosts.addAll(posts.where((post) => post.numberOfAcres == "3"));
        break;
      case "4 Acre":
        filteredPosts.addAll(posts.where((post) => post.numberOfAcres == "4"));
        break;
      case "5 to 7 Acre":
        filteredPosts
            .addAll(posts.where((post) => post.numberOfAcres == "5-7"));
        break;
      case "7 to 9 Acre":
        filteredPosts
            .addAll(posts.where((post) => post.numberOfAcres == "7-9"));
        break;
      case "10 Above Acre":
        filteredPosts
            .addAll(posts.where((post) => post.numberOfAcres == "10 above"));
        break;
      case "SellType Cheni":
        filteredPosts.addAll(posts.where((post) => post.sellType == 'Cheni'));
        break;
      case "SellType Thuka":
        filteredPosts.addAll(posts.where((post) => post.sellType == 'Thuka'));
        break;
      case "SellType KG":
        filteredPosts.addAll(posts.where((post) => post.sellType == 'Kg'));
        break;
      case "SellType Only Hasi Adike":
        filteredPosts
            .addAll(posts.where((post) => post.sellType == 'Only Hasi Adike'));
        break;
      case "SellType Only Kemp Adike":
        filteredPosts
            .addAll(posts.where((post) => post.sellType == 'Only Kemp Adike'));
        break;
      case "All the above":
        filteredPosts
            .addAll(posts.where((post) => post.sellType == 'All the above'));
        break;
    }
    emit(PostLoaded(filteredPosts));
  }

  Future<void> workerPinValidation(int enteredPIN) async {
    emit(CommonLoading());

    try {
      var docSnapshot = await FirebaseFirestore.instance
          .collection(ourWorkerPin)
          .doc('loginPin')
          .get();
      if (docSnapshot.exists && docSnapshot.data()?['pin'] == enteredPIN) {
        emit(CommonSucees('ourWorker'));
      } else {
        emit(CommonError('Pin Wrong Enter Correct Password'));
      }
    } catch (e) {
      emit(CommonError(e.toString()));
    }
  }

  Future<void> vendorPinValidation(String phoneNumber) async {
    emit(CommonLoading());
    if (phoneNumber.isEmpty) {
      emit(CommonError(
          'ನಿಮ್ಮ ಖಾತೆಯನ್ನು ಇನ್ನೂ ನೋಂದಾಯಿಸಲಾಗಿಲ್ಲ. ನೋಂದಣಿ ಪ್ರಕ್ರಿಯೆಯನ್ನು ಪೂರ್ಣಗೊಳಿಸಲು ನಾವು ಶೀಘ್ರದಲ್ಲೇ ನಿಮಗೇ ಕರೆ ಮಾಡುತ್ತೆವೆ.'));
    } else {
      try {
        var docSnapshot = await FirebaseFirestore.instance
            .collection(vendorAccounts)
            .doc(phoneNumber)
            .get();
        if (docSnapshot.exists &&
            docSnapshot.data()?['phoneNumber'] == int.parse(phoneNumber)) {
          saveUserData("vendor", true, uid: docSnapshot.data()?['uid']);
          uid = docSnapshot.data()?['uid'];

          emit(CommonSucees('vendor'));
        } else {
          await FirebaseFirestore.instance
              .collection(vendorRequest)
              .doc(phoneNumber)
              .set({
            "phoneNumber": int.parse(phoneNumber),
            "dateTime": DateTime.now()
          });
          emit(CommonError(
              'ನಿಮ್ಮ ಖಾತೆಯನ್ನು ಇನ್ನೂ ನೋಂದಾಯಿಸಲಾಗಿಲ್ಲ. ನೋಂದಣಿ ಪ್ರಕ್ರಿಯೆಯನ್ನು ಪೂರ್ಣಗೊಳಿಸಲು ನಾವು ಶೀಘ್ರದಲ್ಲೇ ನಿಮಗೇ ಕರೆ ಮಾಡುತ್ತೆವೆ.'));
        }
      } catch (e) {
        emit(CommonError(e.toString()));
      }
    }
  }
}
