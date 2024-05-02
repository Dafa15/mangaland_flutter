import 'package:flutter/material.dart';
import 'package:mangaland_flutter/constant/color_constant.dart';

class TextFormFieldCustom extends StatefulWidget {
  final String formName;
  final TextEditingController formController;
  final IconButton? suffixButton;
  final bool? iconToggle;

  const TextFormFieldCustom({
    super.key,
    required this.formName,
    this.suffixButton,
    required this.formController,
    this.iconToggle,
  });

  @override
  State<TextFormFieldCustom> createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  @override
  void dispose() {
    widget.formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.formController,
      obscureText: widget.iconToggle ?? false,
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorConstant.colorPrimary,
        hintText: "Insert Your ${widget.formName}",
        suffixIcon: widget.suffixButton,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${widget.formName} tidak boleh kosong';
        }
        if (value.length < 6) {
          return '${widget.formName} tidak boleh kurang dari 6';
        }
        return null;
      },
    );
  }
}
