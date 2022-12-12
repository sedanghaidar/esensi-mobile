import 'dart:async';

import 'package:absensi_kegiatan/app/global_widgets/other/suffix_icon.dart';
import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';

import 'CTextField.dart';

class CAutoCompleteString extends StatelessWidget {
  TextEditingController controller;
  final optionsBuilder;
  final itemCount;
  final widthOPtions;
  final heightOptions;
  final validator;

  CAutoCompleteString(this.controller, this.optionsBuilder, this.itemCount,
      {this.widthOPtions, this.heightOptions, this.validator});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      onSelected: (data) {
        controller.text = data;
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length));
      },
      optionsBuilder: optionsBuilder,
      displayStringForOption: (value) {
        return value;
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: heightOptions ?? 200,
                  maxWidth: widthOPtions ?? 400),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    try {
                      final data = options.elementAt(index);
                      return ListTile(
                        title: SubstringHighlight(
                          text: data,
                          term: controller.text,
                          textStyleHighlight:
                              TextStyle(fontWeight: FontWeight.w700),
                        ),
                        onTap: () {
                          onSelected(data);
                        },
                      );
                    } catch (e) {
                      return SizedBox();
                    }
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: itemCount),
            ),
          ),
        );
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        this.controller = controller;
        return CTextField(
          controller: controller,
          focusNode: focusNode,
          hintText: "Pilih salah satu",
          onEditingComplete: onEditingComplete,
          validator: validator,
        );
      },
    );
  }
}
