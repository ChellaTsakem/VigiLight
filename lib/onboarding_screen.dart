import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vigilight/app_colors.dart';
import 'package:vigilight/vigi_logo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  final List<_OnboardData> _slides = const [
    _OnboardData(
      title: 'Signalez\nen un clic',
      subtitle:
      'Plus besoin d\'appeler. Appuyez sur le bouton, votre position est capturée automatiquement et la panne signalée en secondes.',
      icon: Icons.bolt_rounded,
      gradient: AppColors.amberGradient,
      glowColor: AppColors.electricAmber,
      tag: '01 — Signalement',
    ),
    _OnboardData(
      title: 'Votre quartier\nen temps réel',
      subtitle:
      'Consultez la carte interactive pour voir les zones hors tension, les incidents critiques et les équipes en intervention.',
      icon: Icons.map_rounded,
      gradient: AppColors.cyanGradient,
      glowColor: AppColors.cyanBlue,
      tag: '02 — Cartographie',
    ),
    _OnboardData(
      title: 'Ensemble,\non répare plus vite',
      subtitle:
      'Chaque signalement confirmé par la communauté accélère l\'intervention. Gagnez des points de Civisme et contribuez à un réseau plus fiable.',
      icon: Icons.people_rounded,
      gradient: AppColors.greenGradient,
      glowColor: AppColors.neonGreen,
      tag: '03 — Communauté',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -12, end: 12).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _floatCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _skip() => Navigator.pushReplacementNamed(context, '/login');

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _fadeCtrl.reset();
    _fadeCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final slide = _slides[_currentPage];

    return Scaffold(
      body: AnimatedGridBackground(
        child: Column(
          children: [
            // ── Skip button ──────────────────────────────────────────────
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const VigiLogo(size: 40),
                    if (_currentPage < _slides.length - 1)
                      TextButton(
                        onPressed: _skip,
                        child: Text(
                          'Passer',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── Page View ────────────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                onPageChanged: _onPageChanged,
                itemCount: _slides.length,
                itemBuilder: (_, index) =>
                    _SlideView(data: _slides[index], floatAnim: _floatAnim),
              ),
            ),

            // ── Bottom controls ──────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                  28, 20, 28, MediaQuery.of(context).padding.bottom + 32),
              child: Column(
                children: [
                  // Indicateurs de page
                  AnimatedSmoothIndicator(
                    activeIndex: _currentPage,
                    count: _slides.length,
                    effect: ExpandingDotsEffect(
                      dotWidth: 8,
                      dotHeight: 8,
                      expansionFactor: 4,
                      activeDotColor: slide.glowColor,
                      dotColor: AppColors.borderColor,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Bouton principal
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: double.infinity,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: slide.gradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: slide.glowColor.withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: _nextPage,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage == _slides.length - 1
                                    ? 'Commencer'
                                    : 'Suivant',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded,
                                  color: Colors.white, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Lien connexion
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Vous avez déjà un compte ? ',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: Text(
                          'Se connecter',
                          style: TextStyle(
                            color: AppColors.electricAmber,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Slide individuel
// ─────────────────────────────────────────────────────────────────────────────
class _SlideView extends StatelessWidget {
  final _OnboardData data;
  final Animation<double> floatAnim;

  const _SlideView({required this.data, required this.floatAnim});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration flottante
          AnimatedBuilder(
            animation: floatAnim,
            builder: (_, __) => Transform.translate(
              offset: Offset(0, floatAnim.value),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Halo de fond
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          data.glowColor.withOpacity(0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Anneau extérieur
                  Container(
                    width: 155,
                    height: 155,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: data.glowColor.withOpacity(0.25),
                        width: 1.5,
                      ),
                    ),
                  ),
                  // Icône centrale
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: data.gradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: data.glowColor.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(data.icon, size: 50, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: data.glowColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border:
              Border.all(color: data.glowColor.withOpacity(0.3), width: 1),
            ),
            child: Text(
              data.tag,
              style: TextStyle(
                color: data.glowColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Titre
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.15,
            ),
          ),

          const SizedBox(height: 16),

          // Sous-titre
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Modèle de données pour les slides
// ─────────────────────────────────────────────────────────────────────────────
class _OnboardData {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final Color glowColor;
  final String tag;

  const _OnboardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.glowColor,
    required this.tag,
  });
}