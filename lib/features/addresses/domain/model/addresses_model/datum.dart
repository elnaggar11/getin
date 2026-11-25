class AddresseData {
  int? id;
  String? nameAddress;
  String? buildingNumber;
  String? floor;
  String? apartment;
  String? addressDescription;
  String? addressTitle;
  num? latitude;
  num? longitude;
  String? firstName;
  String? lastName;
  String? phoneNumber;

  AddresseData({
    this.id,
    this.nameAddress,
    this.buildingNumber,
    this.floor,
    this.apartment,
    this.addressDescription,
    this.addressTitle,
    this.latitude,
    this.longitude,
    this.firstName,
    this.lastName,
    this.phoneNumber,
  });

  factory AddresseData.fromJson(Map<String, dynamic> json) => AddresseData(
        id: json['id'] as int?,
        nameAddress: json['name_address'] as String?,
        buildingNumber: json['building_number'] as String?,
        floor: json['floor'] as String?,
        apartment: json['apartment'] as String?,
        addressDescription: json['address_description'] as String?,
        addressTitle: json['address_title'] as String?,
        latitude: num.tryParse(json['latitude'].toString()),
        longitude: num.tryParse(json['longitude'].toString()),
        firstName: json['first_name'] as String?,
        lastName: json['last_name'] as String?,
        phoneNumber: json['phone_number'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name_address': nameAddress,
        'building_number': buildingNumber,
        'floor': floor,
        'apartment': apartment,
        'address_description': addressDescription,
        'address_title': addressTitle,
        'latitude': latitude,
        'longitude': longitude,
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
      };

  AddresseData copyWith({
    int? id,
    String? nameAddress,
    String? buildingNumber,
    String? floor,
    String? apartment,
    String? addressDescription,
    String? addressTitle,
    num? latitude,
    num? longitude,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) =>
      AddresseData(
        id: id ?? this.id,
        nameAddress: nameAddress ?? this.nameAddress,
        buildingNumber: buildingNumber ?? this.buildingNumber,
        floor: floor ?? this.floor,
        apartment: apartment ?? this.apartment,
        addressDescription: addressDescription ?? this.addressDescription,
        addressTitle: addressTitle ?? this.addressTitle,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
      );
}
