import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vigilight/app_colors.dart';
import 'package:vigilight/vigi_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  late AnimationController _waveCtrl;
  late Animation<double> _waveAnim;

  // Données simulées
  final List<_IncidentItem> _incidents = const [
    _IncidentItem(
      type: 'Coupure totale',
      quartier: 'Bastos',
      time: 'Il y a 5 min',
      votes: 12,
      severity: IncidentSeverity.critical,
      icon: Icons.power_off_rounded,
    ),
    _IncidentItem(
      type: 'Baisse de tension',
      quartier: 'Melen',
      time: 'Il y a 20 min',
      votes: 7,
      severity: IncidentSeverity.warning,
      icon: Icons.bolt_rounded,
    ),
    _IncidentItem(
      type: 'Câble au sol',
      quartier: 'Ngousso',
      time: 'Il y a 1h',
      votes: 24,
      severity: IncidentSeverity.danger,
      icon: Icons.warning_rounded,
    ),
    _IncidentItem(
      type: 'Transformateur bruyant',
      quartier: 'Omnisport',
      time: 'Il y a 2h',
      votes: 3,
      severity: IncidentSeverity.warning,
      icon: Icons.volume_up_rounded,
    ),
  ];

  final List<_ZoneStatus> _zones = const [
    _ZoneStatus(name: 'Bastos', status: 'Hors tension', color: AppColors.redCoral),
    _ZoneStatus(name: 'Melen', status: 'Opérationnel', color: AppColors.neonGreen),
    _ZoneStatus(name: 'Obili', status: 'En cours', color: AppColors.electricAmber),
    _ZoneStatus(name: 'Biyem-Assi', status: 'Opérationnel', color: AppColors.neonGreen),
    _ZoneStatus(name: 'Ngousso', status: 'Hors tension', color: AppColors.redCoral),
  ];

  @override
  void initState() {
    super.initState();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _waveAnim =
        Tween<double>(begin: 0, end: 1).animate(_waveCtrl);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _waveCtrl.dispose();
    super.dispose();
  }

  void _onSignaler() {
    HapticFeedback.heavyImpact();
    Navigator.pushNamed(context, '/report');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGridBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ── AppBar personnalisée ──────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    children: [
                      const VigiLogo(size: 44),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bonjour, Marie 👋',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '📍 Bastos, Yaoundé',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Badge notifications
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/notifications'),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceCard,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.borderColor),
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: AppColors.textPrimary,
                                size: 22,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: AppColors.redCoral,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Carte Civisme ────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: _CivismeCard(),
                ),
              ),

              // ── Bouton SOS central ───────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: _SOSButton(
                      pulseAnim: _pulseAnim,
                      waveAnim: _waveAnim,
                      onTap: _onSignaler,
                    ),
                  ),
                ),
              ),

              // ── Stats rapides ────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          label: 'Incidents actifs',
                          value: '8',
                          icon: Icons.bolt_rounded,
                          color: AppColors.electricAmber,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Zones affectées',
                          value: '3',
                          icon: Icons.location_on_rounded,
                          color: AppColors.redCoral,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          label: 'Équipes actives',
                          value: '2',
                          icon: Icons.engineering_rounded,
                          color: AppColors.neonGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Statut des zones ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Statut des zones',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/map'),
                        child: Text(
                          'Voir la carte',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.electricAmber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _zones.length,
                    itemBuilder: (_, i) => _ZoneChip(zone: _zones[i]),
                  ),
                ),
              ),

              // ── Incidents récents ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Incidents récents',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Tout voir',
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

              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (_, i) => Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                    child: _IncidentCard(incident: _incidents[i]),
                  ),
                  childCount: _incidents.length,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),

      // ── Bottom Navigation Bar ─────────────────────────────────────────
      bottomNavigationBar: _VigiBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (i) {
          setState(() => _selectedIndex = i);
          switch (i) {
            case 1:
              Navigator.pushNamed(context, '/map');
              break;
            case 2:
              Navigator.pushNamed(context, '/report');
              break;
            case 3:
              Navigator.pushNamed(context, '/notifications');
              break;
          }
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Carte de civisme / points
// ─────────────────────────────────────────────────────────────────────────────
class _CivismeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A2540), Color(0xFF0F1628)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.electricAmber.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricAmber.withOpacity(0.1),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.amberGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.electricAmber.withOpacity(0.4),
                  blurRadius: 15,
                )
              ],
            ),
            child: const Icon(Icons.star_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🏆 Score de Civisme',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '240 pts',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.electricAmber,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '3 signalements',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              Text(
                'ce mois',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bouton SOS avec animation pulsation et ondes
// ─────────────────────────────────────────────────────────────────────────────
class _SOSButton extends StatelessWidget {
  final Animation<double> pulseAnim;
  final Animation<double> waveAnim;
  final VoidCallback onTap;

  const _SOSButton({
    required this.pulseAnim,
    required this.waveAnim,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([pulseAnim, waveAnim]),
          builder: (_, __) => SizedBox(
            width: 200,
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Ondes concentriques animées
                ...List.generate(3, (i) {
                  final progress =
                  ((waveAnim.value - i * 0.33) % 1.0).clamp(0.0, 1.0);
                  return Opacity(
                    opacity: (1 - progress) * 0.5,
                    child: Container(
                      width: 100 + progress * 100,
                      height: 100 + progress * 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.electricAmber.withOpacity(0.6),
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }),

                // Bouton principal
                Transform.scale(
                  scale: pulseAnim.value,
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        gradient: AppColors.amberGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.electricAmber
                                .withOpacity(0.6),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.bolt_rounded,
                              color: Colors.white, size: 40),
                          Text(
                            'SIGNALER',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Appuyez pour signaler une panne',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Carte statistique
// ─────────────────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chip de zone
// ─────────────────────────────────────────────────────────────────────────────
class _ZoneChip extends StatelessWidget {
  final _ZoneStatus zone;
  const _ZoneChip({required this.zone});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border:
        Border.all(color: zone.color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
                color: zone.color, shape: BoxShape.circle),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                zone.name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                zone.status,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: zone.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Carte d'incident
// ─────────────────────────────────────────────────────────────────────────────
class _IncidentCard extends StatefulWidget {
  final _IncidentItem incident;
  const _IncidentCard({required this.incident});

  @override
  State<_IncidentCard> createState() => _IncidentCardState();
}

class _IncidentCardState extends State<_IncidentCard> {
  bool _voted = false;
  late int _votes;

  @override
  void initState() {
    super.initState();
    _votes = widget.incident.votes;
  }

  void _vote() {
    HapticFeedback.selectionClick();
    setState(() {
      _voted = !_voted;
      _votes += _voted ? 1 : -1;
    });
  }

  Color get _severityColor {
    switch (widget.incident.severity) {
      case IncidentSeverity.critical:
        return AppColors.electricAmber;
      case IncidentSeverity.warning:
        return AppColors.electricAmber.withOpacity(0.7);
      case IncidentSeverity.danger:
        return AppColors.redCoral;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: _severityColor.withOpacity(0.25), width: 1),
      ),
      child: Row(
        children: [
          // Icône
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _severityColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(widget.incident.icon,
                color: _severityColor, size: 22),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.incident.type,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        color: AppColors.textSecondary, size: 12),
                    Text(
                      ' ${widget.incident.quartier}',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const Text(' · ',
                        style: TextStyle(color: AppColors.textMuted)),
                    Text(
                      widget.incident.time,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bouton Moi aussi
          GestureDetector(
            onTap: _vote,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _voted
                    ? AppColors.electricAmber.withOpacity(0.2)
                    : AppColors.deepSpace,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _voted
                      ? AppColors.electricAmber
                      : AppColors.borderColor,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _voted ? Icons.thumb_up_rounded : Icons.thumb_up_outlined,
                    color: _voted
                        ? AppColors.electricAmber
                        : AppColors.textSecondary,
                    size: 16,
                  ),
                  Text(
                    '$_votes',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _voted
                          ? AppColors.electricAmber
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Navigation Bar personnalisée
// ─────────────────────────────────────────────────────────────────────────────
class _VigiBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _VigiBottomNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, Icons.home_outlined, 'Accueil'),
      (Icons.map_rounded, Icons.map_outlined, 'Carte'),
      (Icons.add_circle_rounded, Icons.add_circle_outline_rounded, 'Signaler'),
      (Icons.notifications_rounded, Icons.notifications_outlined, 'Alertes'),
      (Icons.person_rounded, Icons.person_outline_rounded, 'Profil'),
    ];

    return Container(
      height: 80 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: AppColors.navyCard,
        border: const Border(
            top: BorderSide(color: AppColors.borderColor, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final isSelected = i == selectedIndex;
            final isCenter = i == 2;

            if (isCenter) {
              return GestureDetector(
                onTap: () => onTap(i),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.amberGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.electricAmber.withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(items[i].$1, color: Colors.white, size: 26),
                ),
              );
            }

            return GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.electricAmber.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? items[i].$1 : items[i].$2,
                      color: isSelected
                          ? AppColors.electricAmber
                          : AppColors.textMuted,
                      size: 22,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      items[i].$3,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: isSelected
                            ? AppColors.electricAmber
                            : AppColors.textMuted,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Modèles de données
// ─────────────────────────────────────────────────────────────────────────────
enum IncidentSeverity { critical, warning, danger }

class _IncidentItem {
  final String type;
  final String quartier;
  final String time;
  final int votes;
  final IncidentSeverity severity;
  final IconData icon;

  const _IncidentItem({
    required this.type,
    required this.quartier,
    required this.time,
    required this.votes,
    required this.severity,
    required this.icon,
  });
}

class _ZoneStatus {
  final String name;
  final String status;
  final Color color;

  const _ZoneStatus({
    required this.name,
    required this.status,
    required this.color,
  });
}