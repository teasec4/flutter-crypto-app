import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "😕 No coins found",
        style: TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }
}
