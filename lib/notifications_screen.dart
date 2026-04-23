import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vigilight/app_colors.dart';
import 'package:vigilight/vigi_logo.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  String _selectedFilter = 'Toutes';
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  final List<_NotifItem> _notifs = [
    _NotifItem(
      type: NotifType.alert,
      title: '⚡ Panne dans votre zone',
      message:
      'Une coupure totale a été signalée à Bastos, à 350m de vous. 12 confirmations.',
      time: 'Il y a 3 min',
      isRead: false,
      zone: 'Bastos',
    ),
    _NotifItem(
      type: NotifType.resolved,
      title: '✅ Courant rétabli — Melen',
      message:
      "L'équipe Eneo a résolu l'incident. La panne de 2h est terminée.",
      time: 'Il y a 45 min',
      isRead: false,
      zone: 'Melen',
    ),
    _NotifItem(
      type: NotifType.maintenance,
      title: '🔧 Délestage programmé',
      message:
      'Coupure prévue de 18h00 à 22h00 à Obili. Préparez-vous ! Chargez vos appareils.',
      time: 'Il y a 2h',
      isRead: false,
      zone: 'Obili',
      countdown: '5h restantes',
    ),
    _NotifItem(
      type: NotifType.community,
      title: '👍 Votre signalement confirmé',
      message:
      '8 voisins ont confirmé votre signalement. Vous gagnez +15 pts de Civisme.',
      time: 'Il y a 3h',
      isRead: true,
      zone: '',
    ),
    _NotifItem(
      type: NotifType.inProgress,
      title: '🚗 Équipe en route — Ngousso',
      message:
      "Une équipe technique est en route. Intervention estimée dans 30 minutes.",
      time: 'Il y a 4h',
      isRead: true,
      zone: 'Ngousso',
    ),
    _NotifItem(
      type: NotifType.danger,
      title: '🚨 Danger critique signalé',
      message:
      'Un câble au sol signalé avenue Kennedy. Évitez cette zone et restez à distance.',
      time: 'Il y a 5h',
      isRead: true,
      zone: 'Centre-ville',
    ),
    _NotifItem(
      type: NotifType.maintenance,
      title: '🔧 Maintenance programmée',
      message: 'Travaux de maintenance réseau dans votre zone ce weekend.',
      time: 'Hier',
      isRead: true,
      zone: 'Biyem-Assi',
    ),
    _NotifItem(
      type: NotifType.community,
      title: '🏆 Badge débloqué',
      message: 'Félicitations ! Vous avez obtenu le badge "Citoyen Actif" pour 5 signalements confirmés.',
      time: 'Il y a 2 jours',
      isRead: true,
      zone: '',
    ),
  ];

  final List<String> _filters = [
    'Toutes',
    'Alertes',
    'Résolues',
    'Maintenance',
    'Communauté',
  ];

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  List<_NotifItem> get _filteredNotifs {
    if (_selectedFilter == 'Toutes') return _notifs;
    return _notifs.where((n) {
      switch (_selectedFilter) {
        case 'Alertes':
          return n.type == NotifType.alert || n.type == NotifType.danger;
        case 'Résolues':
          return n.type == NotifType.resolved;
        case 'Maintenance':
          return n.type == NotifType.maintenance;
        case 'Communauté':
          return n.type == NotifType.community;
        default:
          return true;
      }
    }).toList();
  }

  int get _unreadCount => _notifs.where((n) => !n.isRead).length;

  void _markAllRead() {
    HapticFeedback.selectionClick();
    setState(() {
      for (final n in _notifs) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          Row(
                            children: [
                              Text(
                                'Notifications',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (_unreadCount > 0) ...[
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.amberGradient,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '$_unreadCount',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            'Restez informé en temps réel',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_unreadCount > 0)
                      GestureDetector(
                        onTap: _markAllRead,
                        child: Text(
                          'Tout lire',
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

              // ── Filtres ─────────────────────────────────────────────
              Padding(
                padding:
                const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  height: 36,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _filters.length,
                    itemBuilder: (_, i) {
                      final isSelected = _filters[i] == _selectedFilter;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedFilter = _filters[i]),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? AppColors.amberGradient
                                : null,
                            color: isSelected
                                ? null
                                : AppColors.surfaceCard,
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
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Séparateur
              const Divider(
                  color: AppColors.borderColor, height: 1, thickness: 1),

              // ── Liste des notifications ──────────────────────────────
              Expanded(
                child: _filteredNotifs.isEmpty
                    ? _EmptyNotifs()
                    : SlideTransition(
                  position: _slideAnim,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _filteredNotifs.length,
                    separatorBuilder: (_, __) => const Divider(
                      color: AppColors.borderColor,
                      height: 1,
                      indent: 80,
                    ),
                    itemBuilder: (_, i) => _NotifTile(
                      notif: _filteredNotifs[i],
                      onTap: () {
                        setState(
                                () => _filteredNotifs[i].isRead = true);
                      },
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
// Tuile de notification
// ─────────────────────────────────────────────────────────────────────────────
class _NotifTile extends StatelessWidget {
  final _NotifItem notif;
  final VoidCallback onTap;

  const _NotifTile({required this.notif, required this.onTap});

  Color get _iconBg {
    switch (notif.type) {
      case NotifType.alert:
        return AppColors.electricAmber.withOpacity(0.15);
      case NotifType.resolved:
        return AppColors.neonGreen.withOpacity(0.15);
      case NotifType.maintenance:
        return AppColors.cyanBlue.withOpacity(0.15);
      case NotifType.community:
        return AppColors.violet.withOpacity(0.15);
      case NotifType.inProgress:
        return AppColors.cyanBlue.withOpacity(0.15);
      case NotifType.danger:
        return AppColors.redCoral.withOpacity(0.15);
    }
  }

  Color get _iconColor {
    switch (notif.type) {
      case NotifType.alert:
        return AppColors.electricAmber;
      case NotifType.resolved:
        return AppColors.neonGreen;
      case NotifType.maintenance:
        return AppColors.cyanBlue;
      case NotifType.community:
        return AppColors.violet;
      case NotifType.inProgress:
        return AppColors.cyanBlue;
      case NotifType.danger:
        return AppColors.redCoral;
    }
  }

  IconData get _icon {
    switch (notif.type) {
      case NotifType.alert:
        return Icons.bolt_rounded;
      case NotifType.resolved:
        return Icons.check_circle_rounded;
      case NotifType.maintenance:
        return Icons.engineering_rounded;
      case NotifType.community:
        return Icons.people_rounded;
      case NotifType.inProgress:
        return Icons.directions_car_rounded;
      case NotifType.danger:
        return Icons.warning_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: notif.isRead
            ? Colors.transparent
            : AppColors.electricAmber.withOpacity(0.04),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicateur non-lu
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 20, right: 10),
              decoration: BoxDecoration(
                color: notif.isRead
                    ? Colors.transparent
                    : AppColors.electricAmber,
                shape: BoxShape.circle,
              ),
            ),

            // Icône
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(_icon, color: _iconColor, size: 22),
            ),

            const SizedBox(width: 14),

            // Contenu
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: notif.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: notif.isRead
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        notif.time,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.message,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  if (notif.zone.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            size: 12, color: AppColors.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          notif.zone,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                        if (notif.countdown != null) ...[
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.electricAmber.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              notif.countdown!,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.electricAmber,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
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
// Écran vide
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyNotifs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderColor),
            ),
            child: const Icon(Icons.notifications_none_rounded,
                color: AppColors.textMuted, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune notification',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            'dans cette catégorie',
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Modèles
// ─────────────────────────────────────────────────────────────────────────────
enum NotifType { alert, resolved, maintenance, community, inProgress, danger }

class _NotifItem {
  final NotifType type;
  final String title;
  final String message;
  final String time;
  bool isRead;
  final String zone;
  final String? countdown;

  _NotifItem({
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.zone,
    this.countdown,
  });
}