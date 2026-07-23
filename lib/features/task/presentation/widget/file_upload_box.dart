import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:toy_village_app/core/constants/color.dart';
import 'package:toy_village_app/core/constants/text_style.dart';

class FileUploadBox extends StatelessWidget {
  final VoidCallback onTap;

  const FileUploadBox({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: ToyVillageColor.gray40,
          radius: 8,
        ),
        child: Container(
          width: double.infinity,
          height: 130,
          decoration: BoxDecoration(
            color: ToyVillageColor.gray20,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Symbols.cloud_upload,
                size: 32,
                color: ToyVillageColor.gray60,
              ),
              const SizedBox(height: 12),
              Text(
                '클릭하여 파일 업로드',
                style: ToyVillageTextStyle.button4.copyWith(
                  color: ToyVillageColor.gray60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  static const double dashWidth = 6;
  static const double dashGap = 5;

  _DashedBorderPainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
