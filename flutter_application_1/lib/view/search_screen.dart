import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  List<String> histories = [
    "Harry Potter",
    "Self Improvement",
    "Cooking",
    "Tere Liye",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F4EC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// SEARCH BAR
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back),
                  ),

                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xffECE4D2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.search),
                          hintText: "Search books, authors...",
                          hintStyle: GoogleFonts.plusJakartaSans(),
                          suffixIcon: const Icon(Icons.close),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// RIWAYAT
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Riwayat Pencarian",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        histories.clear();
                      });
                    },
                    child: Text(
                      "Hapus Semua",
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xffC84F15),
                      ),
                    ),
                  )
                ],
              ),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: histories.map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffE9DED4),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item,
                          style: GoogleFonts.plusJakartaSans(),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.history,
                          size: 16,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              /// KATEGORI
              Text(
                "Kategori Populer",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 18),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.4,
                children: [
                  categoryCard(
                    title: "Fiksi",
                    icon: Icons.menu_book,
                    backgroundIcon: Icons.menu_book,
                    bgColor: const Color(0xffF5E3D6),
                    textColor: const Color(0xffC14C12),
                  ),

                  categoryCard(
                    title: "Pelajaran",
                    icon: Icons.search,
                    backgroundIcon: Icons.visibility_outlined,
                    bgColor: const Color(0xffEBDDDD),
                    textColor: const Color(0xff650D2E),
                  ),

                  categoryCard(
                    title: "Seni/Hobi",
                    icon: Icons.favorite,
                    backgroundIcon: Icons.favorite_border,
                    bgColor: const Color(0xffF7E1E4),
                    textColor: const Color(0xffFF6B98),
                  ),

                  categoryCard(
                    title: "Sejarah",
                    icon: Icons.castle,
                    backgroundIcon: Icons.castle,
                    bgColor: const Color(0xffE9E4DB),
                    textColor: const Color(0xff33211C),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              Text(
                "Sedang Populer",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: bookCard(
                      "Laut Bercerita",
                      "Leila S. Chudori",
                      "Rp. 60.000",
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: bookCard(
                      "Cantik Itu Luka",
                      "Eka Kurniawan",
                      "Rp. 58.000",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget categoryCard({
  required String title,
  required IconData icon,
  required IconData backgroundIcon,
  required Color bgColor,
  required Color textColor,
}) {
  return Container(
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(28),
    ),
    child: Stack(
      children: [

        /// ICON BESAR BELAKANG
        Positioned(
          right: -10,
          bottom: -10,
          child: Icon(
            backgroundIcon,
            size: 110,
            color: textColor.withValues(alpha: 0.08),
          ),
        ),

        /// KONTEN DEPAN
        Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 30,
                color: textColor,
              ),

              const Spacer(),

              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
  Widget bookCard(
    String title,
    String author,
    String price,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 210,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  author,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}