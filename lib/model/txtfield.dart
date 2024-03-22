import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TxtField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  String? validator;
  final Icon icon;
  TxtField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return TextFormField(
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
          prefixIcon:
              Padding(padding: EdgeInsets.only(right: width / 30), child: icon),
          prefixIconConstraints: BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          hintText: hint,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validator;
        }
        return null;
      },
    );
  }
}

class TxtFieldPw extends StatefulWidget {
  final TextEditingController controller;
  TxtFieldPw({
    required this.controller,
  });

  @override
  State<TxtFieldPw> createState() => _TxtFieldPwState();
}

class _TxtFieldPwState extends State<TxtFieldPw> {
  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return TextFormField(
      obscureText: _obscure,
      controller: widget.controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.only(right: width / 30),
            child: Icon(
              Icons.lock,
              color: Colors.grey,
            ),
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: width / 50),
            child: InkWell(
                onTap: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
                child: _obscure
                    ? Icon(Icons.visibility_off, color: Colors.grey)
                    : Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      )),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          hintText: 'Password',
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'isi password!';
        }
        return null;
      },
    );
  }
}
