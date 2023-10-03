import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nevesomiy/domain/entites/ettities.dart';
import 'package:nevesomiy/presentation/styles/color_styles.dart';

class PasswordTextField extends StatefulWidget {
  final String? initialValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool repeatPassword;
  final Function(String value)? onSaved;
  final String? Function(String?)? validator;
  final Function(String value)? onChanged;
  final Function(String value)? onFieldSubmitted;

  
  const PasswordTextField({
    super.key, 
    this.initialValue,
    this.repeatPassword = false,
    this.controller,
    this.focusNode,
    this.onSaved,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted
  });

  @override
  PasswordTextFieldState createState() => PasswordTextFieldState();
}

class PasswordTextFieldState extends State<PasswordTextField> {

  bool _passwordHidden = true;

  @override
  Widget build(BuildContext context) => TextFormField(
    autocorrect: false,  
    minLines: 1, 
    cursorColor: ColorStyles.mainColor,
    cursorWidth: 1, 
    style: Theme.of(context).textTheme.bodySmall,
    controller: widget.controller,
    focusNode: widget.focusNode,
    obscureText:_passwordHidden,
    initialValue: widget.initialValue,
    textInputAction: TextInputAction.done,
    decoration: InputDecoration(
      suffixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: GestureDetector(
          onTap: () => setState(() => _passwordHidden = !_passwordHidden),
          child: _passwordHidden ? SvgPicture.asset(
              SvgRepo.lock.location,
              width: 16,
              height: 16,
            ) :  SvgPicture.asset(
              SvgRepo.unLock.location,
              width: 16,
              height: 16,
            ),
        ),
      ),   
      suffixIconConstraints: const BoxConstraints(maxHeight: 16),     
      labelText: !widget.repeatPassword? 'Пароль' : 'Повторите пароль',
      hintText:  !widget.repeatPassword? 'Пароль' : 'Повторите пароль',
    ),
    validator: (value) => widget.validator?.call(value!),
    onSaved: (value) => widget.onSaved?.call(value!),
    onChanged: (value) => widget.onChanged?.call(value),
    onFieldSubmitted: (value) => widget.onFieldSubmitted?.call(value),
  );
}