import 'package:flutter/material.dart';
import 'package:to_do/ui/size_config.dart';
import 'package:to_do/ui/theme.dart';
import 'package:get/get.dart';

class InputField extends StatelessWidget {
  const InputField({Key? key, required this.title, required this.hint, this.controller, this.icon}) : super(key: key);
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: 52,
      child:  Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        margin: const EdgeInsets.fromLTRB(10, 10 , 10, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Colors.grey
            )
        ),
        child: TextFormField(
            autofocus: false,
            controller: controller,
            decoration: InputDecoration(
                floatingLabelBehavior:FloatingLabelBehavior.always,
                suffixIcon: icon,
                hintText: hint,
                label: Text(title, style: Themes().subTitleStyle),
                labelStyle: const TextStyle(
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: context.theme.backgroundColor,
                      width: 0
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: context.theme.backgroundColor,
                        width: 0
                    )
                )
            )
        ),
      )
    );
  }
}

