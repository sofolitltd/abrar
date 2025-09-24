import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String mobile;
  final String email;
  final String image;
  final Timestamp createdDate;
  final String token;
  final String? defaultAddressId;

  UserModel({
    required this.uid,
    required this.name,
    required this.mobile,
    required this.email,
    required this.image,
    required this.createdDate,
    required this.token,
    this.defaultAddressId,
  });

  static UserModel empty() => UserModel(
    uid: '',
    name: '',
    mobile: '',
    email: '',
    image: '',
    createdDate: Timestamp.now(),
    token: '',
    defaultAddressId: null,
  );

  factory UserModel.fromQuerySnapshot(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] as String,
      name: data['name'] as String,
      mobile: data['mobile'] as String,
      email: data['email'] as String,
      image: data['image'] as String,
      createdDate: data['createdDate'] as Timestamp,
      token: data['token'] as String,
      defaultAddressId: data['defaultAddressId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'mobile': mobile,
      'email': email,
      'image': image,
      'createdDate': createdDate,
      'token': token,
      'defaultAddressId': defaultAddressId,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? mobile,
    String? email,
    String? image,
    Timestamp? createdDate,
    String? token,
    String? defaultAddressId,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      image: image ?? this.image,
      createdDate: createdDate ?? this.createdDate,
      token: token ?? this.token,
      defaultAddressId: defaultAddressId ?? this.defaultAddressId,
    );
  }
}
