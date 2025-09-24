class AddressModel {
  final String id;
  final String name;
  final String mobile;
  final String addressLine;
  final String district;
  final String? tag;

  AddressModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.addressLine,
    required this.district,
    this.tag,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map, String id) {
    return AddressModel(
      id: id,
      name: map['name'] ?? '',
      mobile: map['mobile'] ?? '',
      addressLine: map['addressLine'] ?? '',
      district: map['district'] ?? '',
      tag: map['tag'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobile': mobile,
      'addressLine': addressLine,
      'district': district,
      'tag': tag,
    };
  }
}
