import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uqu_map_app/views/styles/app_styles.dart';

class CustomTextField extends StatelessWidget {
  final String _label;
  final StateProvider _fieldProvider;
  final bool _obscureText;
  final bool _enableSuggestions;
  final bool _autocorrect;

  const CustomTextField(this._label, this._obscureText, this._enableSuggestions,
      this._autocorrect, this._fieldProvider,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer(
          builder: (context, watch, child) {
            var fieldData = watch(_fieldProvider).state;
            controller.text = fieldData;
            controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));

            return SizedBox(
              height: 50,
              child: TextField(
                controller: controller,
                obscureText: _obscureText,
                autocorrect: _autocorrect,
                enableSuggestions: _enableSuggestions,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: AppStyles.appTextFieldDecoration(_label),
                onChanged: (text) {
                  context.read(_fieldProvider).state = text;

                },
              ),
            );
          },
        ),
      ],
    );
  }
}
