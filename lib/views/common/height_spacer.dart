import 'package:flutter/cupertino.dart';

class HeightSpacer extends StatelessWidget {
  const HeightSpacer({Key? key, required this.height}) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
