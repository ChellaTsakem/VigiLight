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

class _NotificationsScreenState extends State<NotificationsScreen> with TickerProviderStateMixin {
  String _selectedFilter = 'Toutes';
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;

  final List<_NotifItem> _notifs = [
    _NotifItem(type: NotifType.alert, title: 'Panne dans votre zone', message: 'Une coupure totale a été signalée à Bastos, à 350m de vous. 12 confirmations reçues. Les équipes Eneo ont été alertées.', time: 'Il y a 3 min', isRead: false, zone: 'Bastos'),
    _NotifItem(type: NotifType.resolved, title: 'Courant rétabli — Melen', message: "L'équipe Eneo a résolu l'incident signalé à Melen. La panne de 2h est maintenant terminée. Merci pour votre signalement.", time: 'Il y a 45 min', isRead: false, zone: 'Melen'),
    _NotifItem(type: NotifType.maintenance, title: 'Délestage programmé', message: 'Coupure planifiée de 18h00 à 22h00 dans le quartier Obili. Préparez vos équipements et chargez vos appareils à l\'avance.', time: 'Il y a 2h', isRead: false, zone: 'Obili', countdown: '5h restantes'),
    _NotifItem(type: NotifType.community, title: 'Votre signalement confirmé', message: '8 voisins ont confirmé votre signalement sur Melen. En récompense, vous gagnez +15 pts de Civisme. Continuez comme ça !', time: 'Il y a 3h', isRead: true, zone: ''),
    _NotifItem(type: NotifType.inProgress, title: 'Équipe en route — Ngousso', message: 'Une équipe technique Eneo est en route vers Ngousso. Intervention estimée dans 30 minutes. Restez informé via l\'application.', time: 'Il y a 4h', isRead: true, zone: 'Ngousso'),
    _NotifItem(type: NotifType.danger, title: '🚨 Danger critique signalé', message: 'Un câble électrique au sol a été signalé avenue Kennedy. Évitez cette zone immédiatement et signalez-le aux autorités si nécessaire.', time: 'Il y a 5h', isRead: true, zone: 'Centre-ville'),
    _NotifItem(type: NotifType.maintenance, title: 'Maintenance programmée', message: 'Travaux de maintenance sur le réseau électrique dans votre zone ce weekend. Durée estimée : 4 heures samedi matin.', time: 'Hier', isRead: true, zone: 'Biyem-Assi'),
    _NotifItem(type: NotifType.community, title: 'Badge débloqué ! 🏆', message: 'Félicitations ! Vous avez obtenu le badge "Citoyen Actif" pour 5 signalements confirmés. Votre engagement fait la différence.', time: 'Il y a 2 jours', isRead: true, zone: ''),
  ];

