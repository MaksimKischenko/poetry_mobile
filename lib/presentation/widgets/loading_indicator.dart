import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class LoadingIndicator extends StatelessWidget {
  final Color color;
  final double indicatorsSize;
  
  const LoadingIndicator({
    Key? key,
    this.color = Colors.transparent,
    this.indicatorsSize = 24
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => LoadingAnimationWidget.discreteCircle(
    color: color,
    size: indicatorsSize
  );
  
  // SimpleCircularProgressBar(
  //   backStrokeWidth: 3,
  //   progressStrokeWidth: 6,
  //   animationDuration: 10,
  //   startAngle: 0,
  //   size: indicatorsSize,
  //   mergeMode: true,
  //   progressColors: [color],
  //   backColor: color,
  // );
}