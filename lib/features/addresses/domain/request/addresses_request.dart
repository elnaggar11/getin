class AddressRequest {
  String? nameAddress;
  String? buildingNumber;
  String? floor;
  String? apartment;
  String? addressDescription;
  String? addressTitle;
  double? latitude;
  double? longitude;
  String? firstName;
  String? lastName;
  String? phoneNumber;

  AddressRequest({
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

  Map<String, dynamic> toFormData() {
    return {
      "name_address": nameAddress,
      "building_number": buildingNumber,
      "floor": floor,
      "apartment": apartment,
      "address_description": addressDescription,
      "address_title": addressTitle,
      "latitude": latitude?.toString() ?? "",
      "longitude": longitude?.toString() ?? "",
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber,
      
    };
  }
}
