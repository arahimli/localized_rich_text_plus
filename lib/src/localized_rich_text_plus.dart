library localized_rich_text_plus;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// LocalizedRichText
class LocalizedRichText extends StatelessWidget {
  LocalizedRichText(
    this.defaultText, {
    Key? key,
    this.richTexts = const [],
    this.caseSensitive = true,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.textAlign = TextAlign.start,
  }) : super(key: key) {
    separateText();
  }
  /// The text will be localized.
  final Text defaultText;

  /// The texts will be localized.
  final List<LocalRichText> richTexts;
  final List<TextSpan> _resultRichTexts = [];

  /// How visual overflow should be handled.
  final TextOverflow overflow;
  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int? maxLines;

  final bool caseSensitive; //Whether to ignore case
  /// How the text should be aligned horizontally.
  final TextAlign textAlign;
  /// The directionality of the text.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.

  //Split string
  separateText() {
    List<_RichTextModel> result = [];
    String defaultStr = defaultText.data ?? "";
    //Find the position of the substring
    for (var richText in richTexts) {
      RegExp regex =
          RegExp(richText.originalText, caseSensitive: caseSensitive);
      Iterable<RegExpMatch> matches = regex.allMatches(defaultStr);
      for (var match in matches) {
        int start = match.start;
        int end = match.end;
        if (end > start) {
          result
              .add(_RichTextModel(start: start, end: end, richText: richText));
        }
      }
    }
    if (result.isEmpty) {
      _resultRichTexts
          .add(TextSpan(text: defaultText.data, style: defaultText.style));
      return;
    }
    //Sort by start
    result.sort((a, b) => a.start - b.start);

    int start = 0;
    int i = 0;

    // Add the corresponding TextSpan
    while (i < result.length) {
      _RichTextModel model = result[i];
      if (model.start > start) {
        String defaultSubStr = defaultStr.substring(start, model.start);
        _resultRichTexts
            .add(TextSpan(text: defaultSubStr, style: defaultText.style));
      }

      _resultRichTexts.add(TextSpan(
        text: model.richText.localizedText,
        style: model.richText.style,
        recognizer: model.richText.onTap != null
            ? (TapGestureRecognizer()..onTap = model.richText.onTap)
            : null,
      ));
      start = model.end;
      i++;
      if (i == result.length && start < defaultStr.length) {
        String defaultSubStr = defaultStr.substring(start, defaultStr.length);
        _resultRichTexts
            .add(TextSpan(text: defaultSubStr, style: defaultText.style));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      text: TextSpan(
          children: _resultRichTexts,
          style: const TextStyle(color: Colors.black)),
    );
  }
}

// LocalRichText
class LocalRichText extends StatelessWidget {
  final String originalText;
  final String localizedText;
  final TextStyle? style;
  final Function()? onTap;
  const LocalRichText({
    Key? key,
    required this.originalText,
    required this.localizedText,
    this.style,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        localizedText,
        style: style,
      ),
    );
  }
}

// RichTextModel
class _RichTextModel {
  final int start;
  final int end;
  final LocalRichText richText;
  _RichTextModel({
    required this.start,
    required this.end,
    required this.richText,
  });
}
