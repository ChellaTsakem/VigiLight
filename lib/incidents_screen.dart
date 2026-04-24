import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vigilight/app_colors.dart';
import 'package:vigilight/vigi_logo.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// IncidentsScreen — Historique des incidents récents
// ═══════════════════════════════════════════════════════════════════════════════
class IncidentsScreen extends StatefulWidget {
  const IncidentsScreen({super.key});

  @override
  State<IncidentsScreen> createState() => _IncidentsScreenState();
}

class _IncidentsScreenState extends State<IncidentsScreen>
    with TickerProviderStateMixin {
  late TabController _tabCtrl;
  String _sortBy = 'Récents';
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  final List<_IncidentItem> _incidents = [
    _IncidentItem(
      id: 'INC-2025-0847',
      title: 'Coupure totale de courant',
      location: 'Bastos, Yaoundé',
      region: 'Centre',
      type: IncidentType.blackout,
      status: IncidentStatus.inProgress,
      reportedAt: 'Aujourd\'hui, 09:42',
      resolvedAt: null,
      duration: '2h 18min',
      affectedCount: 4200,
      confirmedBy: 38,
      reportedBy: 'Jeanne K.',
      description:
      'Panne généralisée sur l\'ensemble du quartier Bastos. Aucun courant depuis 09h42. Les groupes électrogènes tournent chez les résidents les mieux équipés.',
      steps: [
        _IncidentStep(
          label: 'Signalement reçu',
          time: '09:42',
          isDone: true,
          icon: Icons.flag_rounded,
        ),
        _IncidentStep(
          label: 'Confirmé par la communauté',
          time: '09:58',
          isDone: true,
          icon: Icons.people_rounded,
        ),
        _IncidentStep(
          label: 'Équipe ENEO mobilisée',
          time: '10:15',
          isDone: true,
          icon: Icons.engineering_rounded,
        ),
        _IncidentStep(
          label: 'Intervention en cours',
          time: 'En cours',
          isDone: false,
          icon: Icons.build_rounded,
        ),
        _IncidentStep(
          label: 'Réseau rétabli',
          time: '--',
          isDone: false,
          icon: Icons.check_circle_rounded,
        ),
      ],
    ),
    _IncidentItem(
      id: 'INC-2025-0846',
      title: 'Câble haute tension au sol',
      location: 'Ngousso, Yaoundé',
      region: 'Centre',
      type: IncidentType.dangerCable,
      status: IncidentStatus.resolved,
      reportedAt: 'Aujourd\'hui, 07:15',
      resolvedAt: 'Aujourd\'hui, 09:00',
      duration: '1h 45min',
      affectedCount: 620,
      confirmedBy: 14,
      reportedBy: 'Paul M.',
      description:
      'Câble sectionné tombé sur la route suite à une forte pluie. Zone sécurisée par la police. Techniciens ENEO intervenus rapidement.',
      steps: [
        _IncidentStep(
            label: 'Signalement reçu',
            time: '07:15',
            isDone: true,
            icon: Icons.flag_rounded),
        _IncidentStep(
            label: 'Confirmé par la communauté',
            time: '07:22',
            isDone: true,
            icon: Icons.people_rounded),
        _IncidentStep(
            label: 'Équipe ENEO mobilisée',
            time: '07:45',
            isDone: true,
            icon: Icons.engineering_rounded),
        _IncidentStep(
            label: 'Intervention en cours',
            time: '08:10',
            isDone: true,
            icon: Icons.build_rounded),
        _IncidentStep(
            label: 'Réseau rétabli',
            time: '09:00',
            isDone: true,
            icon: Icons.check_circle_rounded),
      ],
    ),
    _IncidentItem(
      id: 'INC-2025-0845',
      title: 'Baisse de tension sévère',
      location: 'Akwa, Douala',
      region: 'Littoral',
      type: IncidentType.lowVoltage,
      status: IncidentStatus.monitoring,
      reportedAt: 'Hier, 18:30',
      resolvedAt: null,
      duration: '+14h',
      affectedCount: 1850,
      confirmedBy: 22,
      reportedBy: 'Arlette N.',
      description:
      'Tension instable oscillant entre 150V et 190V depuis le soir. Plusieurs appareils électroménagers endommagés. ENEO en cours d\'investigation.',
      steps: [
        _IncidentStep(
            label: 'Signalement reçu',
            time: '18:30',
            isDone: true,
            icon: Icons.flag_rounded),
        _IncidentStep(
            label: 'Confirmé par la communauté',
            time: '18:55',
            isDone: true,
            icon: Icons.people_rounded),
        _IncidentStep(
            label: 'Équipe ENEO mobilisée',
            time: '20:00',
            isDone: true,
            icon: Icons.engineering_rounded),
        _IncidentStep(
            label: 'Intervention en cours',
            time: 'En cours',
            isDone: false,
            icon: Icons.build_rounded),
        _IncidentStep(
            label: 'Réseau rétabli',
            time: '--',
            isDone: false,
            icon: Icons.check_circle_rounded),
      ],
    ),
    _IncidentItem(
      id: 'INC-2025-0844',
      title: 'Transformateur en feu',
      location: 'Biyem-Assi, Yaoundé',
      region: 'Centre',
      type: IncidentType.transformer,
      status: IncidentStatus.resolved,
      reportedAt: 'Hier, 14:10',
      resolvedAt: 'Hier, 18:30',
      duration: '4h 20min',
      affectedCount: 980,
      confirmedBy: 17,
      reportedBy: 'Rodrigue B.',
      description:
      'Transformateur MT/BT en feu avec dégagement de fumée. Pompiers et ENEO mobilisés. Transformateur remplacé et réseau rétabli le soir.',
      steps: [
        _IncidentStep(
            label: 'Signalement reçu',
            time: '14:10',
            isDone: true,
            icon: Icons.flag_rounded),
        _IncidentStep(
            label: 'Confirmé par la communauté',
            time: '14:18',
            isDone: true,
            icon: Icons.people_rounded),
        _IncidentStep(
            label: 'Équipe ENEO mobilisée',
            time: '14:45',
            isDone: true,
            icon: Icons.engineering_rounded),
        _IncidentStep(
            label: 'Intervention en cours',
            time: '15:00',
            isDone: true,
            icon: Icons.build_rounded),
        _IncidentStep(
            label: 'Réseau rétabli',
            time: '18:30',
            isDone: true,
            icon: Icons.check_circle_rounded),
      ],
    ),
    _IncidentItem(
      id: 'INC-2025-0843',
      title: 'Poteau incliné dangereux',
      location: 'Garoua Centre',
      region: 'Nord',
      type: IncidentType.pole,
      status: IncidentStatus.reported,
      reportedAt: 'Aujourd\'hui, 11:05',
      resolvedAt: null,
      duration: '1h',
      affectedCount: 410,
      confirmedBy: 8,
      reportedBy: 'Ibrahim A.',
      description:
      'Poteau électrique fortement incliné suite aux pluies. Risque de chute. Zone délimitée par la police.',
      steps: [
        _IncidentStep(
            label: 'Signalement reçu',
            time: '11:05',
            isDone: true,
            icon: Icons.flag_rounded),
        _IncidentStep(
            label: 'Confirmé par la communauté',
            time: '11:20',
            isDone: true,
            icon: Icons.people_rounded),
        _IncidentStep(
            label: 'Équipe ENEO mobilisée',
            time: 'En attente',
            isDone: false,
            icon: Icons.engineering_rounded),
        _IncidentStep(
            label: 'Intervention en cours',
            time: '--',
            isDone: false,
            icon: Icons.build_rounded),
        _IncidentStep(
            label: 'Réseau rétabli',
            time: '--',
            isDone: false,
            icon: Icons.check_circle_rounded),
      ],
    ),
    _IncidentItem(
      id: 'INC-2025-0842',
      title: 'Coupure programmée ENEO',
      location: 'Bonamoussadi, Douala',
      region: 'Littoral',
      type: IncidentType.planned,
      status: IncidentStatus.resolved,
      reportedAt: 'Hier, 08:00',
      resolvedAt: 'Hier, 14:05',
      duration: '6h 05min',
      affectedCount: 3100,
      confirmedBy: 0,
      reportedBy: 'ENEO',
      description:
      'Travaux de maintenance sur le réseau de distribution haute tension. Coupure planifiée et communiquée à l\'avance.',
      steps: [
        _IncidentStep(
            label: 'Signalement reçu',
            time: '08:00',
            isDone: true,
            icon: Icons.flag_rounded),
        _IncidentStep(
            label: 'Confirmé par la communauté',
            time: '08:00',
            isDone: true,
            icon: Icons.people_rounded),
        _IncidentStep(
            label: 'Équipe ENEO mobilisée',
            time: '08:00',
            isDone: true,
            icon: Icons.engineering_rounded),
        _IncidentStep(
            label: 'Intervention en cours',
            time: '08:10',
            isDone: true,
            icon: Icons.build_rounded),
        _IncidentStep(
            label: 'Réseau rétabli',
            time: '14:05',
            isDone: true,
            icon: Icons.check_circle_rounded),
      ],
    ),
  ];

  List<_IncidentItem> get _filteredIncidents {
    List<_IncidentItem> list = _incidents;
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((inc) =>
      inc.title
          .toLowerCase()
          .contains(_searchQuery.toLowerCase()) ||
          inc.location
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          inc.region
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return list;
  }

  List<_IncidentItem> get _activeIncidents => _filteredIncidents
      .where((i) => i.status != IncidentStatus.resolved)
      .toList();

  List<_IncidentItem> get _resolvedIncidents => _filteredIncidents
      .where((i) => i.status == IncidentStatus.resolved)
      .toList();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
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
            _buildSearchBar(),
            _buildStatsRow(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  _buildList(_filteredIncidents),
                  _buildList(_activeIncidents),
                  _buildList(_resolvedIncidents),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/report'),
        backgroundColor: AppColors.electricAmber,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Signaler un incident',
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
                  '🗂️ Incidents Récents',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Historique & suivi des pannes signalées',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Bouton tri
          GestureDetector(
            onTap: _showSortOptions,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sort_rounded,
                      color: AppColors.textSecondary, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _sortBy,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textSecondary,
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Icon(Icons.search_rounded,
                  color: AppColors.textMuted, size: 20),
            ),
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: GoogleFonts.poppins(
                    color: AppColors.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Rechercher un quartier, ville...',
                  hintStyle: GoogleFonts.poppins(
                      color: AppColors.textMuted, fontSize: 13),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  filled: false,
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchCtrl.clear();
                  setState(() => _searchQuery = '');
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child:
                  Icon(Icons.close_rounded, color: AppColors.textMuted, size: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    final total = _incidents.length;
    final active =
        _incidents.where((i) => i.status != IncidentStatus.resolved).length;
    final resolved =
        _incidents.where((i) => i.status == IncidentStatus.resolved).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          _StatBadge(
            label: 'Total',
            value: '$total',
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          _StatBadge(
            label: 'En cours',
            value: '$active',
            color: AppColors.electricAmber,
          ),
          const SizedBox(width: 8),
          _StatBadge(
            label: 'Résolus',
            value: '$resolved',
            color: AppColors.neonGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabCtrl,
        indicator: BoxDecoration(
          gradient: AppColors.amberGradient,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.poppins(
            fontSize: 12, fontWeight: FontWeight.w700),
        unselectedLabelStyle:
        GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
        labelColor: Colors.black,
        unselectedLabelColor: AppColors.textMuted,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: 'Tous (${_filteredIncidents.length})'),
          Tab(text: 'En cours (${_activeIncidents.length})'),
          Tab(text: 'Résolus (${_resolvedIncidents.length})'),
        ],
      ),
    );
  }

  Widget _buildList(List<_IncidentItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded,
                color: AppColors.textMuted.withOpacity(0.4), size: 64),
            const SizedBox(height: 12),
            Text(
              'Aucun incident trouvé',
              style: GoogleFonts.poppins(
                  fontSize: 15, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      itemCount: items.length,
      itemBuilder: (context, i) => _IncidentCard(
        incident: items[i],
        onTap: () => _showDetail(items[i]),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.navyCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trier par',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...['Récents', 'Plus anciens', 'Plus de confirmations', 'Zone affectée']
                .map(
                  (opt) => ListTile(
                title: Text(
                  opt,
                  style: GoogleFonts.poppins(
                    color: _sortBy == opt
                        ? AppColors.electricAmber
                        : AppColors.textPrimary,
                    fontWeight: _sortBy == opt
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
                trailing: _sortBy == opt
                    ? const Icon(Icons.check_rounded,
                    color: AppColors.electricAmber)
                    : null,
                onTap: () {
                  setState(() => _sortBy = opt);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(_IncidentItem item) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _IncidentDetailSheet(incident: item),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Carte d'incident
// ─────────────────────────────────────────────────────────────────────────────
class _IncidentCard extends StatelessWidget {
  final _IncidentItem incident;
  final VoidCallback onTap;
  const _IncidentCard({required this.incident, required this.onTap});

  Color get _typeColor {
    switch (incident.type) {
      case IncidentType.blackout:
        return AppColors.electricAmber;
      case IncidentType.lowVoltage:
        return AppColors.cyanBlue;
      case IncidentType.dangerCable:
        return AppColors.redCoral;
      case IncidentType.transformer:
        return AppColors.redCoral;
      case IncidentType.pole:
        return AppColors.statusWarning;
      case IncidentType.planned:
        return AppColors.violet;
      case IncidentType.other:
        return AppColors.textMuted;
    }
  }

  IconData get _typeIcon {
    switch (incident.type) {
      case IncidentType.blackout:
        return Icons.power_off_rounded;
      case IncidentType.lowVoltage:
        return Icons.bolt_rounded;
      case IncidentType.dangerCable:
        return Icons.warning_rounded;
      case IncidentType.transformer:
        return Icons.local_fire_department_rounded;
      case IncidentType.pole:
        return Icons.cell_tower_rounded;
      case IncidentType.planned:
        return Icons.schedule_rounded;
      case IncidentType.other:
        return Icons.electric_bolt_rounded;
    }
  }

  Color get _statusColor {
    switch (incident.status) {
      case IncidentStatus.reported:
        return AppColors.electricAmber;
      case IncidentStatus.inProgress:
        return AppColors.cyanBlue;
      case IncidentStatus.monitoring:
        return AppColors.violet;
      case IncidentStatus.resolved:
        return AppColors.neonGreen;
    }
  }

  String get _statusLabel {
    switch (incident.status) {
      case IncidentStatus.reported:
        return 'Signalé';
      case IncidentStatus.inProgress:
        return 'En cours';
      case IncidentStatus.monitoring:
        return 'Surveillance';
      case IncidentStatus.resolved:
        return 'Résolu ✓';
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _typeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_typeIcon, color: _typeColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          incident.title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: AppColors.textMuted, size: 12),
                            const SizedBox(width: 3),
                            Text(
                              incident.location,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: _statusColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      _statusLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: _statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Progress steps mini
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _MiniProgressBar(steps: incident.steps),
            ),

            // Footer
            Container(
              margin: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule_rounded,
                      color: AppColors.textMuted, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    incident.reportedAt,
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: AppColors.textMuted),
                  ),
                  const Spacer(),
                  const Icon(Icons.people_rounded,
                      color: AppColors.textMuted, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${incident.confirmedBy} confirmations',
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: AppColors.textMuted),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textMuted, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniProgressBar extends StatelessWidget {
  final List<_IncidentStep> steps;
  const _MiniProgressBar({required this.steps});

  @override
  Widget build(BuildContext context) {
    final doneCount = steps.where((s) => s.isDone).length;
    final progress = doneCount / steps.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(steps.length, (i) {
            final isDone = steps[i].isDone;
            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppColors.neonGreen
                            : AppColors.borderColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isDone
                          ? AppColors.neonGreen
                          : AppColors.borderColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          'Étape $doneCount/${steps.length} — ${(progress * 100).toInt()}% complété',
          style: GoogleFonts.poppins(
              fontSize: 10, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fiche détail incident
// ─────────────────────────────────────────────────────────────────────────────
class _IncidentDetailSheet extends StatelessWidget {
  final _IncidentItem incident;
  const _IncidentDetailSheet({required this.incident});

  Color get _statusColor {
    switch (incident.status) {
      case IncidentStatus.reported:
        return AppColors.electricAmber;
      case IncidentStatus.inProgress:
        return AppColors.cyanBlue;
      case IncidentStatus.monitoring:
        return AppColors.violet;
      case IncidentStatus.resolved:
        return AppColors.neonGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: AppColors.navyCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: controller,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID et statut
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCard,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            incident.id,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: _statusColor.withOpacity(0.3)),
                          ),
                          child: Text(
                            incident.status == IncidentStatus.resolved
                                ? '✓ Résolu'
                                : incident.status == IncidentStatus.inProgress
                                ? '🔧 En cours'
                                : '📍 Signalé',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: _statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      incident.title,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            color: AppColors.textMuted, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${incident.location} · Région ${incident.region}',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Description
                    Text(
                      incident.description,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Infos rapides
                    Row(
                      children: [
                        _QuickInfo(
                          icon: Icons.access_time_rounded,
                          label: 'Durée',
                          value: incident.duration,
                          color: AppColors.electricAmber,
                        ),
                        const SizedBox(width: 8),
                        _QuickInfo(
                          icon: Icons.people_rounded,
                          label: 'Affectés',
                          value: '${incident.affectedCount}',
                          color: AppColors.cyanBlue,
                        ),
                        const SizedBox(width: 8),
                        _QuickInfo(
                          icon: Icons.thumb_up_rounded,
                          label: 'Confirmés',
                          value: '${incident.confirmedBy}',
                          color: AppColors.neonGreen,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Timeline de progression
                    Text(
                      'Suivi de l\'incident',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...List.generate(
                      incident.steps.length,
                          (i) => _TimelineStep(
                        step: incident.steps[i],
                        isLast: i == incident.steps.length - 1,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Signalé par
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceCard,
                        borderRadius: BorderRadius.circular(12),
                        border:
                        Border.all(color: AppColors.borderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: AppColors.amberGradient,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person_rounded,
                                color: Colors.black, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Signalé par',
                                style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: AppColors.textMuted),
                              ),
                              Text(
                                incident.reportedBy,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            incident.reportedAt,
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (incident.status != IncidentStatus.resolved)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.thumb_up_rounded,
                              size: 18),
                          label: Text(
                            'Je confirme cet incident',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.electricAmber,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final _IncidentStep step;
  final bool isLast;
  const _TimelineStep({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: step.isDone
                      ? AppColors.neonGreen.withOpacity(0.15)
                      : AppColors.surfaceCard,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: step.isDone
                        ? AppColors.neonGreen
                        : AppColors.borderColor,
                  ),
                ),
                child: Icon(
                  step.isDone ? Icons.check_rounded : step.icon,
                  color: step.isDone
                      ? AppColors.neonGreen
                      : AppColors.textMuted,
                  size: 14,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: step.isDone
                        ? AppColors.neonGreen.withOpacity(0.3)
                        : AppColors.borderColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Contenu
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    step.label,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: step.isDone
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: step.isDone
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                  Text(
                    step.time,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: step.isDone
                          ? AppColors.neonGreen
                          : AppColors.textMuted,
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

class _QuickInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _QuickInfo(
      {required this.icon,
        required this.label,
        required this.value,
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
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatBadge(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label: $value',
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Modèles
// ─────────────────────────────────────────────────────────────────────────────
enum IncidentType {
  blackout,
  lowVoltage,
  dangerCable,
  transformer,
  pole,
  planned,
  other
}

enum IncidentStatus { reported, inProgress, monitoring, resolved }

class _IncidentStep {
  final String label;
  final String time;
  final bool isDone;
  final IconData icon;
  const _IncidentStep(
      {required this.label,
        required this.time,
        required this.isDone,
        required this.icon});
}

class _IncidentItem {
  final String id;
  final String title;
  final String location;
  final String region;
  final IncidentType type;
  final IncidentStatus status;
  final String reportedAt;
  final String? resolvedAt;
  final String duration;
  final int affectedCount;
  final int confirmedBy;
  final String reportedBy;
  final String description;
  final List<_IncidentStep> steps;

  const _IncidentItem({
    required this.id,
    required this.title,
    required this.location,
    required this.region,
    required this.type,
    required this.status,
    required this.reportedAt,
    required this.resolvedAt,
    required this.duration,
    required this.affectedCount,
    required this.confirmedBy,
    required this.reportedBy,
    required this.description,
    required this.steps,
  });
}