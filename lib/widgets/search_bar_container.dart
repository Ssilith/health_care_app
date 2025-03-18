import 'package:flutter/material.dart';
import 'package:health_care_app/global.dart';

class SearchBarContainer extends StatelessWidget {
  final TextEditingController search;
  const SearchBarContainer({super.key, required this.search});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      decoration: BoxDecoration(
        boxShadow: boxShadow,
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(20.0),
      ),
      alignment: Alignment.center,
      height: 50,
      padding: const EdgeInsets.only(left: 15, right: 5),
      child: TextField(
        controller: search,
        decoration: const InputDecoration(
          suffixIcon: Icon(Icons.search),
          hintText: 'Search...',
          border: InputBorder.none,
          hintStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
