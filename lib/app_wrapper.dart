import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nevesomiy/app_state_manager.dart';
import 'package:nevesomiy/presentation/bloc/bloc.dart';

class AppWrapper extends StatefulWidget {
  final Widget child;

  const AppWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  late AppStateManager _appStateManager;  

  @override
    void initState() {
    super.initState();
    _appStateManager = AppStateManager();
    WidgetsBinding.instance.addObserver(_appStateManager);
  }  
    
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_appStateManager);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NetworkConnectionBloc>(
          create: (context) => NetworkConnectionBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthCheckState()),
        ),
        BlocProvider<PoemsBloc>(
          create: (context) => PoemsBloc(),
        ),
        BlocProvider<RemoteResourcesBloc>(
          create: (context) => RemoteResourcesBloc(),
        ),        
        BlocProvider<MenuBloc>(
          create: (context) => MenuBloc(),
        ), 
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc()..add(ThemeChange())
        ),          
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if(state is AuthSignedIn) {
            context.read<PoemsBloc>().add(const PoemsLoad(syncWithFireStore: true));
            context.read<RemoteResourcesBloc>().add(const RemoteResourcesLoad(syncWithFireStore: true));
          } 
        },
        child: widget.child,
      )
    );
  }

}
