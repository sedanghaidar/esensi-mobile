import 'package:absensi_kegiatan/app/data/model/InstansiModel.dart';
import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';

import 'CTextField.dart';

class CAutoCompleteInstansi extends StatelessWidget {
  TextEditingController controller;
  final optionsBuilder;
  final itemCount;
  final widthOPtions;
  final heightOptions;
  final validator;
  final hintText;
  final isAutoValidateMode;
  final Function(String)? onSelected;

  CAutoCompleteInstansi(this.controller, this.optionsBuilder, this.itemCount,
      {this.widthOPtions,
      this.heightOptions,
      this.validator,
      this.hintText,
      this.isAutoValidateMode, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Autocomplete<InstansiModel>(
      onSelected: (data) {
        controller.text = data.name ?? "";
        controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
        if(onSelected!=null){
          onSelected!(data.name??"");
        }
      },
      optionsBuilder: optionsBuilder,
      displayStringForOption: (value) {
        return value.name ?? "";
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
                          text: data.name ?? "",
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
                  itemCount: options.length),
            ),
          ),
        );
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        this.controller = controller;
        return CTextField(
          controller: controller,
          focusNode: focusNode,
          hintText: hintText ?? "Pilih salah satu",
          onEditingComplete: onEditingComplete,
          validator: validator,
          autoValidateMode: isAutoValidateMode ?? AutovalidateMode.disabled,
        );
      },
    );
  }
}
