import 'package:flutter/cupertino.dart';

class ReusableText extends StatelessWidget {
  const ReusableText({Key? key, required this.text, required this.style})
      : super(key: key);
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      text,
      style: style,
    );
  }
}
