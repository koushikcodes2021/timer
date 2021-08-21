import 'package:flutter/material.dart';
import 'main.dart';
import 'package:provider/provider.dart';

class NeuResetButton extends StatefulWidget {
  final double bevel;
  final Offset blurOffset;

  NeuResetButton({
    Key key,
    this.bevel = 10.0,
  })  : this.blurOffset = Offset(bevel / 2, bevel / 2),
        super(key: key);

  @override
  _NeuResetButtonState createState() => _NeuResetButtonState();
}

class _NeuResetButtonState extends State<NeuResetButton> {
  bool _isPressed = false;

  void _onPointerDown() {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        _onPointerDown();
        final isRunning =
            Provider.of<TimerService>(context, listen: false).isRunning;
        Provider.of<TimerService>(context, listen: false).reset();
        // If user press reset button when timer is running, start for them
        if (isRunning)
          Provider.of<TimerService>(context, listen: false).start();
      },
      onPointerUp: _onPointerUp,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 73,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: _isPressed
              ? null
              : [
                  BoxShadow(
                    blurRadius: 15,
                    offset: -widget.blurOffset,
                    color: Colors.black38,
                  ),
                  BoxShadow(
                    blurRadius: 15,
                    offset: Offset(10.5, 10.5),
                    color: Colors.black12,
                  )
                ],
        ),
        child: Center(
          child: Text(
            'Reset',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      ),
    );
  }
}

extension ColorUtils on Color {
  Color mix(Color another, double amount) {
    return Color.lerp(this, another, amount);
  }
}
