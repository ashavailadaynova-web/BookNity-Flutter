import 'package:flutter/material.dart';

import '../model/address_model.dart';
import '../services/address_service.dart';

class AddressViewModel extends ChangeNotifier {
  final AddressService _service = AddressService();

  List<AddressModel> _addresses = [];

  List<AddressModel> get addresses => _addresses;

  Future<void> loadAddresses(String uid) async {
    _addresses = await _service.getAddresses(uid);

    notifyListeners();
  }

  Future<void> updateAddress(String uid, AddressModel address) async {
    await _service.updateAddress(uid, address);
    await loadAddresses(uid);
  }

  Future<void> addAddress(String uid, AddressModel address) async {
    await _service.addAddress(uid, address);

    await loadAddresses(uid);
  }

  Future<void> deleteAddress(String uid, String addressId) async {
    // 1. Panggil fungsi delete di service yang sudah diperbaiki tadi
    await _service.deleteAddress(uid, addressId);

    // 2. Ambil ulang data alamat terbaru dari database agar UI otomatis terupdate
    await loadAddresses(uid);
  }
}
