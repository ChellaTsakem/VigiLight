import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Fonds Dark (économie batterie) ───────────────────────────────────────
  static const Color deepSpace    = Color(0xFF0A0A0A); // Noir profond
  static const Color charcoal     = Color(0xFF111111); // Anthracite
  static const Color navyCard     = Color(0xFF1A1A1A); // Gris très foncé
  static const Color surfaceCard  = Color(0xFF222222); // Gris carte
  static const Color borderColor  = Color(0xFF2E2E2E); // Gris bordure
  static const Color borderLight  = Color(0xFF3A3A3A); // Bordure légère

  // ── Jaune Or / Orange — Énergie & Action ─────────────────────────────────
  static const Color electricAmber  = Color(0xFFFFD700); // Or électrique
  static const Color amberLight     = Color(0xFFFFC107); // Ambre doré
  static const Color amberOrange    = Color(0xFFFF9500); // Orange énergie
  static const Color amberDark      = Color(0xFFE65C00); // Orange foncé

  // ── Bleu Ciel — Technologie & Action secondaire ──────────────────────────
  static const Color cyanBlue       = Color(0xFF00B4D8); // Bleu ciel principal
  static const Color skyBlue        = Color(0xFF48CAE4); // Bleu ciel clair
  static const Color electricBlue   = Color(0xFF0096C7); // Bleu électrique
  static const Color deepBlue       = Color(0xFF023E8A); // Bleu profond

  // ── Blanc — Clarté & Lisibilité ──────────────────────────────────────────
  static const Color textPrimary    = Color(0xFFFFFFFF); // Blanc pur
  static const Color textSecondary  = Color(0xFFCCCCCC); // Gris clair
  static const Color textMuted      = Color(0xFF888888); // Gris moyen
  static const Color textDisabled   = Color(0xFF555555); // Gris foncé

  // ── Statuts ──────────────────────────────────────────────────────────────
  static const Color neonGreen      = Color(0xFF00C896); // Vert rétablissement
  static const Color redCoral       = Color(0xFFFF4444); // Rouge danger
  static const Color violet         = Color(0xFFBB86FC); // Violet maintenance
  static const Color electricYellow = Color(0xFFFFD700); // Alias

  static const Color statusDanger   = Color(0xFFFF4444);
  static const Color statusWarning  = Color(0xFFFFD700);
  static const Color statusSuccess  = Color(0xFF00C896);
  static const Color statusInfo     = Color(0xFF00B4D8);
  static const Color statusPending  = Color(0xFFBB86FC);

  // ── Dégradés ─────────────────────────────────────────────────────────────

  /// Or chaud → Orange — Boutons principaux / Signalement
  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFF9500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Bleu ciel → Bleu électrique — Navigation / Éléments tech
  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF48CAE4), Color(0xFF0096C7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Fond principal — Noir anthracite
  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF0A0A0A), Color(0xFF111111), Color(0xFF0A0A0A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Vert succès — Rétablissement
  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF00C896), Color(0xFF00957A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Rouge danger
  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFFF4444), Color(0xFFCC0000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Carte glassmorphism
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF222222), Color(0xFF1A1A1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dégradé Gold premium — AppBar / Header
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFC107), Color(0xFFFF9500)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Dégradé Bleu+Or — Hero sections
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0096C7), Color(0xFF00B4D8), Color(0xFFFFD700)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}