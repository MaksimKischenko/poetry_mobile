
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nevesomiy/domain/entites/ettities.dart';
import 'package:nevesomiy/presentation/bloc/bloc.dart';
import 'package:nevesomiy/presentation/widgets/widget.dart';
import 'package:nevesomiy/utils/modal_dialogs.dart';
import 'package:nevesomiy/utils/snack_bar_dialogs.dart';

import 'widgets/widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>  with TickerProviderStateMixin{

  late GlobalKey<FormState> _formKey;
  late TextEditingController _emailTextInputController;
  late TextEditingController _passwordTextInputController;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _opacityAnimationRocket;
  late Animation<double> _opacityAnimationSpaceMap;

  @override
  void initState() {
    super.initState();
     _onInitControllersAndKeys();
     WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _onListenNetworkConnection();
      });   
  }

  @override
  void dispose() {
    _emailTextInputController.dispose();
    _passwordTextInputController.dispose();
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
              if(state is NetworkConnectionEnabled) {
                showErrorConnectionMessage(state);
              }
            }  
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSignedIn) {
                if(state.user != null) {
                  context.go('/home');
                }
              } else if(state is AuthError) {
                showErrorSignInMessage(state.error.toString());
              }
            } 
          ),                 
        ],
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpaceMapAnimation(
                  controller: _controller,
                  scaleAnimation: _scaleAnimation,
                  positionAnimation: _positionAnimation,
                  opacityAnimationRocket: _opacityAnimationRocket,
                  opacityAnimationSpaceMap: _opacityAnimationSpaceMap,
                ),                
                const SizedBox(height: 60),                      
                SignInBody(
                  formKey: _formKey,
                  emailTextInputController: _emailTextInputController,
                  passwordTextInputController: _passwordTextInputController,
                  onSignInTap: _onLogin,
                  onSignOutTap: () => context.push('/signUp'),
                  onForgetPasswordTap: () => context.push('/reset'),
                ),
              ],
            ),
          ),
        )
    ));
  }

  void showErrorConnectionMessage(NetworkConnectionEnabled state) {
    if(!state.isEnabled) {
      ModalDialogs.showMessage(
        type: DialogType.errorNetwork,
        context: context, 
      );              
    } else {
      context.canPop() ? context.pop() : null;
    }
  }

  void showErrorSignInMessage(String title) {
    SnackBarDialog.showSnackBar(
      context, 
      title, 
      true
    );             
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      context.read<AuthBloc>().add(
        AuthLogin(
          email: _emailTextInputController.text.trim(), 
          password: _passwordTextInputController.text.trim()
      ));
    }
  }  

  void _onListenNetworkConnection() {
    context.read<NetworkConnectionBloc>().add(NetworkConnectionRun());
  }

  void _onInitControllersAndKeys() {
    _formKey = GlobalKey<FormState>(); 
    _emailTextInputController = TextEditingController();
    _passwordTextInputController = TextEditingController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), 
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.5).animate(_controller);

    _positionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.0), 
      end: const Offset(-5.0, -5.0), 
    ).animate(_controller);

    _opacityAnimationRocket = Tween<double>(
      begin: 1.0, 
      end: 0.0, 
    ).animate(_controller);

     _opacityAnimationSpaceMap = Tween<double>(
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
