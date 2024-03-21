import 'package:alchemy/app_colors.dart';
import 'package:flutter/material.dart';

// This class creates a UI element displaying a feature with a title and description within a rounded box.
class FeatureSuggestionBox extends StatelessWidget {
  // Background color of the box
  final Color backgroundColor;
  // Text for the feature header
  final String featureTitle;
  // Text for the feature description
  final String featureDescription;
  //
  final bool isDarkTheme;

  const FeatureSuggestionBox({
    super.key,
    required this.backgroundColor,
    required this.featureTitle,
    required this.featureDescription,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20).copyWith(left: 15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                featureTitle,
                style: TextStyle(
                  fontFamily: 'PoppinsRegular', // Assuming a specific font is used
                  color: isDarkTheme
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                featureDescription,
                style: TextStyle(
                  fontFamily: 'PoppinsRegular',
                  color: isDarkTheme
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
