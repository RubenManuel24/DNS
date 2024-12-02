import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoaderAnimation extends StatelessWidget {
  const LoaderAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.discreteCircle(
          color: Colors.white, 
           secondRingColor: Colors.black,
           thirdRingColor : Colors.white,
          size: 80),
    );
  }
}
