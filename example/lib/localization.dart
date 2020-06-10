import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

const exampleLocales = [Locale('en', 'US'), Locale('de', 'DE')];

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    return FlatButton(
      onPressed: () {
        final nextIndex = (exampleLocales.indexOf(currentLocale) + 1) % exampleLocales.length;
        EasyLocalization.of(context).locale = exampleLocales[nextIndex];
      },
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 14, color: Colors.black),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final locale in exampleLocales) ...[
              Text(locale.languageCode.toString(),
                  style: locale == currentLocale ? const TextStyle(fontWeight: FontWeight.bold) : null),
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
