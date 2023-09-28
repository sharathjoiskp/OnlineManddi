import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hasi_adike/pages/posts/models/model.dart';
import 'package:hasi_adike/utils/utils.dart';
part 'api_state.dart';

class ApiCubit extends Cubit<ApiState> {
  ApiCubit() : super(PostInitial());

  Future<void> createPost(PostDeatils data) async {
    emit(PostLoading());

    try {
      await FirebaseFirestore.instance
          .collection('hasiAdike')
          .doc(data.phoneNumber)
          .set(data.toMap());

      emit(PostAdded('Your Details Posted'));
    } catch (e) {
      emit(PostError('Error: ${e.toString()}'));
    }
  }

  Future<void> updatePost(PostDeatils updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection('hasiAdike')
          .doc(updatedData.phoneNumber)
          .update(updatedData.toMap());

      // emit(PostAdded('Your Details Updated'));
    } catch (e) {
      emit(PostError('Error: ${e.toString()}'));
    }
  }

  Future<void> fetchPost() async {
    emit(PostLoading());
    List<PostDeatils> listPostInstance = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('hasiAdike').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in querySnapshot.docs) {
        Map<String, dynamic> data = document.data();

        if (data.containsKey('isActive') && data['isActive'] == true) {
          PostDeatils postDetails = PostDeatils.fromMap(data);
          listPostInstance.add(postDetails);
        }
      }

      emit(PostLoaded(listPostInstance));
    } catch (e) {
      emit(PostError('Error: ${e.toString()}'));
    }
  }

  sortPosts(List<PostDeatils> posts, PostSortType sortType) {
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

  filterPosts(List<PostDeatils> posts, filterType) {
    emit(PostLoading());
    List<PostDeatils> filteredPosts = [];
    print(filterType);
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
          .collection('ourWorkerPin')
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
            .collection('vendorAccounts')
            .doc(phoneNumber)
            .get();
        if (docSnapshot.exists &&
            docSnapshot.data()?['phoneNumber'] == int.parse(phoneNumber)) {
          emit(CommonSucees('vendor'));
        } else {
          await FirebaseFirestore.instance
              .collection('vendorRequest')
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
