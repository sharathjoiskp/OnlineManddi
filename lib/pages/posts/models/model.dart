class PostDeatils {
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

  PostDeatils({
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
  });

  factory PostDeatils.fromMap(Map<String, dynamic> map) {
    return PostDeatils(
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
    );
  }

  Map<String, dynamic> toMap() {
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
