import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/address_model.dart';

class AddressService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addAddress(
    String uid,
    AddressModel address,
  ) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .add(address.toMap());
  }

  Future<List<AddressModel>> getAddresses(
    String uid,
  ) async {

    final snapshot =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('addresses')
            .get();

    return snapshot.docs
        .map(
          (doc) =>
              AddressModel.fromMap(
            doc.data(),
            doc.id,
          ),
        )
        .toList();
  }
}