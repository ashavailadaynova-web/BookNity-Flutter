import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/address_viewmodel.dart';
import 'add_address_screen.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({super.key});

  @override
  State<AddressListScreen> createState() =>
      _AddressListScreenState();
}

class _AddressListScreenState
    extends State<AddressListScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      final user =
          FirebaseAuth.instance.currentUser;

      if (user != null) {
        context
            .read<AddressViewModel>()
            .loadAddresses(
              user.uid,
            );
      }
    });
  }

  Future<void> _refreshAddresses() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await context
        .read<AddressViewModel>()
        .loadAddresses(
          user.uid,
        );
  }

  @override
  Widget build(BuildContext context) {

    const primaryTextColor =
        Color(0xFF3E2723);

    const accentColor =
        Color(0xFFFF7043);

    final addresses =
        context
            .watch<AddressViewModel>()
            .addresses;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryTextColor,
            size: 20,
          ),
          onPressed: () =>
              Navigator.pop(context),
        ),

        title: Text(
          "Alamat Pengiriman",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight:
                FontWeight.bold,
            color:
                primaryTextColor,
          ),
        ),

        centerTitle: true,
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [

            Expanded(
              child:
                  addresses.isEmpty

                      ? Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [

                              Icon(
                                Icons
                                    .location_off_outlined,
                                size: 80,
                                color:
                                    Colors.grey[400],
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              Text(
                                "Belum ada alamat tersimpan",
                                style:
                                    GoogleFonts.poppins(
                                  fontSize:
                                      16,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                  color:
                                      primaryTextColor,
                                ),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              Text(
                                "Tambahkan alamat untuk mempermudah proses pengiriman buku.",
                                textAlign:
                                    TextAlign
                                        .center,
                                style:
                                    GoogleFonts.poppins(
                                  fontSize:
                                      13,
                                  color:
                                      Colors.grey[
                                          600],
                                ),
                              ),
                            ],
                          ),
                        )

                      : ListView.builder(
                          itemCount:
                              addresses.length,

                          itemBuilder:
                              (
                            context,
                            index,
                          ) {

                            final address =
                                addresses[
                                    index];

                            return Container(
                              margin:
                                  const EdgeInsets
                                      .only(
                                bottom:
                                    16,
                              ),

                              padding:
                                  const EdgeInsets
                                      .all(
                                20,
                              ),

                              decoration:
                                  BoxDecoration(
                                color:
                                    Colors.grey[
                                        50],
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  24,
                                ),
                              ),

                              child:
                                  Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  Row(
  mainAxisAlignment:
      MainAxisAlignment.spaceBetween,

  children: [

    Expanded(
      child: Text(
        address.label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    ),

    IconButton(
      icon: const Icon(
        Icons.delete_outline,
        color: Colors.red,
      ),

      onPressed: () async {

        final user =
            FirebaseAuth.instance.currentUser;

        if (user == null) return;

        final confirm =
            await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(
              "Hapus Alamat",
            ),
            content: const Text(
              "Yakin ingin menghapus alamat ini?",
            ),
            actions: [

              TextButton(
                onPressed: () =>
                    Navigator.pop(
                  context,
                  false,
                ),
                child: const Text(
                  "Batal",
                ),
              ),

              TextButton(
                onPressed: () =>
                    Navigator.pop(
                  context,
                  true,
                ),
                child: const Text(
                  "Hapus",
                ),
              ),
            ],
          ),
        );

        if (confirm != true) return;

        await context
            .read<AddressViewModel>()
            .deleteAddress(
              user.uid,
              address.id,
            );
      },
    ),
  ],
),

                                  const SizedBox(
                                    height:
                                        8,
                                  ),

                                  Text(
                                    "${address.recipient} (${address.phone})",
                                    style:
                                        GoogleFonts
                                            .poppins(),
                                  ),

                                  const SizedBox(
                                    height:
                                        4,
                                  ),

                                  Text(
                                    address
                                        .address,
                                    style:
                                        GoogleFonts
                                            .poppins(
                                      color:
                                          Colors.grey[
                                              700],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),

            SizedBox(
              width: double.infinity,
              height: 55,

              child:
                  OutlinedButton.icon(

                onPressed:
                    () async {

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              const AddAddressScreen(),
                    ),
                  );

                  await _refreshAddresses();
                },

                icon:
                    const Icon(
                  Icons.add_rounded,
                  color:
                      accentColor,
                ),

                label: Text(
                  "Tambah Alamat Baru",
                  style:
                      GoogleFonts.poppins(
                    fontWeight:
                        FontWeight.bold,
                    color:
                        accentColor,
                  ),
                ),

                style:
                    OutlinedButton.styleFrom(
                  side:
                      const BorderSide(
                    color:
                        accentColor,
                    width:
                        1.5,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}