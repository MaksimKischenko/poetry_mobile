
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nevesomiy/domain/entites/dialog_type.dart';
import 'package:nevesomiy/presentation/bloc/bloc.dart';
import 'package:nevesomiy/presentation/widgets/widget.dart';
import 'package:nevesomiy/utils/modal_dialogs.dart';

import 'widgets/widgets.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin{
  late GlobalKey<FormState> _formKey;
  late TextEditingController _emailTextInputController;
  late TextEditingController _passwordTextInputController;
  late TextEditingController _passwordRepeatTextInputController;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimationEmail;
  late Animation<double> _opacityAnimationIdCard;
  late Animation<double> _rotationAnimationEmail;   

  @override
  void initState() {
    super.initState();
   _onInitControllersAndKeys();
  }

  @override
  void dispose() {
    _emailTextInputController.dispose();
    _passwordTextInputController.dispose();
    _passwordRepeatTextInputController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const SimpleAppBar(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<NetworkConnectionBloc, NetworkConnectionState>(
            listener: (context, state) {
              if (state is NetworkConnectionEnabled) {
                showNetworkConnectionMessage(state);
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthUnVerifiedEmail) {
                if (!state.user!.emailVerified) {
                  showEmailVarifictionMessage(state.user?.email ?? '');
                } else if(state is AuthSignedIn) {
                  context.go('/home');         
                }
              } 
            },
          ),
        ],
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlyingEmailAnimation(
                  controller: _controller,
                  scaleAnimation: _scaleAnimation,
                  positionAnimation: _positionAnimation,
                  opacityAnimationEmail: _opacityAnimationEmail,
                  opacityAnimationIdCard: _opacityAnimationIdCard,
                  rotationAnimationEmail: _rotationAnimationEmail,                    
                ),
                const SizedBox(height: 60),     
                SignUpBody(
                  formKey: _formKey,
                  emailTextInputController: _emailTextInputController,
                  passwordTextInputController: _passwordTextInputController,
                  passwordRepeatTextInputController: _passwordRepeatTextInputController,
                  onTap: _onSignUp,
                ),
              ],
            ),
          ),
        )
      )
    );
  }

  void showNetworkConnectionMessage(NetworkConnectionEnabled state) {
    if (!state.isEnabled) {
      ModalDialogs.showMessage(
        context: context,
        type: DialogType.errorNetwork,
      );
    } else {
      context.canPop() ? context.pop() : null;
    }
  }

  void showEmailVarifictionMessage(String email) {
    ModalDialogs.showMessage(
      context: context,
      type: DialogType.emailVerify,
      email: email
    );
  }

  void _onSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      context.read<AuthBloc>().add(AuthSignUp(
          email: _emailTextInputController.text.trim(), password: _passwordTextInputController.text.trim()));
    }
  }

  void _onInitControllersAndKeys() {
    _formKey = GlobalKey<FormState>(); 
    _emailTextInputController = TextEditingController();
    _passwordTextInputController = TextEditingController();
    _passwordRepeatTextInputController = TextEditingController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), 
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.5).animate(_controller);

    _positionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0), 
      end: const Offset(-5.0, -5.0), 
    ).animate(_controller);

    _opacityAnimationEmail = Tween<double>(
      begin: 1.0, 
      end: 0.0, 
    ).animate(_controller);

    _rotationAnimationEmail = Tween<double>(
      begin: 0.0, 
      end: 0.5, 
    ).animate(_controller);

     _opacityAnimationIdCard = Tween<double>(
      begin: 0.5, 
      end: 1.0, 
    ).animate(_controller);
       
    _emailTextInputController.addListener(() {
      if(_emailTextInputController.text.isNotEmpty) {
        _controller.animateTo(0.1 * _emailTextInputController.text.length.toDouble());
      } else {
        _controller.reverse();
      }
    });
  }  

}
