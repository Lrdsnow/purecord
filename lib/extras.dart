import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

extension SafeAccessList on List<dynamic> {
  dynamic getValueAtIndex(int index) {
    return (index >= 0 && index < length) ? this[index] : null;
  }
}

class IgnoreBlockquote extends MarkdownElementBuilder {
  @override
  bool isBlockElement() => false;

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    return null;
  }

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return null;
  }

  @override
  void visitElementBefore(md.Element element) {}
}
