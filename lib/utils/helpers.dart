//to remove white blanks in the textfield
import 'dart:ui';
import 'package:intl/intl.dart' as intl;

TextDirection detectTextDirection(String text) {
  intl.Bidi.hasAnyRtl(text);

  return intl.Bidi.detectRtlDirectionality(text)
      ? TextDirection.rtl
      : TextDirection.ltr;
}

String removeLeadingBlanks(String inputText) {
  return inputText.replaceAll(RegExp(r'^\s+'), '');
}
