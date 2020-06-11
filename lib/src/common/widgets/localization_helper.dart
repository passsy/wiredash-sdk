import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/src/common/theme/wiredash_theme.dart';
import 'package:wiredash/wiredash.dart';

class LocalizationHelper extends StatelessWidget {
  LocalizationHelper({
    Key key,
    @required this.translationKey,
    @required this.visibleText,
    @required this.text,
    @required this.locale,
  }) : super(key: key);

  final Text text;
  final String translationKey;
  final String visibleText;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final controller = Wiredash.of(context);

    return ValueListenableBuilder<bool>(
      valueListenable: controller.localizationMode,
      builder: (context, highlight, _) {
        return ValueListenableBuilder<LocalizedTextKeyValuePair>(
          valueListenable: controller.localizationOverride,
          builder: (context, override, _) {
            final overridden = override?.key == translationKey;
            return Stack(
              overflow: Overflow.visible,
              children: [
                Positioned.fill(
                  right: -4,
                  top: -4,
                  left: -4,
                  bottom: -4,
                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: BorderSide(
                          color: overridden ? Colors.red : Colors.transparent,
                          width: 2),
                    ),
                    color: highlight
                        ? const Color(0x300DBAE1)
                        : Colors.transparent,
                  ),
                ),
                Builder(builder: (context) {
                  if (overridden) {
                    return text.copyWith(override.text);
                  }
                  return text;
                }),
                if (highlight)
                  Positioned(
                    top: -10,
                    right: -12,
                    child: Container(
                      width: 24,
                      height: 24,
                      child: Material(
                        elevation: 2,
                        color: WiredashTheme.of(context).primaryColor,
                        shape: CircleBorder(),
                        child: Center(
                          child: const Icon(
                            Icons.edit,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (highlight)
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        controller.reportL10nIssue(
                          LocalizedTextKeyValuePair(
                            key: translationKey,
                            text: visibleText,
                            locale: locale,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

extension _TextExt on Text {
  Text copyWith(String text) {
    return Text(
      text,
      key: this.key,
      style: this.style,
      strutStyle: this.strutStyle,
      textAlign: this.textAlign,
      textDirection: this.textDirection,
      locale: this.locale,
      softWrap: this.softWrap,
      overflow: this.overflow,
      textScaleFactor: this.textScaleFactor,
      maxLines: this.maxLines,
      semanticsLabel: this.semanticsLabel,
      textWidthBasis: this.textWidthBasis,
      textHeightBehavior: this.textHeightBehavior,
    );
  }
}
