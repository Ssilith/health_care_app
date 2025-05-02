import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension HintTextFinder on CommonFinders {
  Finder byHintText(String hint) => byWidgetPredicate(
    (w) => w is TextField && w.decoration?.hintText == hint,
    description: 'TextField with hint "$hint"',
  );
}
