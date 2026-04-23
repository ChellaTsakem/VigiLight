import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vigilight/app_colors.dart';
import 'package:vigilight/vigi_logo.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with TickerProviderStateMixin {
  int? _selectedCategory;
  final TextEditingController _descCtrl = TextEditingController();
  bool _isLocating = false;
  bool _locationCaptured = false;
  bool _isSubmitting = false;
  bool _submitted = false;
  String _capturedAddress = '';

  late AnimationController _successCtrl;
  late Animation<double> _successAnim;
  late AnimationController _locateCtrl;
  late Animation<double> _locateAnim;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  final List<_Category> _categories = const [
    _Category(
      icon: Icons.power_off_rounded,
      label: 'Plus de courant',
      description: 'Coupure totale de courant',
      color: AppColors.electricAmber,
    ),
    _Category(
      icon: Icons.bolt_rounded,
      label: 'Baisse de tension',
      description: 'Luminosité faible, équipements instables',
      color: AppColors.cyanBlue,
    ),
    _Category(
      icon: Icons.warning_rounded,
      label: 'Câble au sol',
      description: 'Câble sectionné ou tombé – Danger !',
      color: AppColors.redCoral,
    ),
    _Category(
      icon: Icons.local_fire_department_rounded,
      label: 'Transformateur',
      description: 'Transformateur en feu ou bruyant',
      color: AppColors.redCoral,
    ),
    _Category(
      icon: Icons.cell_tower_rounded,
      label: 'Poteau incliné',
      description: 'Poteau menaçant de tomber',
      color: AppColors.statusWarning,
    ),
    _Category(
      icon: Icons.electric_bolt_rounded,
      label: 'Autre incident',
      description: 'Autre type de problème électrique',
      color: AppColors.violet,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _successAnim = CurvedAnimation(
      parent: _successCtrl,
      curve: Curves.elasticOut,
    );

    _locateCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _locateAnim = Tween<double>(begin: 0, end: 1).animate(_locateCtrl);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _successCtrl.dispose();
    _locateCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _captureLocation() async {
    setState(() => _isLocating = true);
    HapticFeedback.mediumImpact();

    // Simuler la géolocalisation
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLocating = false;
        _locationCaptured = true;
        _capturedAddress = 'Bastos, Yaoundé\n3.8700° N, 11.5200° E';
      });
      HapticFeedback.heavyImpact();
    }
  }

  Future<void> _submitReport() async {
    if (_selectedCategory == null) {
      _showError('Veuillez sélectionner un type de panne');
      return;
    }
    if (!_locationCaptured) {
      _showError('Veuillez capturer votre position GPS');
      return;
    }

    setState(() => _isSubmitting = true);
    HapticFeedback.heavyImpact();

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _submitted = true;
      });
      _successCtrl.forward();
      HapticFeedback.heavyImpact();
    }
  }

  void _showError(String msg) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Text(msg,
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
          ],
        ),
        backgroundColor: AppColors.redCoral,
        behavior: SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _SuccessScreen(onHome: () {
      Navigator.pushReplacementNamed(context, '/home');
    });

    return Scaffold(
      body: AnimatedGridBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── En-tête ──────────────────────────────────────────────
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: const Icon(Icons.arrow_back_rounded,
                            color: AppColors.textPrimary, size: 20),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                AppColors.amberGradient.createShader(bounds),
                            child: Text(
                              '⚡ Signaler une panne',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            'Remplissez les informations ci-dessous',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VigiLogo(size: 42),
                  ],
                ),
              ),

              // ── Contenu scrollable ────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Géolocalisation ──────────────────────────────
                      _SectionLabel(
                        icon: Icons.gps_fixed_rounded,
                        label: '1. Votre position',
                        color: _locationCaptured
                            ? AppColors.neonGreen
                            : AppColors.electricAmber,
                      ),
                      const SizedBox(height: 12),
                      _LocationCapture(
                        isLocating: _isLocating,
                        locationCaptured: _locationCaptured,
                        capturedAddress: _capturedAddress,
                        locateAnim: _locateAnim,
                        onCapture: _captureLocation,
                      ),

                      const SizedBox(height: 28),

                      // ── Catégorie ────────────────────────────────────
                      _SectionLabel(
                        icon: Icons.category_rounded,
                        label: '2. Type de panne',
                        color: _selectedCategory != null
                            ? AppColors.neonGreen
                            : AppColors.electricAmber,
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.6,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (_, i) => _CategoryCard(
                          category: _categories[i],
                          isSelected: _selectedCategory == i,
                          onTap: () {
                            setState(() => _selectedCategory = i);
                            HapticFeedback.selectionClick();
                          },
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Photo optionnelle ────────────────────────────
                      _SectionLabel(
                        icon: Icons.camera_alt_rounded,
                        label: '3. Photo (optionnel)',
                        color: AppColors.cyanBlue,
                      ),
                      const SizedBox(height: 12),
                      _PhotoPicker(),

                      const SizedBox(height: 28),

                      // ── Description ──────────────────────────────────
                      _SectionLabel(
                        icon: Icons.edit_note_rounded,
                        label: '4. Description (optionnel)',
                        color: AppColors.violet,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descCtrl,
                        maxLines: 3,
                        maxLength: 200,
                        style: GoogleFonts.poppins(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText:
                          'Ex: "Depuis la pluie de 15h, câble tombé devant le marché..."',
                          hintStyle: GoogleFonts.poppins(
                              color: AppColors.textMuted, fontSize: 13),
                          filled: true,
                          fillColor: AppColors.surfaceCard,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                            const BorderSide(color: AppColors.borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                            const BorderSide(color: AppColors.borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                                color: AppColors.electricAmber, width: 1.5),
                          ),
                          counterStyle: GoogleFonts.poppins(
                              color: AppColors.textMuted, fontSize: 11),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Alerte offline
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.cyanBlue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.cyanBlue.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.wifi_off_rounded,
                                color: AppColors.cyanBlue, size: 18),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Sans internet ? Le signalement sera envoyé par SMS automatiquement.',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // ── Bouton Envoyer ────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                    24, 12, 24, MediaQuery.of(context).padding.bottom + 24),
                child: AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, child) => Transform.scale(
                    scale: _pulseAnim.value,
                    child: child,
                  ),
                  child: GestureDetector(
                    onTap: _isSubmitting ? null : _submitReport,
                    child: Container(
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: AppColors.amberGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.electricAmber.withOpacity(0.5),
                            blurRadius: 25,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _isSubmitting
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                            : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.send_rounded,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              'Envoyer le signalement',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Composants
// ─────────────────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _LocationCapture extends StatelessWidget {
  final bool isLocating;
  final bool locationCaptured;
  final String capturedAddress;
  final Animation<double> locateAnim;
  final VoidCallback onCapture;

  const _LocationCapture({
    required this.isLocating,
    required this.locationCaptured,
    required this.capturedAddress,
    required this.locateAnim,
    required this.onCapture,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: locationCaptured ? null : onCapture,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: locationCaptured
              ? const LinearGradient(
            colors: [Color(0xFF0D2018), Color(0xFF0F1628)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : AppColors.cardGradient,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: locationCaptured
                ? AppColors.neonGreen.withOpacity(0.4)
                : AppColors.electricAmber.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: locateAnim,
              builder: (_, __) => Stack(
                alignment: Alignment.center,
                children: [
                  if (isLocating)
                    Opacity(
                      opacity: 1 - locateAnim.value,
                      child: Container(
                        width: 20 + locateAnim.value * 30,
                        height: 20 + locateAnim.value * 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.electricAmber,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: locationCaptured
                          ? AppColors.neonGreen.withOpacity(0.15)
                          : AppColors.electricAmber.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      locationCaptured
                          ? Icons.location_on_rounded
                          : Icons.gps_not_fixed_rounded,
                      color: locationCaptured
                          ? AppColors.neonGreen
                          : AppColors.electricAmber,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locationCaptured
                        ? '✅ Position capturée'
                        : isLocating
                        ? 'Localisation en cours...'
                        : 'Capturer ma position GPS',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: locationCaptured
                          ? AppColors.neonGreen
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    locationCaptured
                        ? capturedAddress
                        : 'Appuyez pour géolocaliser automatiquement',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (!locationCaptured)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.amberGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isLocating
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
                    : const Icon(Icons.my_location_rounded,
                    color: Colors.white, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final _Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              category.color.withOpacity(0.25),
              category.color.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : AppColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? category.color.withOpacity(0.6)
                : AppColors.borderColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: category.color.withOpacity(0.2),
              blurRadius: 15,
            )
          ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(category.icon,
                    color: isSelected ? category.color : AppColors.textSecondary,
                    size: 22),
                if (isSelected)
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: category.color,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 12),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? category.color : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoPicker extends StatefulWidget {
  @override
  State<_PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<_PhotoPicker> {
  bool _hasPhoto = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _hasPhoto = true),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 110,
        decoration: BoxDecoration(
          color: _hasPhoto
              ? AppColors.neonGreen.withOpacity(0.1)
              : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hasPhoto
                ? AppColors.neonGreen.withOpacity(0.4)
                : AppColors.borderColor,
            style: _hasPhoto ? BorderStyle.solid : BorderStyle.none,
            width: 1,
          ),
        ),
        child: _hasPhoto
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded,
                color: AppColors.neonGreen, size: 32),
            const SizedBox(height: 6),
            Text(
              'Photo ajoutée ✓',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.neonGreen,
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _hasPhoto = false),
              child: Text(
                'Retirer',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.textMuted),
              ),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.cyanBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_a_photo_rounded,
                  color: AppColors.cyanBlue, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajouter une photo ou vidéo',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '(aide les techniciens)',
              style: GoogleFonts.poppins(
                  fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Écran de succès
// ─────────────────────────────────────────────────────────────────────────────
class _SuccessScreen extends StatefulWidget {
  final VoidCallback onHome;
  const _SuccessScreen({required this.onHome});

  @override
  State<_SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<_SuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late AnimationController _waveCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _waveAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _scaleAnim = CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);

    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _waveAnim = Tween<double>(begin: 0, end: 1).animate(_waveCtrl);
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _waveCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGridBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icône animée
                AnimatedBuilder(
                  animation: Listenable.merge([_scaleAnim, _waveAnim]),
                  builder: (_, __) => SizedBox(
                    width: 180,
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ...List.generate(3, (i) {
                          final progress =
                          ((_waveAnim.value - i * 0.33) % 1.0).clamp(0.0, 1.0);
                          return Opacity(
                            opacity: (1 - progress) * 0.5,
                            child: Container(
                              width: 80 + progress * 100,
                              height: 80 + progress * 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.neonGreen.withOpacity(0.6),
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        }),
                        Transform.scale(
                          scale: _scaleAnim.value,
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              gradient: AppColors.greenGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.neonGreen.withOpacity(0.5),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.check_rounded,
                                color: Colors.white, size: 48),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.greenGradient.createShader(bounds),
                  child: Text(
                    'Signalement envoyé !',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Merci pour votre contribution citoyenne.\nVous venez de gagner +10 pts de Civisme 🏆',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.neonGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.neonGreen.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.notifications_active_rounded,
                          color: AppColors.neonGreen, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        'Vous serez notifié du suivi',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.neonGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: widget.onHome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Retour à l'accueil",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Modèle catégorie
// ─────────────────────────────────────────────────────────────────────────────
class _Category {
  final IconData icon;
  final String label;
  final String description;
  final Color color;

  const _Category({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
  });
}