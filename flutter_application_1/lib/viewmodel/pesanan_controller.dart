import 'package:flutter/material.dart';

class PesananController {
  // DATA MASTER PESANAN (Dipindahkan dari Screen UI)
  final List<Map<String, dynamic>> ongoingOrders = [
    {
      'title': 'Animal Farm',
      'author': 'oleh George Orwell',
      'price': 'Rp 47.000',
      'status': 'Sedang Diproses',
      'statusColor': const Color(0xFFC76E2E),
      'image': 'assets/animal_farm.png',
    },
    {
      'title': 'The Midnight Library',
      'author': 'oleh Matt Haig',
      'price': 'Rp 76.000',
      'status': 'Sedang Dikirim',
      'statusColor': const Color(0xFFC76E2E),
      'image': 'assets/midnight_library.png',
    },
  ];

  final List<Map<String, dynamic>> completedOrders = [
    {
      'title': 'Laut Bercerita',
      'author': 'oleh Leila S. Chudori',
      'price': 'Rp 58.000',
      'date': '25 Sep 2025',
      'image': 'assets/laut_bercerita.png',
    },
  ];

  final List<Map<String, dynamic>> cancelledOrders = [
    {
      'title': 'Hukum Perdata Internasional',
      'author': 'oleh Dr. Ronald Saija',
      'price': 'Rp 58.000',
      'date': '15 Jan 2025',
      'image': 'assets/hukum_perdata.png',
    },
  ];

  void kirimUlasanKeDatabase({
    required String judulBuku,
    required int rating,
    required String deskripsi,
    bool denganFoto = false,
  }) {
    // Tempat menaruh kode integrasi API / Database Firebase
    print('Ulasan dikirim untuk: $judulBuku');
    print('Rating: $rating Bintang, Deskripsi: $deskripsi, Foto: $denganFoto');
  }
}