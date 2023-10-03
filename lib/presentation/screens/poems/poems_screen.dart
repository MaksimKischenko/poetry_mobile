import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nevesomiy/domain/entites/ettities.dart';
import 'package:nevesomiy/presentation/bloc/bloc.dart';
import 'package:nevesomiy/presentation/styles/styles.dart';
import 'package:nevesomiy/presentation/widgets/widget.dart';
import 'widgets/widgets.dart';

class PoemsScreen extends StatefulWidget {
  const PoemsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PoemsScreen> createState() => _PoemsScreenState();
}

class _PoemsScreenState extends State<PoemsScreen> {
  late ScrollController _hideBottomNavController;
  @override
  void initState() {
    super.initState();
    _hideBottomNavController = ScrollController();
    _hideBottomNavController.addListener(() {
      if (_hideBottomNavController.position.userScrollDirection == ScrollDirection.reverse) {
        context.read<MenuBloc>().add(MenuHide());
      } else if(_hideBottomNavController.position.userScrollDirection == ScrollDirection.forward) {
        context.read<MenuBloc>().add(MenuShow());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PoemsBloc, PoemsState>(
      listener: (context, state) async {
        if (state is PoemsLoaded) {
          if (!state.isSortedState) {
            sortByType(state.value);
          }
        }
      },
      builder: (context, state) {
        if (state is PoemsLoading) {
          context.read<MenuBloc>().add(MenuHide());
          return Center(
            child: LoadingIndicator(
              color: ColorStyles.mainColor,
              indicatorsSize: 48,
            ),
          );
        } else if (state is PoemsLoaded) {
          context.read<MenuBloc>().add(MenuShow());
          return CustomScrollView(
            controller: _hideBottomNavController,
            slivers: [
              SliverPersistentHeader(
                delegate: SliverListAppBar(),
                floating: true,
                pinned: true,
              ),
              TopicsBar(
                sortByType: sortByType,
                currentTopic: state.value,
              ),
              PoemList(
                poems: state.poems,
              ),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> _loadCache() async {
    context.read<PoemsBloc>().add(const PoemsLoad(syncWithFireStore: false));
  }

  void sortByType(Topics value) async {
    context.read<PoemsBloc>().add(PoemsSortByType(value: value));
  }
}
