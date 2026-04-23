import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Fonds ────────────────────────────────────────────────────────────────
  static const Color deepSpace   = Color(0xFF080D1A);
  static const Color navyCard    = Color(0xFF0F1628);
  static const Color surfaceCard = Color(0xFF162033);
  static const Color borderColor = Color(0xFF243046);

  // ── Couleurs de marque ───────────────────────────────────────────────────
  static const Color electricAmber  = Color(0xFFF59E0B);
  static const Color amberLight     = Color(0xFFFBBF24);
  static const Color neonGreen      = Color(0xFF10B981);
  static const Color redCoral       = Color(0xFFFF5252);
  static const Color cyanBlue       = Color(0xFF00E5FF);
  static const Color electricYellow = Color(0xFFFFD700);
  static const Color violet         = Color(0xFFA78BFA);

  // ── Texte ────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted     = Color(0xFF475569);

  // ── Statuts ──────────────────────────────────────────────────────────────
  static const Color statusDanger  = Color(0xFFFF5252);
  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color statusSuccess = Color(0xFF10B981);
  static const Color statusInfo    = Color(0xFF00E5FF);
  static const Color statusPending = Color(0xFFA78BFA);

  // ── Dégradés ─────────────────────────────────────────────────────────────
  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF080D1A), Color(0xFF0F1628), Color(0xFF080D1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF006FFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dangerGradient = LinearGradient(
    colors: [Color(0xFFFF5252), Color(0xFFB91C1C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF162033), Color(0xFF0F1628)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}