import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttermvc/fluttermvc.dart';

void main() {
  test('adds one to input values', () {
    Text text = Text('xxx');
    var wrapper = WrapperBuilder();
//    var target = wrapper.expanded(2).apply(text);
    var target = wrapper.paddingAll(4).gesture().expanded(2).apply(text);
    print(target);
  });
}
