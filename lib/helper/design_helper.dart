import 'package:flutter/material.dart';

class DesignHelper {
  static EdgeInsets standardInsets() {
    return const EdgeInsets.all(8);
  }

  static Text Header(String _title) {
    return Text(
      _title,
      style: TextStyle(), //TODO set textStyle
    );
  }

  static Divider dividerStd(){
    return const Divider(height: 1);
  }
}
