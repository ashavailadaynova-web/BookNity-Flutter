class AddressModel {
  final String id;
  final String label;
  final String recipient;
  final String phone;
  final String address;

  const AddressModel({
    required this.id,
    required this.label,
    required this.recipient,
    required this.phone,
    required this.address,
  });

  factory AddressModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return AddressModel(
      id: id,
      label: map['label'] ?? '',
      recipient: map['recipient'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'recipient': recipient,
      'phone': phone,
      'address': address,
    };
  }
}