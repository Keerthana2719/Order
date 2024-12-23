import 'package:flutter/material.dart';

class Response extends StatelessWidget {
  final mobileBody;
  final desktopBody;

  const Response(
      {super.key, required this.mobileBody, required this.desktopBody});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobileBody;
        } else {
          return desktopBody;
        }
      },
    );
  }
}
