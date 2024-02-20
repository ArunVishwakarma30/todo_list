// Snack bar message
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

ShowSnackbar({
  required String? title,
  required String? message,
  required IconData? icon,
  Color? textColor = Colors.white,
  Color? bgColor = Colors.green,
}) {
  Get.snackbar(title!, message!,
      margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
      colorText: textColor,
      backgroundColor: bgColor,
      icon: Icon(
        icon,
        color: Colors.white,
      ));
}
