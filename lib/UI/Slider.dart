import 'dart:math';

import 'package:flutter/material.dart';

class Slider1 extends StatelessWidget {
  Slider1({
    Key key,
    @required this.children,
    @required this.k,
  }) : super(key: key) {
    assert(children.length == 2, 'wronge nubmer of children');
  }

  final List<Widget> children;
  final double k;

  @override
  Widget build(BuildContext context) {
    var k1 = k;
    var k2 = 1 - k;
    print(k1);
    print(k2);
    return Row(
      children: <Widget>[
        Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003)
            ..rotateY(pi / 2 * k1),
          alignment: FractionalOffset.centerRight,
          child: children[0],
        ),
        Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003)
            ..rotateY(pi / 2 * -k2),
          alignment: FractionalOffset.centerLeft,
          child: children[1],
        )
      ],
    );
  }
}