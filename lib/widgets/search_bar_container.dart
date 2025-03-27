import 'package:flutter/material.dart';
import 'package:health_care_app/widgets/text_input_form.dart';

class SearchBarContainer extends StatelessWidget {
  final TextEditingController search;
  const SearchBarContainer({super.key, required this.search});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextInputForm(
      width: size.width,
      hint: 'Search...',
      controller: search,
      iconData: Icons.search,
    );
  }
}
