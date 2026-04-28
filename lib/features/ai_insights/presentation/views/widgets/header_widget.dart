import 'package:flutter/material.dart';
import '../../../../../core/utils/icon_box.dart';
import '../../../../../core/utils/styles.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconBox(path: "assets/images/tip.png" ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "AI Insights",
              style: Styles.textStyle22.copyWith(fontWeight: FontWeight.bold),
            ),
            Text("Personalized recommendations", style: Styles.textStyle16),
          ],
        ),
      ],
    );
  }
}
