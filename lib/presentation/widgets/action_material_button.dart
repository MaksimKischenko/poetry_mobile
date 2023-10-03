// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nevesomiy/presentation/bloc/bloc.dart';
import 'package:nevesomiy/presentation/styles/styles.dart';
import 'package:nevesomiy/presentation/widgets/widget.dart';

class ActionMaterialButton extends StatelessWidget {
  final Function() onTap;
  final String name;

  const ActionMaterialButton({
    Key? key,
    required this.onTap,
    required this.name,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if(state is AuthLoading) {
          return MaterialButton(
            disabledColor: ColorStyles.assetDissableColor,
            minWidth: double.maxFinite,
            onPressed: null,
            color: Theme.of(context).colorScheme.secondary,
            child: Center(
              child: LoadingIndicator(
                indicatorsSize: 22,
                color: ColorStyles.mainColor,
              ),
            )
          );                          
        } else {
          return MaterialButton(
            minWidth: double.maxFinite,
            onPressed: onTap,
            color: Theme.of(context).colorScheme.secondary,
            child: Text(
              name, 
              style: ButtonTextStyles.authButtontextStyle
            )
          );
        }
      },
    );
  }
}
