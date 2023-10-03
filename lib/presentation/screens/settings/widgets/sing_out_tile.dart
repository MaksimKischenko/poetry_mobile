
import 'package:flutter/material.dart';


class SignOutTile extends StatelessWidget {
  final Function() onTap;

  const SignOutTile({
    Key? key,
    required this.onTap,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: Icon(
            Icons.exit_to_app, 
            color: Theme.of(context).colorScheme.primary,
            size: 48,
          ),
          title: Text(
            'Выйти', 
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
