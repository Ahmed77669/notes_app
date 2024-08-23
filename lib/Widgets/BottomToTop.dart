
import 'package:flutter/cupertino.dart';

class BottomToTopPageRoute extends PageRouteBuilder {
  final Widget page;

  BottomToTopPageRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end);
      var offsetAnimation =
      animation.drive(tween.chain(CurveTween(curve: curve)));
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}