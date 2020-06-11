import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/src/common/theme/wiredash_theme.dart';
import 'package:wiredash/src/common/translation/wiredash_localizations.dart';
import 'package:wiredash/src/common/widgets/simple_button.dart';
import 'package:wiredash/src/common/widgets/wiredash_icons.dart';
import 'package:wiredash/src/feedback/components/input_component.dart';
import 'package:wiredash/src/feedback/feedback_model.dart';
import 'package:wiredash/src/wiredash_controller.dart';

// ignore: use_key_in_widget_constructors
class SuggestTranslationSheet extends StatefulWidget {
  SuggestTranslationSheet({
    @required this.text,
    this.onChangeTranslation,
  });

  final LocalizedTextKeyValuePair text;
  final void Function(LocalizedTextKeyValuePair text) onChangeTranslation;

  @override
  _SuggestTranslationSheetState createState() =>
      _SuggestTranslationSheetState();
}

class _SuggestTranslationSheetState extends State<SuggestTranslationSheet>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();

  final _feedbackFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _feedbackFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: WiredashTheme.of(context).secondaryBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          left: false,
          right: false,
          minimum: const EdgeInsets.only(bottom: 16),
          child: _buildCardContent(),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedSize(
            vsync: this,
            alignment: Alignment.topCenter,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 350),
            child: Padding(
              padding: EdgeInsets.only(top: 12),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        "Key:",
                        style: WiredashTheme.of(context).inputTextStyle,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.text.key,
                          style: TextStyle(
                              color: WiredashTheme.of(context).primaryTextColor,
                              fontFeatures: [
                                const FontFeature.tabularFigures(),
                              ]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "Value:",
                        style: WiredashTheme.of(context).inputTextStyle,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.text.text,
                          style: TextStyle(
                              color: WiredashTheme.of(context).primaryTextColor,
                              fontFeatures: [
                                const FontFeature.tabularFigures(),
                              ]),
                        ),
                      ),
                    ],
                  ),
                  InputComponent(
                    type: InputComponentType.l18n,
                    formKey: _formKey,
                    focusNode: _emailFocusNode,
                    autofocus: _feedbackFocusNode.hasFocus,
                    prefill: widget.text.text,
                    onChange: (value) {
                      assert(value != null);
                      widget.onChangeTranslation
                          ?.call(widget.text.copyWith(text: value));
                    },
                  ),
                  _buildButtons(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    final state = Provider.of<FeedbackModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SimpleButton(
          text: WiredashLocalizations.of(context).feedbackCancel,
          onPressed: () {
            state.feedbackUiState = FeedbackUiState.intro;
          },
        ),
        SimpleButton(
          text: WiredashLocalizations.of(context).feedbackSave,
          icon: WiredashIcons.right,
          onPressed: _submitFeedback,
        ),
      ],
    );
  }

  void _submitFeedback() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.of(context).pop();
      Provider.of<FeedbackModel>(context, listen: false).feedbackUiState =
          FeedbackUiState.intro;
    }
  }
}
