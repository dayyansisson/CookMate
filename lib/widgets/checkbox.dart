import 'package:CookMate/util/styleSheet.dart';
import 'package:flutter/material.dart';

class Checkoff extends StatefulWidget {

  final bool initialValue;
  final Function(bool) onTap;

  final Color color;
  final double size;
  final Duration transitionDuration;

  Checkoff({ 
    @required this.initialValue, 
    @required this.onTap, 
    this.color = StyleSheet.WHITE, 
    this.size = 24, 
    this.transitionDuration = const Duration(milliseconds: 0) 
  });

  @override
  _CheckoffState createState() => _CheckoffState();
}

class _CheckoffState extends State<Checkoff> with TickerProviderStateMixin{

  /* Animation Constants */
  static const double FILL_DISABLED_OPACITY = 0.1;
  static const double FILL_ENABLED_OPACITY = 0.3;
  static const double BORDER_DISABLED_OPACITY = 1;
  static const double BORDER_ENABLED_OPACITY = 0;
  static const double SIZE_FACTOR_DISABLED = 1;
  static const double SIZE_FACTOR_ENABLED = 0.9;

  /* Animation Values */
  double fillOpacity;
  double borderOpacity;
  double sizeFactor;

  bool enabled;

  @override
  void initState() {
    super.initState();

    enabled = widget.initialValue;
    setValues();
  }

  void setValues() {

    if(enabled) {
      fillOpacity = FILL_ENABLED_OPACITY;
      borderOpacity = BORDER_ENABLED_OPACITY;
      sizeFactor = SIZE_FACTOR_ENABLED;
    } else {
      fillOpacity = FILL_DISABLED_OPACITY;
      borderOpacity = BORDER_DISABLED_OPACITY;
      sizeFactor = SIZE_FACTOR_DISABLED;
    }
  }

  @override
  Widget build(BuildContext context) {

    double size = widget.size * sizeFactor;

    return Button(
      onPressed: () {
        setState(() {
          enabled = !enabled;
          setValues();
        });
        widget.onTap(enabled);
      },
      child: AnimatedContainer(
        duration: widget.transitionDuration,
        curve: Curves.easeInOut,
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.color.withOpacity(fillOpacity),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(size / 4)),
          border: Border.all(color: widget.color.withOpacity(borderOpacity), width: 1.25)
        ),
        child: AnimatedOpacity(
          duration: widget.transitionDuration, 
          curve: Curves.elasticInOut,
          opacity: enabled ? 1 : 0,
          child: Icon(
            Icons.check,
            size: size * (5 / 7),
            color: Colors.black.withOpacity(0.2),
          ),
        )
      ),
    );
  }
}