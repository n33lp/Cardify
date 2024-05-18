import 'package:flutter/material.dart';

class NavigationManager {
  static void navigateTo(BuildContext context, String targetView) {
    if (targetView == "FolderContents") {
    } else if (targetView == "Starred") {
    } else if (targetView == "Trash") {
    } else if (targetView == "Profile") {}
  }
}
