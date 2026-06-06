import 'package:flutter/material.dart';

class FilterBottomSheet
    extends StatefulWidget {

  const FilterBottomSheet({
    super.key,
  });

  @override
  State<FilterBottomSheet>
      createState() =>
          _FilterBottomSheetState();
}

class _FilterBottomSheetState
    extends State<FilterBottomSheet> {

  double rating = 1;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding:
          const EdgeInsets.all(20),

      child: Column(
        mainAxisSize:
            MainAxisSize.min,

        children: [

          const Text(
            "Filter Rating",
            style: TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Slider(
            value: rating,
            min: 1,
            max: 5,
            divisions: 4,

            label:
                rating.toString(),

            onChanged: (value) {
              setState(() {
                rating = value;
              });
            },
          ),

          ElevatedButton(
            onPressed: () {

              Navigator.pop(
                context,
                rating,
              );

            },
            child:
                const Text("Terapkan"),
          ),
        ],
      ),
    );
  }
}