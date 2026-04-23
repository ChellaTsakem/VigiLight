import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vigilight/app_colors.dart';
import 'package:vigilight/vigi_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _quartierCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _acceptTerms = false;
  int _currentStep = 0; // 0 = infos perso, 1 = sécurité, 2 = localisation

  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;
  late PageController _stepCtrl;

  @override
  void initState() {
    super.initState();
    _stepCtrl = PageController();
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _slideCtrl.forward();
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _quartierCtrl.dispose();
    _slideCtrl.dispose();
    _stepCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _stepCtrl.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _register();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _stepCtrl.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      _showSnack("Veuillez accepter les conditions d'utilisation");
      return;
    }
    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: AppColors.redCoral,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGridBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── En-tête ────────────────────────────────────────────────
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _currentStep > 0
                          ? _prevStep()
                          : Navigator.pushReplacementNamed(context, '/login'),
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
                          Text(
                            'Créer un compte',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Étape ${_currentStep + 1} sur 3',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
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

              // ── Barre de progression ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _StepProgressBar(currentStep: _currentStep),
              ),

              const SizedBox(height: 24),

              // ── Formulaire multi-étapes ─────────────────────────────────
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _stepCtrl,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _Step1PersonalInfo(
                        nomCtrl: _nomCtrl,
                        prenomCtrl: _prenomCtrl,
                        phoneCtrl: _phoneCtrl,
                        emailCtrl: _emailCtrl,
                      ),
                      _Step2Security(
                        passwordCtrl: _passwordCtrl,
                        confirmPasswordCtrl: _confirmPasswordCtrl,
                        obscurePassword: _obscurePassword,
                        obscureConfirm: _obscureConfirm,
                        onTogglePassword: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                        onToggleConfirm: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                        passwordValue: _passwordCtrl.text,
                      ),
                      _Step3Location(
                        quartierCtrl: _quartierCtrl,
                        acceptTerms: _acceptTerms,
                        onTermsChanged: (v) =>
                            setState(() => _acceptTerms = v ?? false),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Bouton suivant ─────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                    24, 12, 24, MediaQuery.of(context).padding.bottom + 24),
                child: Column(
                  children: [
                    _AnimatedNextButton(
                      isLoading: _isLoading,
                      isLastStep: _currentStep == 2,
                      onTap: _nextStep,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Déjà un compte ? ',
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: AppColors.textSecondary),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                              context, '/login'),
                          child: Text(
                            'Se connecter',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.electricAmber,
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
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Barre de progression des étapes
// ─────────────────────────────────────────────────────────────────────────────
class _StepProgressBar extends StatelessWidget {
  final int currentStep;
  const _StepProgressBar({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        final isActive = i <= currentStep;
        final isCurrent = i == currentStep;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: isCurrent ? 6 : 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: isActive ? AppColors.amberGradient : null,
                color: isActive ? null : AppColors.borderColor,
                boxShadow: isCurrent
                    ? [
                  BoxShadow(
                    color: AppColors.electricAmber.withOpacity(0.5),
                    blurRadius: 10,
                  )
                ]
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Étape 1 — Informations personnelles
// ─────────────────────────────────────────────────────────────────────────────
class _Step1PersonalInfo extends StatelessWidget {
  final TextEditingController nomCtrl;
  final TextEditingController prenomCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController emailCtrl;

  const _Step1PersonalInfo({
    required this.nomCtrl,
    required this.prenomCtrl,
    required this.phoneCtrl,
    required this.emailCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.person_rounded,
            title: 'Qui êtes-vous ?',
            subtitle: 'Vos informations personnelles',
            color: AppColors.electricAmber,
          ),
          const SizedBox(height: 24),
          _RegisterCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _RegField(
                        controller: nomCtrl,
                        label: 'Nom',
                        hint: 'Dupont',
                        icon: Icons.badge_outlined,
                        validator: (v) =>
                        v == null || v.isEmpty ? 'Requis' : null,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _RegField(
                        controller: prenomCtrl,
                        label: 'Prénom',
                        hint: 'Marie',
                        icon: Icons.badge_outlined,
                        validator: (v) =>
                        v == null || v.isEmpty ? 'Requis' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _RegField(
                  controller: phoneCtrl,
                  label: 'Téléphone',
                  hint: '+237 6XX XXX XXX',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Requis';
                    if (v.length < 9) return 'Numéro invalide';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _RegField(
                  controller: emailCtrl,
                  label: 'Email (optionnel)',
                  hint: 'exemple@email.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Étape 2 — Sécurité
// ─────────────────────────────────────────────────────────────────────────────
class _Step2Security extends StatelessWidget {
  final TextEditingController passwordCtrl;
  final TextEditingController confirmPasswordCtrl;
  final bool obscurePassword;
  final bool obscureConfirm;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirm;
  final String passwordValue;

  const _Step2Security({
    required this.passwordCtrl,
    required this.confirmPasswordCtrl,
    required this.obscurePassword,
    required this.obscureConfirm,
    required this.onTogglePassword,
    required this.onToggleConfirm,
    required this.passwordValue,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.shield_rounded,
            title: 'Sécurisez\nvotre compte',
            subtitle: 'Choisissez un mot de passe fort',
            color: AppColors.cyanBlue,
          ),
          const SizedBox(height: 24),
          _RegisterCard(
            child: Column(
              children: [
                _RegField(
                  controller: passwordCtrl,
                  label: 'Mot de passe',
                  hint: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  obscureText: obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: onTogglePassword,
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Requis';
                    if (v.length < 8) return 'Minimum 8 caractères';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _RegField(
                  controller: confirmPasswordCtrl,
                  label: 'Confirmer le mot de passe',
                  hint: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  obscureText: obscureConfirm,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirm
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: onToggleConfirm,
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Requis';
                    if (v != passwordCtrl.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Indicateur de force du mot de passe
                _PasswordStrengthIndicator(password: passwordValue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  const _PasswordStrengthIndicator({required this.password});

  int get strength {
    if (password.length < 4) return 0;
    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;
    return score;
  }

  String get label {
    switch (strength) {
      case 0:
      case 1:
        return 'Faible';
      case 2:
        return 'Moyen';
      case 3:
        return 'Fort';
      case 4:
        return 'Très fort ✓';
      default:
        return '';
    }
  }

  Color get color {
    switch (strength) {
      case 0:
      case 1:
        return AppColors.redCoral;
      case 2:
        return AppColors.electricAmber;
      case 3:
        return AppColors.neonGreen;
      case 4:
        return AppColors.cyanBlue;
      default:
        return AppColors.borderColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 6),
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: i < strength ? color : AppColors.borderColor,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          'Force du mot de passe : $label',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Étape 3 — Localisation + CGU
// ─────────────────────────────────────────────────────────────────────────────
class _Step3Location extends StatelessWidget {
  final TextEditingController quartierCtrl;
  final bool acceptTerms;
  final ValueChanged<bool?> onTermsChanged;

  const _Step3Location({
    required this.quartierCtrl,
    required this.acceptTerms,
    required this.onTermsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.location_on_rounded,
            title: 'Votre quartier',
            subtitle: 'Pour des alertes personnalisées',
            color: AppColors.neonGreen,
          ),
          const SizedBox(height: 24),
          _RegisterCard(
            child: Column(
              children: [
                _RegField(
                  controller: quartierCtrl,
                  label: 'Quartier favori',
                  hint: 'Ex: Bastos, Melen, Obili...',
                  icon: Icons.location_on_outlined,
                  validator: (v) =>
                  v == null || v.isEmpty ? 'Veuillez indiquer votre quartier' : null,
                ),
                const SizedBox(height: 16),
                // Bouton géolocalisation automatique
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.neonGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.neonGreen.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.my_location_rounded,
                            color: AppColors.neonGreen, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          'Utiliser ma position actuelle',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.neonGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Carte info alertes
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.electricAmber.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.electricAmber.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.notifications_active_rounded,
                    color: AppColors.electricAmber, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Vous recevrez des alertes pour les pannes dans un rayon de 500m autour de votre quartier.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Accepter les CGU
          GestureDetector(
            onTap: () => onTermsChanged(!acceptTerms),
            child: Row(
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: Checkbox(
                    value: acceptTerms,
                    onChanged: onTermsChanged,
                    activeColor: AppColors.electricAmber,
                    side: const BorderSide(color: AppColors.borderColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: AppColors.textSecondary),
                      children: [
                        const TextSpan(text: "J'accepte les "),
                        TextSpan(
                          text: "conditions d'utilisation",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.electricAmber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(text: ' et la '),
                        TextSpan(
                          text: 'politique de confidentialité',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.electricAmber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets partagés pour les champs et cartes
// ─────────────────────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RegisterCard extends StatelessWidget {
  final Widget child;
  const _RegisterCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _RegField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _RegField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: GoogleFonts.poppins(
          color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.deepSpace.withOpacity(0.4),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: AppColors.electricAmber, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.redCoral),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.redCoral, width: 1.5),
        ),
        labelStyle: GoogleFonts.poppins(
            color: AppColors.textSecondary, fontSize: 13),
        hintStyle:
        GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
      ),
    );
  }
}

class _AnimatedNextButton extends StatefulWidget {
  final bool isLoading;
  final bool isLastStep;
  final VoidCallback onTap;

  const _AnimatedNextButton({
    required this.isLoading,
    required this.isLastStep,
    required this.onTap,
  });

  @override
  State<_AnimatedNextButton> createState() => _AnimatedNextButtonState();
}

class _AnimatedNextButtonState extends State<_AnimatedNextButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.6).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) => Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          gradient: widget.isLastStep
              ? AppColors.greenGradient
              : AppColors.amberGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (widget.isLastStep
                  ? AppColors.neonGreen
                  : AppColors.electricAmber)
                  .withOpacity(_anim.value),
              blurRadius: 25,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: widget.onTap,
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2.5),
            )
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.isLastStep
                      ? "Créer mon compte"
                      : "Continuer",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  widget.isLastStep
                      ? Icons.check_rounded
                      : Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}