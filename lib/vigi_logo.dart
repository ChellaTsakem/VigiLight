import 'package:flutter/material.dart';
import 'package:vigilight/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Logo VigiLight — éclair stylisé dans un hexagone lumineux
// ─────────────────────────────────────────────────────────────────────────────
class VigiLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const VigiLogo({super.key, this.size = 60, this.showText = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: AppColors.amberGradient,
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: [
              BoxShadow(
                color: AppColors.electricAmber.withOpacity(0.45),
                blurRadius: size * 0.5,
                spreadRadius: size * 0.05,
              ),
            ],
          ),
          child: CustomPaint(
            painter: _LightningPainter(),
            size: Size(size, size),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 10),
          ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.amberGradient.createShader(bounds),
            child: Text(
              'VigiLight',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: size * 0.35,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _LightningPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Éclair ⚡ centré
    final path = Path();
    path.moveTo(cx + 4, cy - size.height * 0.30);
    path.lineTo(cx - 6, cy + size.height * 0.02);
    path.lineTo(cx + 2, cy + size.height * 0.02);
    path.lineTo(cx - 4, cy + size.height * 0.30);
    path.lineTo(cx + 7, cy - size.height * 0.04);
    path.lineTo(cx + 0, cy - size.height * 0.04);
    path.close();

    // Ombre légère
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.18)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawPath(path.shift(const Offset(1.5, 1.5)), shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget de fond animé (grille lumineuse)
// ─────────────────────────────────────────────────────────────────────────────
class AnimatedGridBackground extends StatefulWidget {
  final Widget child;
  const AnimatedGridBackground({super.key, required this.child});

  @override
  State<AnimatedGridBackground> createState() => _AnimatedGridBackgroundState();
}

class _AnimatedGridBackgroundState extends State<AnimatedGridBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 4))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0, end: 1).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fond dégradé principal
        Container(
          decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        ),
        // Cercle lumineux ambre en haut à droite
        Positioned(
          top: -80,
          right: -60,
          child: AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.electricAmber
                        .withOpacity(0.10 + _anim.value * 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        // Cercle lumineux cyan en bas à gauche
        Positioned(
          bottom: -60,
          left: -60,
          child: AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.cyanBlue
                        .withOpacity(0.08 + _anim.value * 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        // Contenu
        widget.child,
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Glassmorphism card
// ─────────────────────────────────────────────────────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: AppColors.cardGradient,
        border: Border.all(
          color: borderColor ?? AppColors.borderColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}