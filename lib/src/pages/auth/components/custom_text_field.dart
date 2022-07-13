import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final IconData icon;
  bool isPassword;
  List<TextInputFormatter>? inputFormatters;

  CustomTextField(
      {Key? key,
      required this.label,
      required this.icon,
      this.isPassword = false,
      this.inputFormatters})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hiddenPassword = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        inputFormatters: widget.inputFormatters,
        obscureText: widget.isPassword && hiddenPassword ? true : false,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      hiddenPassword = !hiddenPassword;
                    });
                  },
                  icon: Icon(
                      hiddenPassword ? Icons.visibility : Icons.visibility_off))
              : null,
          isDense: true,
          label: Text(widget.label),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
