import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vigilight/app_colors.dart';
import 'package:vigilight/vigi_logo.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  String _selectedFilter = 'Tous';
  bool _showLegend = true;

  late AnimationController _pingCtrl;
  late Animation<double> _pingAnim;

  // Yaoundé comme centre
  static const LatLng _center = LatLng(3.8480, 11.5021);

  final List<_IncidentMarker> _markers = const [
    _IncidentMarker(
      position: LatLng(3.8700, 11.5200),
      label: 'Bastos',
      type: 'Coupure totale',
      severity: MarkerSeverity.critical,
    ),
    _IncidentMarker(
      position: LatLng(3.8350, 11.5050),
      label: 'Melen',
      type: 'Baisse de tension',
      severity: MarkerSeverity.warning,
    ),
    _IncidentMarker(
      position: LatLng(3.8600, 11.5300),
      label: 'Ngousso',
      type: 'Câble au sol',
      severity: MarkerSeverity.danger,
    ),
    _IncidentMarker(
      position: LatLng(3.8150, 11.4900),
      label: 'Biyem-Assi',
      type: 'En cours de dépannage',
      severity: MarkerSeverity.inProgress,
    ),
    _IncidentMarker(
      position: LatLng(3.8900, 11.4800),
      label: 'Obili',
      type: 'Coupure programmée',
      severity: MarkerSeverity.planned,
    ),
    _IncidentMarker(
      position: LatLng(3.8400, 11.5400),
      label: 'Omnisport',
      type: 'Transformateur bruyant',
      severity: MarkerSeverity.warning,
    ),
  ];

  final List<String> _filters = [
    'Tous',
    'Coupures',
    'Dangers',
    'En cours',
    'Programmés',
  ];

  @override
  void initState() {
    super.initState();

    _pingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _pingAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _pingCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pingCtrl.dispose();
    super.dispose();
  }

  List<_IncidentMarker> get _filteredMarkers {
    if (_selectedFilter == 'Tous') return _markers;
    return _markers.where((m) {
      switch (_selectedFilter) {
        case 'Coupures':
          return m.severity == MarkerSeverity.critical;
        case 'Dangers':
          return m.severity == MarkerSeverity.danger;
        case 'En cours':
          return m.severity == MarkerSeverity.inProgress;
        case 'Programmés':
          return m.severity == MarkerSeverity.planned;
        default:
          return true;
      }
    }).toList();
  }

  void _showIncidentDetails(_IncidentMarker marker) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _IncidentBottomSheet(marker: marker),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Carte Flutter Map ──────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 13.0,
              minZoom: 10.0,
              maxZoom: 18.0,
            ),
            children: [
              // Tuiles OpenStreetMap avec style sombre
              TileLayer(
                urlTemplate:
                'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png',
                userAgentPackageName: 'com.vigilight.app',
                fallbackUrl:
                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),

              // Couche de marqueurs
              MarkerLayer(
                markers: _filteredMarkers
                    .map(
                      (m) => Marker(
                    point: m.position,
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () => _showIncidentDetails(m),
                      child: _AnimatedMapMarker(
                        marker: m,
                        pingAnim: _pingAnim,
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),
            ],
          ),

          // ── AppBar flottante ───────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: [
                  // Barre de recherche
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.navyCard.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Icon(Icons.arrow_back_rounded,
                                color: AppColors.textPrimary, size: 22),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            style: GoogleFonts.poppins(
                                color: AppColors.textPrimary, fontSize: 14),
                            decoration: InputDecoration(
                              hintText:
                              'Rechercher un quartier...',
                              hintStyle: GoogleFonts.poppins(
                                  color: AppColors.textMuted, fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Icon(Icons.search_rounded,
                              color: AppColors.textSecondary, size: 22),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Filtres horizontaux
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
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
                                  : AppColors.navyCard.withOpacity(0.9),
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
                ],
              ),
            ),
          ),

          // ── Légende ────────────────────────────────────────────────────
          Positioned(
            bottom: 110,
            left: 16,
            child: AnimatedSlide(
              offset: _showLegend ? Offset.zero : const Offset(-1.5, 0),
              duration: const Duration(milliseconds: 300),
              child: _MapLegend(),
            ),
          ),

          // ── Toggle légende ─────────────────────────────────────────────
          Positioned(
            bottom: 110,
            right: 16,
            child: Column(
              children: [
                _MapActionButton(
                  icon: Icons.layers_rounded,
                  onTap: () =>
                      setState(() => _showLegend = !_showLegend),
                ),
                const SizedBox(height: 8),
                _MapActionButton(
                  icon: Icons.my_location_rounded,
                  onTap: () {
                    _mapController.move(_center, 14);
                    HapticFeedback.selectionClick();
                  },
                ),
                const SizedBox(height: 8),
                _MapActionButton(
                  icon: Icons.add_rounded,
                  onTap: () =>
                      _mapController.move(_center, 15),
                ),
                const SizedBox(height: 8),
                _MapActionButton(
                  icon: Icons.remove_rounded,
                  onTap: () =>
                      _mapController.move(_center, 12),
                ),
              ],
            ),
          ),

          // ── Bouton Signaler flottant ───────────────────────────────────
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/report'),
                child: Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    gradient: AppColors.amberGradient,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.electricAmber.withOpacity(0.5),
                        blurRadius: 25,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded,
                          color: Colors.white, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Signaler ici',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Marqueur animé sur la carte
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedMapMarker extends StatelessWidget {
  final _IncidentMarker marker;
  final Animation<double> pingAnim;

  const _AnimatedMapMarker({
    required this.marker,
    required this.pingAnim,
  });

  Color get _color {
    switch (marker.severity) {
      case MarkerSeverity.critical:
        return AppColors.electricAmber;
      case MarkerSeverity.danger:
        return AppColors.redCoral;
      case MarkerSeverity.warning:
        return AppColors.electricAmber.withOpacity(0.8);
      case MarkerSeverity.inProgress:
        return AppColors.cyanBlue;
      case MarkerSeverity.planned:
        return AppColors.violet;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pingAnim,
      builder: (_, child) => Stack(
        alignment: Alignment.center,
        children: [
          // Onde de ping
          if (marker.severity == MarkerSeverity.critical ||
              marker.severity == MarkerSeverity.danger)
            Opacity(
              opacity: (1 - pingAnim.value) * 0.7,
              child: Container(
                width: 20 + pingAnim.value * 40,
                height: 20 + pingAnim.value * 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _color, width: 2),
                ),
              ),
            ),
          child!,
        ],
      ),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: _color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _color.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          _getIcon(),
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (marker.severity) {
      case MarkerSeverity.critical:
        return Icons.power_off_rounded;
      case MarkerSeverity.danger:
        return Icons.warning_rounded;
      case MarkerSeverity.warning:
        return Icons.bolt_rounded;
      case MarkerSeverity.inProgress:
        return Icons.engineering_rounded;
      case MarkerSeverity.planned:
        return Icons.schedule_rounded;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Légende de la carte
// ─────────────────────────────────────────────────────────────────────────────
class _MapLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (AppColors.electricAmber, 'Coupure totale'),
      (AppColors.redCoral, 'Danger critique'),
      (AppColors.cyanBlue, 'En cours'),
      (AppColors.violet, 'Programmé'),
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.navyCard.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Légende',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: item.$1,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.$2,
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: AppColors.textPrimary),
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
// Bouton d'action sur la carte
// ─────────────────────────────────────────────────────────────────────────────
class _MapActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.navyCard.withOpacity(0.95),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom sheet de détail d'incident
// ─────────────────────────────────────────────────────────────────────────────
class _IncidentBottomSheet extends StatelessWidget {
  final _IncidentMarker marker;
  const _IncidentBottomSheet({required this.marker});

  Color get _color {
    switch (marker.severity) {
      case MarkerSeverity.critical:
        return AppColors.electricAmber;
      case MarkerSeverity.danger:
        return AppColors.redCoral;
      case MarkerSeverity.warning:
        return AppColors.electricAmber.withOpacity(0.8);
      case MarkerSeverity.inProgress:
        return AppColors.cyanBlue;
      case MarkerSeverity.planned:
        return AppColors.violet;
    }
  }

  String get _statusLabel {
    switch (marker.severity) {
      case MarkerSeverity.critical:
        return 'HORS TENSION';
      case MarkerSeverity.danger:
        return 'DANGER CRITIQUE';
      case MarkerSeverity.warning:
        return 'ANOMALIE DÉTECTÉE';
      case MarkerSeverity.inProgress:
        return 'ÉQUIPE EN ROUTE';
      case MarkerSeverity.planned:
        return 'DÉLESTAGE PLANIFIÉ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(28),
        border:
        Border.all(color: _color.withOpacity(0.3), width: 1),
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

          // En-tête
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.location_on_rounded, color: _color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      marker.label,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: _color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _statusLabel,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _color,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Text(
            marker.type,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          // Bouton Moi aussi
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.thumb_up_rounded, size: 18),
              label: Text(
                'Moi aussi — confirmer la panne',
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
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Modèles
// ─────────────────────────────────────────────────────────────────────────────
enum MarkerSeverity { critical, danger, warning, inProgress, planned }

class _IncidentMarker {
  final LatLng position;
  final String label;
  final String type;
  final MarkerSeverity severity;

  const _IncidentMarker({
    required this.position,
    required this.label,
    required this.type,
    required this.severity,
  });
}