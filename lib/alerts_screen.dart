import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vigilight/app_colors.dart';
import 'package:vigilight/vigi_logo.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// AlertsScreen — Alertes en temps réel (distinct des Notifications)
// ═══════════════════════════════════════════════════════════════════════════════
class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;
  String _selectedFilter = 'Toutes';

  final List<String> _filters = [
    'Toutes',
    'Critiques',
    'Avertissements',
    'En cours',
    'Résolues',
  ];

  final List<_AlertItem> _alerts = [
    _AlertItem(
      id: 'ALT-001',
      zone: 'Bastos · Yaoundé',
      region: 'Centre',
      title: 'Coupure totale de courant',
      description:
      'Panne généralisée sur le réseau HTA suite à un défaut de protection. Environ 4 200 foyers affectés. Les équipes ENEO sont mobilisées.',
      severity: AlertSeverity.critical,
      time: 'Il y a 12 min',
      duration: '~3h estimé',
      affectedCount: 4200,
      reportCount: 38,
      isResolved: false,
    ),
    _AlertItem(
      id: 'ALT-002',
      zone: 'Akwa · Douala',
      region: 'Littoral',
      title: 'Baisse de tension critique',
      description:
      'Tension mesurée à 160V au lieu de 220V. Risque élevé pour les appareils électroménagers. Évitez d\'utiliser les équipements sensibles.',
      severity: AlertSeverity.high,
      time: 'Il y a 28 min',
      duration: '~1h estimé',
      affectedCount: 1850,
      reportCount: 22,
      isResolved: false,
    ),
    _AlertItem(
      id: 'ALT-003',
      zone: 'Ngousso · Yaoundé',
      region: 'Centre',
      title: 'Câble HT tombé sur la chaussée',
      description:
      'DANGER VITAL : câble haute tension sectionné au sol. Ne pas s\'approcher à moins de 10 mètres. Pompiers et ENEO prévenus.',
      severity: AlertSeverity.critical,
      time: 'Il y a 5 min',
      duration: 'Intervention en cours',
      affectedCount: 620,
      reportCount: 14,
      isResolved: false,
    ),
    _AlertItem(
      id: 'ALT-004',
      zone: 'Bonamoussadi · Douala',
      region: 'Littoral',
      title: 'Coupure programmée ENEO',
      description:
      'Travaux de maintenance sur le réseau de distribution. Coupure planifiée de 08h à 14h. Préparez vos groupes électrogènes.',
      severity: AlertSeverity.planned,
      time: 'Demain 08h00',
      duration: '6h (planifié)',
      affectedCount: 3100,
      reportCount: 0,
      isResolved: false,
    ),
    _AlertItem(
      id: 'ALT-005',
      zone: 'Biyem-Assi · Yaoundé',
      region: 'Centre',
      title: 'Transformateur en panne',
      description:
      'Transformateur MT/BT hors service. Bruit anormal et fumée signalés. Zone délimitée. Remplacement en cours par les techniciens.',
      severity: AlertSeverity.high,
      time: 'Il y a 1h',
      duration: '~4h estimé',
      affectedCount: 980,
      reportCount: 17,
      isResolved: false,
    ),
    _AlertItem(
      id: 'ALT-006',
      zone: 'Deido · Douala',
      region: 'Littoral',
      title: 'Réseau rétabli',
      description:
      'La coupure signalée à 07h30 a été résolue. Le réseau est entièrement rétabli. Merci pour vos signalements citoyens !',
      severity: AlertSeverity.resolved,
      time: 'Il y a 2h',
      duration: 'Résolu en 1h45',
      affectedCount: 2200,
      reportCount: 29,
      isResolved: true,
    ),
    _AlertItem(
      id: 'ALT-007',
      zone: 'Bafoussam Centre',
      region: 'Ouest',
      title: 'Clignotements de courant',
      description:
      'Micro-coupures répétées toutes les 15 à 20 minutes depuis 6h. Perturbations sur les équipements informatiques. Surveillance active.',
      severity: AlertSeverity.warning,
      time: 'Il y a 45 min',
      duration: 'En observation',
      affectedCount: 740,
      reportCount: 11,
      isResolved: false,
    ),
    _AlertItem(
      id: 'ALT-008',
      zone: 'Garoua Centre',
      region: 'Nord',
      title: 'Poteau incliné dangereux',
      description:
      'Poteau électrique fortement incliné après les pluies de la nuit. Risque de chute imminent. Zone sécurisée par la police municipale.',
      severity: AlertSeverity.high,
      time: 'Il y a 20 min',
      duration: 'Remplacement prévu',
      affectedCount: 410,
      reportCount: 8,
      isResolved: false,
    ),
  ];

  List<_AlertItem> get _filteredAlerts {
    if (_selectedFilter == 'Toutes') return _alerts;
    return _alerts.where((a) {
      switch (_selectedFilter) {
        case 'Critiques':
          return a.severity == AlertSeverity.critical;
        case 'Avertissements':
          return a.severity == AlertSeverity.warning ||
              a.severity == AlertSeverity.high;
        case 'En cours':
          return !a.isResolved && a.severity != AlertSeverity.planned;
        case 'Résolues':
          return a.isResolved;
        default:
          return true;
      }
    }).toList();
  }

  int get _criticalCount =>
      _alerts.where((a) => a.severity == AlertSeverity.critical && !a.isResolved).length;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepSpace,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStatusBanner(),
            _buildFilterRow(),
            Expanded(
              child: _filteredAlerts.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                itemCount: _filteredAlerts.length,
                itemBuilder: (context, i) => _AlertCard(
                  alert: _filteredAlerts[i],
                  pulseAnim: _pulseAnim,
                  onTap: () => _showAlertDetail(_filteredAlerts[i]),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/report'),
        backgroundColor: AppColors.electricAmber,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_alert_rounded),
        label: Text(
          'Signaler',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.charcoal,
        border: Border(bottom: BorderSide(color: AppColors.borderColor)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  color: AppColors.textPrimary, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⚡ Alertes Réseau',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Pannes & incidents en temps réel',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Badge alertes critiques
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, __) => Opacity(
              opacity: _pulseAnim.value,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.redCoral.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border:
                  Border.all(color: AppColors.redCoral.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.redCoral,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$_criticalCount Critique${_criticalCount > 1 ? 's' : ''}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.redCoral,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner() {
    final active = _alerts.where((a) => !a.isResolved).length;
    final resolved = _alerts.where((a) => a.isResolved).length;
    final totalAffected =
    _alerts.where((a) => !a.isResolved).fold(0, (s, a) => s + a.affectedCount);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.redCoral.withOpacity(0.12),
            AppColors.electricAmber.withOpacity(0.08),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.redCoral.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatChip(
              value: '$active',
              label: 'Actives',
              color: AppColors.redCoral,
              icon: Icons.warning_amber_rounded,
            ),
          ),
          _vDivider(),
          Expanded(
            child: _StatChip(
              value: '$resolved',
              label: 'Résolues',
              color: AppColors.neonGreen,
              icon: Icons.check_circle_rounded,
            ),
          ),
          _vDivider(),
          Expanded(
            child: _StatChip(
              value: _formatNumber(totalAffected),
              label: 'Affectés',
              color: AppColors.cyanBlue,
              icon: Icons.people_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
    width: 1,
    height: 40,
    color: AppColors.borderColor,
    margin: const EdgeInsets.symmetric(horizontal: 4),
  );

  String _formatNumber(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
      child: SizedBox(
        height: 36,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          itemBuilder: (_, i) {
            final isSelected = _filters[i] == _selectedFilter;
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedFilter = _filters[i]);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(right: 8),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.amberGradient : null,
                  color: isSelected ? null : AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : AppColors.borderColor,
                  ),
                ),
                child: Text(
                  _filters[i],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.black : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline_rounded,
              color: AppColors.neonGreen.withOpacity(0.5), size: 72),
          const SizedBox(height: 16),
          Text(
            'Aucune alerte dans cette catégorie',
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showAlertDetail(_AlertItem alert) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AlertDetailSheet(alert: alert),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Carte d'alerte
// ─────────────────────────────────────────────────────────────────────────────
class _AlertCard extends StatelessWidget {
  final _AlertItem alert;
  final Animation<double> pulseAnim;
  final VoidCallback onTap;

  const _AlertCard({
    required this.alert,
    required this.pulseAnim,
    required this.onTap,
  });

  Color get _color {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return AppColors.redCoral;
      case AlertSeverity.high:
        return AppColors.electricAmber;
      case AlertSeverity.warning:
        return AppColors.amberLight;
      case AlertSeverity.planned:
        return AppColors.violet;
      case AlertSeverity.resolved:
        return AppColors.neonGreen;
    }
  }

  IconData get _icon {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return Icons.dangerous_rounded;
      case AlertSeverity.high:
        return Icons.warning_rounded;
      case AlertSeverity.warning:
        return Icons.info_rounded;
      case AlertSeverity.planned:
        return Icons.schedule_rounded;
      case AlertSeverity.resolved:
        return Icons.check_circle_rounded;
    }
  }

  String get _severityLabel {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return 'CRITIQUE';
      case AlertSeverity.high:
        return 'ÉLEVÉ';
      case AlertSeverity.warning:
        return 'ATTENTION';
      case AlertSeverity.planned:
        return 'PLANIFIÉ';
      case AlertSeverity.resolved:
        return 'RÉSOLU';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.navyCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: alert.severity == AlertSeverity.critical
                ? _color.withOpacity(0.4)
                : AppColors.borderColor,
          ),
          boxShadow: alert.severity == AlertSeverity.critical
              ? [
            BoxShadow(
              color: _color.withOpacity(0.12),
              blurRadius: 16,
              spreadRadius: 1,
            )
          ]
              : null,
        ),
        child: Column(
          children: [
            // Header coloré
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: BoxDecoration(
                color: _color.withOpacity(0.08),
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(18)),
                border: Border(
                    bottom:
                    BorderSide(color: _color.withOpacity(0.15), width: 1)),
              ),
              child: Row(
                children: [
                  // Icône avec pulse si critique
                  alert.severity == AlertSeverity.critical
                      ? AnimatedBuilder(
                    animation: pulseAnim,
                    builder: (_, __) => Opacity(
                      opacity: pulseAnim.value,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_icon, color: _color, size: 18),
                      ),
                    ),
                  )
                      : Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_icon, color: _color, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          alert.zone,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _severityLabel,
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: _color,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alert.time,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Corps
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.access_time_rounded,
                        label: alert.duration,
                        color: _color,
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.people_rounded,
                        label: '${_fmtNum(alert.affectedCount)} affectés',
                        color: AppColors.cyanBlue,
                      ),
                      const Spacer(),
                      if (alert.reportCount > 0)
                        _InfoChip(
                          icon: Icons.flag_rounded,
                          label: '${alert.reportCount} signalements',
                          color: AppColors.textMuted,
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

  String _fmtNum(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 12),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final IconData icon;
  const _StatChip(
      {required this.value,
        required this.label,
        required this.color,
        required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom sheet détail alerte
// ─────────────────────────────────────────────────────────────────────────────
class _AlertDetailSheet extends StatelessWidget {
  final _AlertItem alert;
  const _AlertDetailSheet({required this.alert});

  Color get _color {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return AppColors.redCoral;
      case AlertSeverity.high:
        return AppColors.electricAmber;
      case AlertSeverity.warning:
        return AppColors.amberLight;
      case AlertSeverity.planned:
        return AppColors.violet;
      case AlertSeverity.resolved:
        return AppColors.neonGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.navyCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ID + Région
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  alert.id,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cyanBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Région ${alert.region}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cyanBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            alert.title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            alert.zone,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Séparateur
          Divider(color: AppColors.borderColor),
          const SizedBox(height: 12),

          Text(
            alert.description,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),

          // Stats
          Row(
            children: [
              _DetailStat(
                icon: Icons.people_rounded,
                value: '${alert.affectedCount}',
                label: 'Foyers affectés',
                color: AppColors.cyanBlue,
              ),
              const SizedBox(width: 12),
              _DetailStat(
                icon: Icons.flag_rounded,
                value: '${alert.reportCount}',
                label: 'Signalements',
                color: AppColors.electricAmber,
              ),
              const SizedBox(width: 12),
              _DetailStat(
                icon: Icons.access_time_rounded,
                value: alert.duration,
                label: 'Durée estimée',
                color: _color,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Actions
          if (!alert.isResolved) ...[
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.thumb_up_rounded, size: 18),
                label: Text(
                  'Je confirme cette panne',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.share_rounded, size: 16),
                label: Text(
                  'Partager cette alerte',
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ] else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.neonGreen.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.neonGreen, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    'Panne résolue — Merci à tous !',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neonGreen,
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

class _DetailStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _DetailStat(
      {required this.icon,
        required this.value,
        required this.label,
        required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Modèles
// ─────────────────────────────────────────────────────────────────────────────
enum AlertSeverity { critical, high, warning, planned, resolved }

class _AlertItem {
  final String id;
  final String zone;
  final String region;
  final String title;
  final String description;
  final AlertSeverity severity;
  final String time;
  final String duration;
  final int affectedCount;
  final int reportCount;
  final bool isResolved;

  const _AlertItem({
    required this.id,
    required this.zone,
    required this.region,
    required this.title,
    required this.description,
    required this.severity,
    required this.time,
    required this.duration,
    required this.affectedCount,
    required this.reportCount,
    required this.isResolved,
  });
}