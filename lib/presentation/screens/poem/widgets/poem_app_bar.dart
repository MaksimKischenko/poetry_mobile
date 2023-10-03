import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nevesomiy/data/data.dart';
import 'package:nevesomiy/domain/entites/ettities.dart';
import 'package:nevesomiy/presentation/bloc/bloc.dart';

class PoemAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Poem poem;

  const PoemAppBar({
    Key? key, 
    required this.poem
  }) : super(key: key);

  @override
  State<PoemAppBar> createState() => _PoemAppBarState();
  

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _PoemAppBarState extends State<PoemAppBar> {

  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.poem.isFavorite ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PoemBloc, PoemState>(
      listener: (context, state) {
        setState(() {
          isFavorite = state.poem.isFavorite ?? false;
        });
      },
      child: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.poem.title, 
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              const SizedBox(width: 12),
              SvgPicture.asset(
                widget.poem.poemTopicAssetLocation,
                width: 24,
                height: 24,
              ),
            ],
          ),
          actions: [
           isFavorite? SvgPicture.asset(
                SvgRepo.medal.location,
                width: 24,
                height: 24,
            ) :  const SizedBox.shrink()
          ],
      ),
    );
  }
}
