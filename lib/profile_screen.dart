import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vigilight/app_colors.dart';
import 'package:vigilight/vigi_logo.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // États de l'utilisateur (Simulés pour la démonstration)
  bool _isBatterySaverEnabled = false;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'Français';
  String _userName = 'TSAKEM TEMGOUA ROSLYNE CHELLA';
  String _userQuartier = 'Bastos, Yaoundé';

  // Méthode pour afficher un message rapide (SnackBar)
  void _showStatus(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: AppColors.cyanBlue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Action : Modifier le profil
  void _handleEditProfile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.navyCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Modifier le profil', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Nom complet', hintText: _userName),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ENREGISTRER'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action : Changer de langue
  void _handleLanguageChange() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: Text('Choisir la langue', style: GoogleFonts.poppins(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Français', 'English'].map((lang) {
            return RadioListTile<String>(
              title: Text(lang, style: const TextStyle(color: Colors.white)),
              value: lang,
              groupValue: _selectedLanguage,
              activeColor: AppColors.electricAmber,
              onChanged: (val) {
                setState(() => _selectedLanguage = val!);
                Navigator.pop(context);
                _showStatus('Langue changée en $val');
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  // Action : Déconnexion
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.navyCard,
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir quitter VigiLight ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ANNULER')),
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
            child: const Text('OUI, QUITTER', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepSpace,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140.0,
            pinned: true,
            backgroundColor: AppColors.charcoal,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'CENTRE DE CONTRÔLE',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 2,
                  color: AppColors.electricAmber,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.deepSpace, AppColors.charcoal.withOpacity(0.8)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildUserHeader(),
                  const SizedBox(height: 30),
                  _buildImpactStats(),

                  const SizedBox(height: 40),
                  _buildSectionTitle('PRÉFÉRENCES ÉNERGIE'),
                  const SizedBox(height: 12),
                  _buildSettingsGroup([
                    _buildToggleItem(
                      icon: Icons.battery_saver_rounded,
                      title: 'Économie de batterie',
                      subtitle: 'Optimise l\'app en cas de coupure',
                      value: _isBatterySaverEnabled,
                      onChanged: (val) {
                        setState(() => _isBatterySaverEnabled = val);
                        _showStatus(val ? "Mode économie activé" : "Mode normal activé");
                      },
                    ),
                    _buildToggleItem(
                      icon: Icons.notifications_active_rounded,
                      title: 'Alertes en temps réel',
                      subtitle: 'Notifications de votre quartier',
                      value: _notificationsEnabled,
                      onChanged: (val) {
                        setState(() => _notificationsEnabled = val);
                        _showStatus(val ? "Notifications activées" : "Notifications muettes");
                      },
                    ),
                  ]),

                  const SizedBox(height: 30),
                  _buildSectionTitle('PARAMÈTRES DU COMPTE'),
                  const SizedBox(height: 12),
                  _buildSettingsGroup([
                    _buildClickableItem(
                      icon: Icons.person_search_rounded,
                      title: 'Modifier mes informations',
                      onTap: _handleEditProfile,
                    ),
                    _buildClickableItem(
                      icon: Icons.map_rounded,
                      title: 'Quartier favori',
                      trailing: _userQuartier,
                      onTap: () => _showStatus("Changement de quartier bientôt disponible"),
                    ),
                    _buildClickableItem(
                      icon: Icons.translate_rounded,
                      title: 'Langue',
                      trailing: _selectedLanguage,
                      onTap: _handleLanguageChange,
                    ),
                  ]),

                  const SizedBox(height: 30),
                  _buildSectionTitle('ASSISTANCE & COMMUNAUTÉ'),
                  const SizedBox(height: 12),
                  _buildSettingsGroup([
                    _buildClickableItem(
                      icon: Icons.help_center_rounded,
                      title: 'Aide & FAQ',
                      onTap: () => Navigator.pushNamed(context, '/notifications'), // Exemple de redirection
                    ),
                    _buildClickableItem(
                      icon: Icons.verified_user_rounded,
                      title: 'Conditions d\'utilisation',
                      onTap: () => _showStatus("Chargement des conditions..."),
                    ),
                  ]),

                  const SizedBox(height: 50),

                  // Bouton Déconnexion
                  GestureDetector(
                    onTap: _handleLogout,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'DÉCONNEXION',
                          style: GoogleFonts.poppins(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppColors.goldGradient),
              child: const CircleAvatar(
                radius: 55,
                backgroundColor: AppColors.charcoal,
                child: Icon(Icons.person_rounded, size: 60, color: Colors.white),
              ),
            ),
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.cyanBlue,
              child: IconButton(
                icon: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                onPressed: () => _showStatus("Accès à la galerie..."),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _userName,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
        ),
        Text(
          'roslyne.chella@uy1.cm',
          style: GoogleFonts.poppins(fontSize: 14, color: AppColors.cyanBlue, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildImpactStats() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn('12', 'SIGNALÉS'),
          _buildStatColumn('240', 'POINTS'),
          _buildStatColumn('TOP 5', 'RANG'),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String val, String label) {
    return Column(
      children: [
        Text(val, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.electricAmber)),
        Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white54)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white38, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.navyCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderColor, width: 0.5),
      ),
      child: Column(children: items),
    );
  }

  Widget _buildToggleItem({required IconData icon, required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.electricAmber),
      title: Text(title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11)),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.electricAmber,
      ),
    );
  }

  Widget _buildClickableItem({required IconData icon, required String title, String? trailing, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.cyanBlue),
      title: Text(title, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) Text(trailing, style: GoogleFonts.poppins(color: AppColors.electricAmber, fontSize: 12)),
          const Icon(Icons.chevron_right_rounded, color: Colors.white24),
        ],
      ),
    );
  }
}