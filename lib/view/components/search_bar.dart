
import 'package:flutter/material.dart';
import 'package:septeo_transport/view/components/app_colors.dart';

class Search_bar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const Search_bar({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: TextField(
         onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search...',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(32.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primaryOrange),
            borderRadius: BorderRadius.circular(32.0),
          ),
          filled: true,
          fillColor: AppColors.auxiliaryOffWhite,
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.primaryOrange ,
          ),
        ),
      ),
    );
  }
}