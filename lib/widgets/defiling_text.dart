import 'package:flutter/material.dart';

class DefilingText extends StatefulWidget {
  final String text;
  final bool enabled;
  final TextStyle? style;

  const DefilingText({Key? key, required this.text, required this.enabled, this.style}) : super(key: key);

  @override
  State<DefilingText> createState() => _DefilingTextState();
}

class _DefilingTextState extends State<DefilingText> with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  bool _hasScrolled = false;
  double _overflow = 0;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflowAndScroll());
  }

  @override
  void didUpdateWidget(covariant DefilingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.enabled != widget.enabled) {
      _hasScrolled = false;
      if (widget.enabled) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflowAndScroll());
      } else {
        _scrollController.jumpTo(0);
        setState(() => _isScrolling = false);
      }
    }
  }

  void _checkOverflowAndScroll() async {
    if (!widget.enabled || _hasScrolled) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final maxWidth = box.size.width;
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    final textWidth = textPainter.width;
    _overflow = textWidth - maxWidth;
    if (_overflow > 0) {
      setState(() => _isScrolling = true);
      const double speed = 150.0; // pixels per second
      double distance = (_overflow - _scrollController.offset).abs();
      await _scrollController.animateTo(
        _overflow,
        duration: Duration(milliseconds: (distance / speed * 1000).round()),
        curve: Curves.linear,
      );
      await Future.delayed(const Duration(milliseconds: 300));
      distance = (_scrollController.offset).abs();
      await _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: (distance / speed * 1000).round()),
        curve: Curves.linear,
      );
      setState(() => _isScrolling = false);
      _hasScrolled = true;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Stack(
        children: [
          // Idle state: show ellipsis
          Opacity(
            opacity: _isScrolling ? 0.0 : 1.0,
            child: Text(
              widget.text,
              style: widget.style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Scrolling state: show full text in scroll view (always built)
          Opacity(
            opacity: _isScrolling ? 1.0 : 0.0,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Text(
                widget.text,
                style: widget.style,
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
