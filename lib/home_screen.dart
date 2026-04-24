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
  String _currentLang = 'FR';

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  late AnimationController _waveCtrl;
  late Animation<double> _waveAnim;

  final int _notifCount = 3;

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

  final List<Map<String, String>> _languages = [
    {'code': 'FR', 'label': 'Français'},
    {'code': 'EN', 'label': 'English'},
    {'code': 'AR', 'label': 'العربية'},
    {'code': 'ES', 'label': 'Español'},
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
    _waveCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _waveAnim = Tween<double>(begin: 0, end: 1).animate(_waveCtrl);
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

  void _showLanguagePicker() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.navyCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 20),
            Text('Choisir la langue', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            ..._languages.map((lang) => GestureDetector(
              onTap: () {
                setState(() => _currentLang = lang['code']!);
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: _currentLang == lang['code'] ? AppColors.electricAmber.withOpacity(0.15) : AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _currentLang == lang['code'] ? AppColors.electricAmber : AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    Text(lang['label']!, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                    const Spacer(),
                    if (_currentLang == lang['code'])
                      const Icon(Icons.check_circle_rounded, color: AppColors.electricAmber, size: 20),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _onNavTap(int index) {
    HapticFeedback.selectionClick();
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    final routes = ['/home', '/map', '/report', '/alerts', '/profile'];
    if (index != 0) Navigator.pushNamed(context, routes[index]);
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
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  decoration: BoxDecoration(
                    color: AppColors.charcoal.withOpacity(0.95),
                    border: const Border(bottom: BorderSide(color: AppColors.borderColor)),
                  ),
                  child: Row(
                    children: [
                      // Langue
                      GestureDetector(
                        onTap: _showLanguagePicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCard,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.language_rounded, color: AppColors.textSecondary, size: 16),
                              const SizedBox(width: 4),
                              Text(_currentLang, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                              const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textMuted, size: 16),
                            ],
                          ),
                        ),
                      ),

                      // Logo centré
                      Expanded(
                        child: Center(child: Image.asset('assets/logo/VigiLight5Bg.png', height: 60, fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const VigiLogo(size: 40, showText: true),
                        )),
                      ),

                      // Notifications
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/notifications'),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceCard,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.borderColor),
                              ),
                              child: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 22),
                            ),
                            if (_notifCount > 0)
                              Positioned(
                                top: -4,
                                right: -4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(color: AppColors.redCoral, shape: BoxShape.circle),
                                  constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                                  child: Text(
                                    '$_notifCount',
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Bannière Hero Cameroun ────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _CamerounHeroBanner(),
                ),
              ),

              // ── Salutation utilisateur ────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: AppColors.amberGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_rounded, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bonjour, Marie 👋', style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded, color: AppColors.cyanBlue, size: 13),
                                const SizedBox(width: 2),
                                Text('Bastos, Yaoundé', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/profile'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCard,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppColors.electricAmber, size: 14),
                              const SizedBox(width: 4),
                              Text('250 pts', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.electricAmber)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Bouton SOS central ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: _SOSButton(pulseAnim: _pulseAnim, waveAnim: _waveAnim, onTap: _onSignaler),
                  ),
                ),
              ),

              // ── Stats rapides ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(child: _StatCard(label: 'Incidents actifs', value: '8', icon: Icons.bolt_rounded, color: AppColors.electricAmber)),
                      const SizedBox(width: 10),
                      Expanded(child: _StatCard(label: 'Zones affectées', value: '3', icon: Icons.location_on_rounded, color: AppColors.redCoral)),
                      const SizedBox(width: 10),
                      Expanded(child: _StatCard(label: 'Équipes actives', value: '2', icon: Icons.engineering_rounded, color: AppColors.neonGreen)),
                    ],
                  ),
                ),
              ),

              // ── Carte Civisme ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _CivismeCard(),
                ),
              ),

              // ── Statut des zones ──────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ShaderMask(
                            shaderCallback: (b) => AppColors.goldGradient.createShader(b),
                            child: Text('⚡ Statut des zones', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/map'),
                            child: Text('Voir carte', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.cyanBlue, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _zones.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (_, i) => _ZoneChip(zone: _zones[i]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Incidents récents ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Row(
                    children: [
                      Text('Incidents récents', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/incidents'),
                        child: Text('Tout voir', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.cyanBlue, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (_, i) => Padding(
                    padding: EdgeInsets.fromLTRB(16, i == 0 ? 12 : 6, 16, 6),
                    child: _IncidentCard(incident: _incidents[i]),
                  ),
                  childCount: _incidents.length,
                ),
              ),

              // ── Accès rapide ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Accès rapide', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _QuickActionCard(icon: Icons.map_rounded, label: 'Carte\ninteractive', color: AppColors.cyanBlue, onTap: () => Navigator.pushNamed(context, '/map'))),
                          const SizedBox(width: 10),
                          Expanded(child: _QuickActionCard(icon: Icons.history_rounded, label: 'Mes\nsignalements', color: AppColors.violet, onTap: () => Navigator.pushNamed(context, '/incidents'))),
                          const SizedBox(width: 10),
                          Expanded(child: _QuickActionCard(icon: Icons.campaign_rounded, label: 'Alertes\nactives', color: AppColors.redCoral, onTap: () => Navigator.pushNamed(context, '/alerts'))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _VigiBottomNavBar(selectedIndex: _selectedIndex, onTap: _onNavTap),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bannière Hero Cameroun
// ─────────────────────────────────────────────────────────────────────────────
class _CamerounHeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF006B3F), Color(0xFF0A0A0A), Color(0xFFCE1126)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          // Drapeau Cameroun
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Column(
                children: [
                  Expanded(child: Container(color: const Color(0xFF006B3F))),
                  Expanded(child: Container(
                    color: const Color(0xFFCE1126),
                    child: const Center(child: Text('★', style: TextStyle(color: Color(0xFFFFD700), fontSize: 16, fontWeight: FontWeight.bold))),
                  )),
                  Expanded(child: Container(color: const Color(0xFFFFD700))),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cameroun 🇨🇲', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
                Text('Réseau électrique national · Yaoundé', style: GoogleFonts.poppins(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.redCoral.withOpacity(0.2), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.redCoral.withOpacity(0.5))),
                child: Text('3 alertes', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.redCoral)),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.neonGreen.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                child: Text('En ligne', style: GoogleFonts.poppins(fontSize: 10, color: AppColors.neonGreen)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bouton SOS
// ─────────────────────────────────────────────────────────────────────────────
class _SOSButton extends StatelessWidget {
  final Animation<double> pulseAnim;
  final Animation<double> waveAnim;
  final VoidCallback onTap;

  const _SOSButton({required this.pulseAnim, required this.waveAnim, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([pulseAnim, waveAnim]),
      builder: (_, __) => GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ...List.generate(3, (i) {
                final progress = ((waveAnim.value - i * 0.33) % 1.0).clamp(0.0, 1.0);
                return Opacity(
                  opacity: (1 - progress) * 0.4,
                  child: Container(
                    width: 100 + progress * 90,
                    height: 100 + progress * 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.electricAmber.withOpacity(0.6), width: 2),
                    ),
                  ),
                );
              }),
              Transform.scale(
                scale: pulseAnim.value,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: AppColors.amberGradient,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.electricAmber.withOpacity(0.5), blurRadius: 30, spreadRadius: 5)],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.campaign_rounded, color: Colors.black, size: 36),
                      Text('SIGNALER', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black, letterSpacing: 1.2)),
                    ],
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
// Stat Card
// ─────────────────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
          Text(label, style: GoogleFonts.poppins(fontSize: 9, color: AppColors.textSecondary), textAlign: TextAlign.center, maxLines: 2),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Civisme Card
// ─────────────────────────────────────────────────────────────────────────────
class _CivismeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF1C1700), Color(0xFF222222)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.electricAmber.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events_rounded, color: AppColors.electricAmber, size: 20),
              const SizedBox(width: 8),
              Text('Score de Civisme', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.electricAmber.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                child: Text('Niveau 3 · Citoyen Actif', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.electricAmber)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('250', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.electricAmber)),
              Text(' / 500 pts', style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary)),
              const Spacer(),
              Text('+15 pts cette semaine 🔥', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.neonGreen, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.5,
              backgroundColor: AppColors.borderColor,
              valueColor: const AlwaysStoppedAnimation(AppColors.electricAmber),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _CivismeStat(label: 'Signalements', value: '12'),
              _CivismeStat(label: 'Confirmations', value: '34'),
              _CivismeStat(label: 'Badges', value: '3'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CivismeStat extends StatelessWidget {
  final String label;
  final String value;
  const _CivismeStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        Text(label, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Zone Chip
// ─────────────────────────────────────────────────────────────────────────────
class _ZoneChip extends StatelessWidget {
  final _ZoneStatus zone;
  const _ZoneChip({required this.zone});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: zone.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: zone.color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: zone.color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Expanded(child: Text(zone.name, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 4),
          Text(zone.status, style: GoogleFonts.poppins(fontSize: 11, color: zone.color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Incident Card
// ─────────────────────────────────────────────────────────────────────────────
class _IncidentCard extends StatefulWidget {
  final _IncidentItem incident;
  const _IncidentCard({required this.incident});

  @override
  State<_IncidentCard> createState() => _IncidentCardState();
}

class _IncidentCardState extends State<_IncidentCard> {
  late int _votes;
  bool _voted = false;

  @override
  void initState() {
    super.initState();
    _votes = widget.incident.votes;
  }

  void _vote() {
    HapticFeedback.selectionClick();
    setState(() {
      if (_voted) {
        _votes--;
      } else {
        _votes++;
      }
      _voted = !_voted;
    });
  }

  Color get _severityColor {
    switch (widget.incident.severity) {
      case IncidentSeverity.critical:
        return AppColors.electricAmber;
      case IncidentSeverity.warning:
        return AppColors.amberOrange;
      case IncidentSeverity.danger:
        return AppColors.redCoral;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _severityColor.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _severityColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(widget.incident.icon, color: _severityColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.incident.type, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: AppColors.textSecondary, size: 12),
                    Text(' ${widget.incident.quartier}', style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                    Text(' · ', style: const TextStyle(color: AppColors.textMuted)),
                    Text(widget.incident.time, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _vote,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: _voted ? AppColors.electricAmber.withOpacity(0.2) : AppColors.deepSpace,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _voted ? AppColors.electricAmber : AppColors.borderColor),
              ),
              child: Column(
                children: [
                  Icon(_voted ? Icons.thumb_up_rounded : Icons.thumb_up_outlined, color: _voted ? AppColors.electricAmber : AppColors.textSecondary, size: 16),
                  Text('$_votes', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: _voted ? AppColors.electricAmber : AppColors.textSecondary)),
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
// Quick Action Card
// ─────────────────────────────────────────────────────────────────────────────
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondary, height: 1.3), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Navigation Bar
// ─────────────────────────────────────────────────────────────────────────────
class _VigiBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _VigiBottomNavBar({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, Icons.home_outlined, 'Accueil'),
      (Icons.map_rounded, Icons.map_outlined, 'Carte'),
      (Icons.add_circle_rounded, Icons.add_circle_outline_rounded, 'Signaler'),
      (Icons.campaign_rounded, Icons.campaign_outlined, 'Alertes'),
      (Icons.person_rounded, Icons.person_outline_rounded, 'Profil'),
    ];

    return Container(
      height: 80 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: AppColors.navyCard,
        border: const Border(top: BorderSide(color: AppColors.borderColor)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)],
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
                    boxShadow: [BoxShadow(color: AppColors.electricAmber.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 4))],
                  ),
                  child: Icon(items[i].$1, color: Colors.white, size: 26),
                ),
              );
            }
            return GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.electricAmber.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isSelected ? items[i].$1 : items[i].$2, color: isSelected ? AppColors.electricAmber : AppColors.textMuted, size: 22),
                    const SizedBox(height: 2),
                    Text(items[i].$3, style: GoogleFonts.poppins(fontSize: 10, color: isSelected ? AppColors.electricAmber : AppColors.textMuted, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
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
// Modèles
// ─────────────────────────────────────────────────────────────────────────────
enum IncidentSeverity { critical, warning, danger }

class _IncidentItem {
  final String type;
  final String quartier;
  final String time;
  final int votes;
  final IncidentSeverity severity;
  final IconData icon;

  const _IncidentItem({required this.type, required this.quartier, required this.time, required this.votes, required this.severity, required this.icon});
}

class _ZoneStatus {
  final String name;
  final String status;
  final Color color;

  const _ZoneStatus({required this.name, required this.status, required this.color});
}