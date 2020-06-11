import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

import 'package:wiredash/wiredash.dart';

const exampleLocales = [Locale('en', 'US'), Locale('de', 'DE')];

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    return FlatButton(
      onPressed: () {
        final nextIndex =
            (exampleLocales.indexOf(currentLocale) + 1) % exampleLocales.length;
        EasyLocalization.of(context).locale = exampleLocales[nextIndex];
      },
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 14, color: Colors.black),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final locale in exampleLocales) ...[
              Text(locale.languageCode.toString(),
                  style: locale == currentLocale
                      ? const TextStyle(fontWeight: FontWeight.bold)
                      : null),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("/"),
              ),
            ]
          ]..removeLast(),
        ),
      ),
    );
  }
}

class LocalizedText extends StatelessWidget {
  const LocalizedText(
    this.translationKey, {
    this.arguments,
    this.style,
    this.textAlign,
    this.fallback,
    this.softWrap,
    this.maxLines,
    this.overflow,
    this.textScaleFactor,
    this.textDirection,
  });

  final List<String> arguments;
  final TextOverflow overflow;
  final String translationKey;
  final String fallback;
  final TextStyle style;
  final TextAlign textAlign;
  final bool softWrap;
  final int maxLines;
  final double textScaleFactor;
  final ui.TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    final text = tr(translationKey, context: context, args: arguments);
    return LocalizationHelper(
      translationKey: translationKey,
      visibleText: text,
      text: Text(
        text,
        maxLines: maxLines,
        style: style,
        softWrap: softWrap,
        textAlign: textAlign,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        locale: context.locale,
        textDirection: textDirection,
      ),
    );
  }
}
