import 'package:flutter/material.dart';
import 'neu_progress_painter.dart';
import 'main.dart';
import 'package:provider/provider.dart';

class NeuProgressPieBar extends StatelessWidget {
  const NeuProgressPieBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage =
        Provider.of<TimerService>(context).currentDuration.inSeconds / 60 * 100;
    return Container(
      height: 400,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            offset: Offset(-5, -5),
            color: Colors.black,
          ),
          BoxShadow(
            blurRadius: 15,
            offset: Offset(10.5, 10.5),
            color: Colors.black12,
          )
        ],
        border: Border.all(
          width: 15,
          color: Colors.black,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Center(
            child: SizedBox(
              height: 250,
              child: CustomPaint(
                painter: NeuProgressPainter(
                  circleWidth: 40,
                  completedPercentage: percentage,
                  defaultCircleColor: Colors.transparent,
                ),
                child: Center(),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.grey.withOpacity(0.0),
                    Colors.black54,
                  ],
                  stops: [0.95, 1.0],
                ),
                border: Border.all(
                  width: 15,
                  color: Theme.of(context).backgroundColor,
                ),
              ),
              child: Center(child: NeuStartButton()),
            ),
          ),
        ],
      ),
    );
  }
}

class NeuStartButton extends StatefulWidget {
  final double bevel;
  final Offset blurOffset;

  NeuStartButton({
    Key key,
    this.bevel = 10.0,
  })  : this.blurOffset = Offset(bevel / 2, bevel / 2),
        super(key: key);

  @override
  _NeuStartButtonState createState() => _NeuStartButtonState();
}

class _NeuStartButtonState extends State<NeuStartButton> {
  bool _isPressed = false;
  bool _isRunning = false;

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
        _isRunning
            ? Provider.of<TimerService>(context, listen: false).stop()
            : Provider.of<TimerService>(context, listen: false).start();
        setState(() => _isRunning = !_isRunning);
      },
      onPointerUp: _onPointerUp,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 95,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          boxShadow: _isPressed
              ? null
              : [
                  BoxShadow(
                    blurRadius: 15,
                    spreadRadius: 5,
                    offset: -widget.blurOffset,
                    color: Colors.black54,
                  ),
                  BoxShadow(
                    blurRadius: 15,
                    offset: Offset(10.5, 10.5),
                    color: Colors.black38,
                  )
                ],
        ),
        child: Center(
            child: Icon(
          _isRunning ? Icons.stop : Icons.play_arrow,
          size: 60,
          color: _isRunning
              ? Colors.red
              : Colors.green,
        )),
      ),
    );
  }
}

extension ColorUtils on Color {
  Color mix(Color another, double amount) {
    return Color.lerp(this, another, amount);
  }
}
