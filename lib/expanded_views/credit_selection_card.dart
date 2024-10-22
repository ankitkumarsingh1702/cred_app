import 'dart:math';
import 'package:flutter/material.dart';
import '../models/stack_item.dart';

class CreditSelectionCard extends StatefulWidget {
  final Body body;
  final String ctaText;
  final Function(Map<String, dynamic> data) onCtaPressed;

  CreditSelectionCard({
    required this.body,
    required this.ctaText,
    required this.onCtaPressed,
  });

  @override
  _CreditSelectionCardState createState() => _CreditSelectionCardState();
}

class _CreditSelectionCardState extends State<CreditSelectionCard> {
  late double _currentValue;
  late double _currentAngle;

  final double _fixedAngle = 0.0;
  final double _sliderRadius = 120.0;
  final double _pointerSize = 40.0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.body.card!.minRange.toDouble();
    _currentAngle = _valueToAngle(_currentValue);
  }

  double _valueToAngle(double value) {
    double min = widget.body.card!.minRange.toDouble();
    double max = widget.body.card!.maxRange.toDouble();
    double angleRange = 360.0;
    double angle = ((value - min) / (max - min)) * angleRange;
    return _fixedAngle + angle;
  }

  double _angleToValue(double angle) {
    double min = widget.body.card!.minRange.toDouble();
    double max = widget.body.card!.maxRange.toDouble();
    double angleRange = 360.0;
    double deltaAngle = (angle - _fixedAngle) % 360;
    double value = (deltaAngle / angleRange) * (max - min) + min;
    return value.clamp(min, max);
  }

  void _handleTouch(Offset touchPosition, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final touchVector = touchPosition - center;
    double touchAngle = atan2(touchVector.dy, touchVector.dx) * 180 / pi;

    if (touchAngle < 0) touchAngle += 360.0;

    setState(() {
      _currentAngle = touchAngle;
      _currentValue = _angleToValue(_currentAngle);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.85,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.withOpacity(0.5),
            Colors.transparent
            // const Color(0xFF1C1C1C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            widget.body.title!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.body.subtitle!,
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
          const SizedBox(height: 20),
          // Slider Area
          Expanded(
            child: Center(
              child: Container(
                height: screenHeight * 0.45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    RenderBox box = context.findRenderObject() as RenderBox;
                    Offset localPosition = box.globalToLocal(details.globalPosition);
                    _handleTouch(localPosition, box.size);
                  },
                  child: CustomPaint(
                    size: Size(
                      (_sliderRadius + _pointerSize) * 2,
                      (_sliderRadius + _pointerSize) * 2,
                    ),
                    painter: _CircularSliderPainter(
                      fixedAngle: _fixedAngle,
                      currentAngle: _currentAngle,
                      sliderRadius: _sliderRadius,
                      pointerSize: _pointerSize,
                    ),
                    child: SizedBox(
                      width: (_sliderRadius + _pointerSize) * 2,
                      height: (_sliderRadius + _pointerSize) * 2,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _buildMovablePointer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.body.card!.header,
                                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                              ),
                              Text(
                                '₹${_currentValue.toInt()}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.body.card!.description,
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          // Position the footer text at the bottom of the circular slider
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                widget.body.footer!,
                                style: const TextStyle(
                                  color: Color(0xFF8E8E93),
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: 16,)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Footer and Button
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.onCtaPressed({'creditAmount': _currentValue});
                },
                child: Text(widget.ctaText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMovablePointer() {
    double radians = (_currentAngle - 90.0) * pi / 180.0;
    final center = Offset(_sliderRadius + _pointerSize, _sliderRadius + _pointerSize);
    final double x = center.dx + _sliderRadius * cos(radians) - _pointerSize / 2;
    final double y = center.dy + _sliderRadius * sin(radians) - _pointerSize / 2;

    return Positioned(
      left: x,
      top: y,
      child: Icon(
        Icons.circle,
        color: Colors.orange,
        size: _pointerSize,
      ),
    );
  }
}

// CustomPainter to draw the circular slider
class _CircularSliderPainter extends CustomPainter {
  final double fixedAngle;
  final double currentAngle;
  final double sliderRadius;
  final double pointerSize;

  _CircularSliderPainter({
    required this.fixedAngle,
    required this.currentAngle,
    required this.sliderRadius,
    required this.pointerSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(sliderRadius + pointerSize, sliderRadius + pointerSize);

    final trackPaint = Paint()
      ..color = const Color(0xFFE5E5E5)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rangePaint = Paint()
      ..color = const Color(0xFFFFAD94)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw the background track
    canvas.drawCircle(center, sliderRadius, trackPaint);

    // Calculate the sweep angle
    double sweepAngle = (currentAngle - fixedAngle) * pi / 180.0;

    // Draw the active range arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: sliderRadius),
      -pi / 2,
      sweepAngle,
      false,
      rangePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularSliderPainter oldDelegate) {
    return oldDelegate.currentAngle != currentAngle || oldDelegate.fixedAngle != fixedAngle;
  }
}
