import 'package:flutter/material.dart';
import 'package:vigilight/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Logo VigiLight — utilise le vrai logo assets/logo/VigiLight3.png
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
        SizedBox(
          width: 74,
          height: 74,
          child: Image.asset(
            'assets/logo/VigiLight4Bg.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _FallbackLogo(size: size),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 10),
          ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.goldGradient.createShader(bounds),
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

// Fallback si l'image ne charge pas
class _FallbackLogo extends StatelessWidget {
  final double size;
  const _FallbackLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.amberGradient,
        borderRadius: BorderRadius.circular(size * 0.22),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricAmber.withOpacity(0.5),
            blurRadius: size * 0.4,
          ),
        ],
      ),
      child: Icon(Icons.bolt_rounded, color: Colors.white, size: size * 0.55),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logo centré pour AppBar (version horizontale avec texte)
// ─────────────────────────────────────────────────────────────────────────────
class VigiLogoAppBar extends StatelessWidget {
  final double logoSize;

  const VigiLogoAppBar({super.key, this.logoSize = 36});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/logo/VigiLight5Bg.png',
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.bolt_rounded, color: AppColors.electricAmber, size: logoSize),
        ),
        const SizedBox(width: 8),
        ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.goldGradient.createShader(bounds),
          child: Text(
            'VigiLight',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: logoSize * 0.6,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fond animé (particules + cercles lumineux)
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
        vsync: this, duration: const Duration(seconds: 5))
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
        // Fond noir profond
        Container(
          decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        ),
        // Halo doré en haut à droite
        Positioned(
          top: -100,
          right: -80,
          child: AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.electricAmber
                        .withOpacity(0.08 + _anim.value * 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        // Halo bleu en bas à gauche
        Positioned(
          bottom: -80,
          left: -80,
          child: AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.cyanBlue
                        .withOpacity(0.06 + _anim.value * 0.04),
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
// GlassCard
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
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}