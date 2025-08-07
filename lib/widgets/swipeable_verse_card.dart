import 'package:flutter/material.dart';

class SwipeableVerseCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;

  const SwipeableVerseCard({
    required this.child,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    Key? key,
  }) : super(key: key);

  @override
  _SwipeableVerseCardState createState() => _SwipeableVerseCardState();
}

class _SwipeableVerseCardState extends State<SwipeableVerseCard> {
  double _dragOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background arrows
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: _dragOffset.abs() > 5 ? 0.2 : 0.0,
            duration: Duration(milliseconds: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Icon(Icons.arrow_back_ios, size: 32),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.arrow_forward_ios, size: 32),
                ),
              ],
            ),
          ),
        ),

        // Foreground draggable card
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dragOffset += details.delta.dx;
            });
          },
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null) {
              if (details.primaryVelocity! > 0) {
                widget.onSwipeRight();
              } else if (details.primaryVelocity! < 0) {
                widget.onSwipeLeft();
              }
            }
            setState(() {
              _dragOffset = 0.0;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(_dragOffset, 0, 0),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
