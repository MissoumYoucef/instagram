

import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget isChild;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;
  const LikeAnimation({super.key, required this.isChild, required this.isAnimating, required this.duration, this.onEnd, required this.smallLike});

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation> with SingleTickerProviderStateMixin{
  
  late AnimationController animationController;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    animationController=AnimationController(vsync: this,duration: const Duration(seconds: 1));
    scale = Tween<double>(begin: 1,end: 1.2).animate(animationController);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.isAnimating!= oldWidget.isAnimating){
      startAnimation();
    }
  }

  startAnimation() async {
    if(widget.isAnimating|| widget.smallLike){
      await animationController.forward();
      await animationController.reverse();
      await Future.delayed(const Duration(seconds: 1));

      if(widget.onEnd != null){
        widget.onEnd!();
      }

    }
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.isChild,
    );
  }
}