import 'package:flutter/material.dart';
import 'package:stackz/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.secondaryColor,
      title: title,
    );
  }

  // 👇 Required by PreferredSizeWidget so Scaffold knows how tall it is
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
