class UserActionModel {
  final String uid;
  final int category;

  UserActionModel({
    required this.uid,
    required this.category,
  });

  factory UserActionModel.fromMap(Map<String, dynamic> map) {
    return UserActionModel(
      uid: map['uid'],
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'category': category,
    };
  }
}

class Location {
  final String taluk;
  final String hobali;
  final String village;

  Location({
    required this.taluk,
    required this.hobali,
    required this.village,
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      taluk: map['taluk'],
      hobali: map['hobali'],
      village: map['village'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taluk': taluk,
      'hobali': hobali,
      'village': village,
    };
  }
}

class PostDetailsModel {
  final String id;
  final String name;
  final String sonOf;
  final String phoneNumber;
  final String whatsappNumber;
  final Location location;
  final String numberOfAcres;
  final String sellType;
  final DateTime createdOn;
  final bool isActive;
  List<UserActionModel> userActions;

  PostDetailsModel({
    required this.id,
    required this.name,
    required this.sonOf,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.location,
    required this.numberOfAcres,
    required this.sellType,
    required this.createdOn,
    required this.isActive,
    List<UserActionModel>? userActions,
  }) : userActions = userActions ?? [];

  factory PostDetailsModel.fromMap(Map<String, dynamic> map) {
    List<UserActionModel> userActions = (map['userActions'] as List?)
            ?.map((action) => UserActionModel.fromMap(action))
            .toList() ??
        [];

    return PostDetailsModel(
      id: map['id'],
      name: map['name'],
      sonOf: map['sonOf'],
      phoneNumber: map['phoneNumber'],
      whatsappNumber: map['whatsappNumber'],
      location: Location.fromMap(map['location']),
      numberOfAcres: map['numberOfAcres'],
      sellType: map['sellType'],
      createdOn: map['createdOn'].toDate(),
      isActive: map['isActive'],
      userActions: userActions,
    );
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> userActionsMap =
        userActions!.map((action) => action.toMap()).toList();

    return {
      'id': id,
      'name': name,
      'sonOf': sonOf,
      'phoneNumber': phoneNumber,
      'whatsappNumber': whatsappNumber,
      'location': location.toMap(),
      'numberOfAcres': numberOfAcres,
      'sellType': sellType,
      'createdOn': createdOn,
      'isActive': isActive,
      'userActions': userActionsMap,
    };
  }
}
