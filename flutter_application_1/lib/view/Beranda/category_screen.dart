import 'package:flutter/material.dart';
import 'filter_bottom_sheet.dart';
import '../../viewmodel/book_viewmodel.dart';
import '../../model/book_model.dart';
import '../product_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryScreen> createState() =>
      _CategoryScreenState();
}

class _CategoryScreenState
    extends State<CategoryScreen> {

  final BookViewModel viewModel =
      BookViewModel();

  late List<BookModel> books;

  @override
  void initState() {
    super.initState();

    books = viewModel.getBooksByCategory(
      widget.category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF2),

      appBar: AppBar(
        title: Text(widget.category),

        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {

              final result =
                  await showModalBottomSheet(
                context: context,
                builder: (_) =>
                    const FilterBottomSheet(),
              );

              if (result != null) {
                setState(() {
                  books =
                      viewModel.filterBooks(
                    category:
                        widget.category,
                    minRating:
                        result,
                  );
                });
              }
            },
          ),
        ],
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: books.length,

        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.58,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),

        itemBuilder: (context, index) {

          final book = books[index];

          return GestureDetector(
          onTap: () {

             Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(
                  book: book,
                ),
              ),
            );

          },

          child: Card(
          child: Column(
            children: [
              Text(book.title),
            ],
          ),
        ),
          );
        },
      ),
    );
  }
}