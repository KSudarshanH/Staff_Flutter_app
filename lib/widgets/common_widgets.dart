import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─── Header Component ────────────────────────────────────────────────────────
class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget>? actions;
  final bool isCentered;

  const PageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.actions,
    this.isCentered = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;
        final align = isCentered
            ? CrossAxisAlignment.center
            : (isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center);
        final textAlign = isCentered
            ? TextAlign.center
            : (isWide ? TextAlign.left : TextAlign.center);
        final verticalPadding = isWide ? 64.0 : 40.0;

        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background glow matching radial-gradient
              Positioned(
                top: -100,
                right: -50,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                      stops: const [0.1, 1.0],
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: verticalPadding,
                  ),
                  child: isWide && !isCentered
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: align,
                              children: [
                                _Title(
                                  title: title,
                                  textAlign: textAlign,
                                  isWide: isWide,
                                ),
                                const SizedBox(height: 8),
                                _Subtitle(
                                  subtitle: subtitle,
                                  textAlign: textAlign,
                                  isWide: isWide,
                                ),
                              ],
                            ),
                            if (actions != null) Row(children: actions!),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: align,
                          children: [
                            _Title(
                              title: title,
                              textAlign: textAlign,
                              isWide: isWide,
                            ),
                            const SizedBox(height: 8),
                            _Subtitle(
                              subtitle: subtitle,
                              textAlign: textAlign,
                              isWide: isWide,
                            ),
                            if (actions != null) ...[
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: actions!,
                              ),
                            ],
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Title extends StatelessWidget {
  final String title;
  final TextAlign textAlign;
  final bool isWide;
  const _Title({
    required this.title,
    required this.textAlign,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      style:
          AppTheme.serif(
            size: isWide ? 48 : 32,
            weight: FontWeight.w700,
            color: AppColors.white,
          ).copyWith(
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  final String subtitle;
  final TextAlign textAlign;
  final bool isWide;
  const _Subtitle({
    required this.subtitle,
    required this.textAlign,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle.toUpperCase(),
      textAlign: textAlign,
      style: AppTheme.sans(
        size: isWide ? 14 : 12,
        weight: FontWeight.w600,
        color: AppColors.gold,
      ).copyWith(letterSpacing: 2.0),
    );
  }
}

// ─── Header Icon Button ───────────────────────────────────────────────────
class HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? label;

  const HeaderIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.gold,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label!,
                style: AppTheme.sans(
                  size: 14,
                  weight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: AppColors.white, size: 24),
      ),
    );
  }
}

// ─── App Card Component ───────────────────────────────────────────────────
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.slate200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }
}

// ─── Filter Chip Component ────────────────────────────────────────────────
class AppFilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: isActive ? null : Border.all(color: AppColors.slate200),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTheme.sans(
                size: 14,
                weight: FontWeight.w700,
                color: isActive ? AppColors.white : AppColors.slate700,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.ivory,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: AppTheme.sans(
                  size: 12,
                  weight: FontWeight.w700,
                  color: isActive ? AppColors.white : AppColors.slate500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Button Component ─────────────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;
  final Color? color;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.primary;
    final textC = textColor ?? AppColors.white;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: bg.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: textC,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  label,
                  style: AppTheme.sans(
                    size: 16,
                    weight: FontWeight.w700,
                    color: textC,
                  ),
                ),
        ),
      ),
    );
  }
}

// ─── Empty State Component ────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.slate200, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.ivory,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.slate400),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTheme.sans(
                size: 20,
                weight: FontWeight.w700,
                color: AppColors.slate900,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTheme.sans(size: 16, color: AppColors.slate500),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Status Badge Component ───────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color color;

  const StatusBadge({
    super.key,
    required this.label,
    required this.bg,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: bg == AppColors.slate100
            ? Border.all(color: AppColors.slate200)
            : Border.all(color: Colors.transparent),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTheme.sans(
          size: 11,
          weight: FontWeight.w800,
          color: color,
        ).copyWith(letterSpacing: 0.5),
      ),
    );
  }
}

// ─── Stat Card Component ──────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final String? subtitle;

  const StatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.sans(
                    size: 14,
                    weight: FontWeight.w600,
                    color: AppColors.slate500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTheme.sans(
                    size: 24,
                    weight: FontWeight.w800,
                    color: AppColors.slate900,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTheme.sans(size: 13, color: AppColors.slate400),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