  final List<String> _filters = ['Toutes', 'Alertes', 'Résolues', 'Maintenance', 'Communauté'];

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forward();
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
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
        case 'Alertes': return n.type == NotifType.alert || n.type == NotifType.danger;
        case 'Résolues': return n.type == NotifType.resolved;
        case 'Maintenance': return n.type == NotifType.maintenance;
        case 'Communauté': return n.type == NotifType.community || n.type == NotifType.inProgress;
        default: return true;
      }
    }).toList();
  }

  int get _unreadCount => _notifs.where((n) => !n.isRead).length;

  void _markAllRead() {
    HapticFeedback.selectionClick();
    setState(() { for (final n in _notifs) n.isRead = true; });
  }

  void _openNotif(_NotifItem notif) {
    setState(() => notif.isRead = true);
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NotifDetailSheet(notif: notif),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredNotifs;
    final today = filtered.where((n) => !n.time.contains('Hier') && !n.time.contains('jours')).toList();
    final older = filtered.where((n) => n.time.contains('Hier') || n.time.contains('jours')).toList();

    return Scaffold(
      body: AnimatedGridBackground(
        child: SafeArea(
          child: Column(
            children: [
              // ── En-tête ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(color: AppColors.surfaceCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderColor)),
                        child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Notifications', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                              if (_unreadCount > 0) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(gradient: AppColors.amberGradient, borderRadius: BorderRadius.circular(20)),
                                  child: Text('$_unreadCount', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black)),
                                ),
                              ],
                            ],
                          ),
                          Text('Restez informé en temps réel', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    if (_unreadCount > 0)
                      GestureDetector(
                        onTap: _markAllRead,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.electricAmber.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                          child: Text('Tout lire', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.electricAmber, fontWeight: FontWeight.w600)),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Filtres ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: SizedBox(
                  height: 38,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final isSelected = _filters[i] == _selectedFilter;
                      return GestureDetector(
                        onTap: () { HapticFeedback.selectionClick(); setState(() => _selectedFilter = _filters[i]); },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: isSelected ? AppColors.amberGradient : null,
                            color: isSelected ? null : AppColors.surfaceCard,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? AppColors.electricAmber : AppColors.borderColor),
                          ),
                          child: Text(_filters[i], style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.black : AppColors.textSecondary)),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // ── Liste ────────────────────────────────────────────────
              Expanded(
                child: filtered.isEmpty
                    ? _EmptyNotifs()
                    : SlideTransition(
                  position: _slideAnim,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      if (today.isNotEmpty) ...[
                        _GroupHeader(label: "Aujourd'hui"),
                        ...today.map((n) => _NotifTile(notif: n, onTap: () => _openNotif(n))),
                      ],
                      if (older.isNotEmpty) ...[
                        _GroupHeader(label: 'Plus ancien'),
                        ...older.map((n) => _NotifTile(notif: n, onTap: () => _openNotif(n))),
                      ],
                      const SizedBox(height: 24),
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
// Group Header
// ─────────────────────────────────────────────────────────────────────────────
class _GroupHeader extends StatelessWidget {
  final String label;
  const _GroupHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 0.8)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notification Tile
// ─────────────────────────────────────────────────────────────────────────────
class _NotifTile extends StatelessWidget {
  final _NotifItem notif;
  final VoidCallback onTap;

  const _NotifTile({required this.notif, required this.onTap});

  Color get _iconBg {
    switch (notif.type) {
      case NotifType.alert: return AppColors.electricAmber.withOpacity(0.15);
      case NotifType.resolved: return AppColors.neonGreen.withOpacity(0.15);
      case NotifType.maintenance: return AppColors.cyanBlue.withOpacity(0.15);
      case NotifType.community: return AppColors.violet.withOpacity(0.15);
      case NotifType.inProgress: return AppColors.cyanBlue.withOpacity(0.15);
      case NotifType.danger: return AppColors.redCoral.withOpacity(0.15);
    }
  }

  Color get _iconColor {
    switch (notif.type) {
      case NotifType.alert: return AppColors.electricAmber;
      case NotifType.resolved: return AppColors.neonGreen;
      case NotifType.maintenance: return AppColors.cyanBlue;
      case NotifType.community: return AppColors.violet;
      case NotifType.inProgress: return AppColors.cyanBlue;
      case NotifType.danger: return AppColors.redCoral;
    }
  }

  IconData get _icon {
    switch (notif.type) {
      case NotifType.alert: return Icons.bolt_rounded;
      case NotifType.resolved: return Icons.check_circle_rounded;
      case NotifType.maintenance: return Icons.engineering_rounded;
      case NotifType.community: return Icons.people_rounded;
      case NotifType.inProgress: return Icons.directions_car_rounded;
      case NotifType.danger: return Icons.warning_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notif.isRead ? AppColors.surfaceCard : AppColors.electricAmber.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: notif.isRead ? AppColors.borderColor : AppColors.electricAmber.withOpacity(0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unread dot
            Container(
              width: 8, height: 8,
              margin: const EdgeInsets.only(top: 18, right: 8),
              decoration: BoxDecoration(
                color: notif.isRead ? Colors.transparent : AppColors.electricAmber,
                shape: BoxShape.circle,
              ),
            ),
            // Icon
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(color: _iconBg, borderRadius: BorderRadius.circular(14)),
              child: Icon(_icon, color: _iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Text(notif.title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.w700, color: notif.isRead ? AppColors.textSecondary : AppColors.textPrimary))),
                      const SizedBox(width: 8),
                      Text(notif.time, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(notif.message, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted, height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (notif.zone.isNotEmpty || notif.countdown != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (notif.zone.isNotEmpty) ...[
                          const Icon(Icons.location_on_rounded, size: 12, color: AppColors.textMuted),
                          const SizedBox(width: 2),
                          Text(notif.zone, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textMuted)),
                        ],
                        if (notif.countdown != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.electricAmber.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                            child: Text(notif.countdown!, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.electricAmber)),
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
// Notification Detail Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _NotifDetailSheet extends StatelessWidget {
  final _NotifItem notif;
  const _NotifDetailSheet({required this.notif});

  Color get _color {
    switch (notif.type) {
      case NotifType.alert: return AppColors.electricAmber;
      case NotifType.resolved: return AppColors.neonGreen;
      case NotifType.maintenance: return AppColors.cyanBlue;
      case NotifType.community: return AppColors.violet;
      case NotifType.inProgress: return AppColors.cyanBlue;
      case NotifType.danger: return AppColors.redCoral;
    }
  }

  IconData get _icon {
    switch (notif.type) {
      case NotifType.alert: return Icons.bolt_rounded;
      case NotifType.resolved: return Icons.check_circle_rounded;
      case NotifType.maintenance: return Icons.engineering_rounded;
      case NotifType.community: return Icons.people_rounded;
      case NotifType.inProgress: return Icons.directions_car_rounded;
      case NotifType.danger: return Icons.warning_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.navyCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2)))),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(color: _color.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
                      child: Icon(_icon, color: _color, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notif.title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                          Text(notif.time, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.surfaceCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderColor)),
                  child: Text(notif.message, style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary, height: 1.7)),
                ),
                if (notif.zone.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, size: 16, color: _color),
                      const SizedBox(width: 6),
                      Text(notif.zone, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: _color)),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(color: AppColors.surfaceCard, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderColor)),
                          child: Center(child: Text('Fermer', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(gradient: AppColors.amberGradient, borderRadius: BorderRadius.circular(14)),
                        child: Center(child: Text('Voir sur la carte', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black))),
                      ),
                    ),
                  ],
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
// Empty State
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyNotifs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 80, height: 80, decoration: BoxDecoration(color: AppColors.surfaceCard, shape: BoxShape.circle, border: Border.all(color: AppColors.borderColor)), child: const Icon(Icons.notifications_none_rounded, color: AppColors.textMuted, size: 36)),
          const SizedBox(height: 16),
          Text('Aucune notification', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          Text('dans cette catégorie', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textMuted)),
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

  _NotifItem({required this.type, required this.title, required this.message, required this.time, required this.isRead, required this.zone, this.countdown});
}