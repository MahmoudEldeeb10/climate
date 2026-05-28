import 'package:flutter/material.dart';
import '../../../../../core/utils/icon_box.dart';
import '../../../../../core/utils/styles.dart';

class HeaderWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle;

  const HeaderWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconBox(path: imagePath),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Styles.textStyle22.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(subTitle, style: Styles.textStyle14),
          ],
        ),
      ],
    );
  }
}
