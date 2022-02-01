import 'package:flutter/material.dart';

class BlueGrayProgressIndicator extends StatelessWidget {
  const BlueGrayProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 15,
        width: 15,
        child: CircularProgressIndicator(
          color: Colors.blueGrey,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
