import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
          decoration: BoxDecoration(
            color: AppColors.primary,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Abstract Background Patterns
              Positioned(
                top: -50,
                right: -50,
                child: _HeaderPattern(
                  size: 300,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              Positioned(
                bottom: -80,
                left: -20,
                child: _HeaderPattern(
                  size: 200,
                  color: AppColors.gold.withValues(alpha: 0.08),
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
                            ).animate().fade(duration: 600.ms).slideX(begin: -0.2, curve: Curves.easeOutQuad),
                            if (actions != null) 
                              Row(children: actions!)
                                .animate().fade(duration: 600.ms, delay: 200.ms).slideX(begin: 0.2, curve: Curves.easeOutQuad),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: align,
                          children: [
                            _Title(
                              title: title,
                              textAlign: textAlign,
                              isWide: isWide,
                            ).animate().fade(duration: 600.ms).slideY(begin: -0.2, curve: Curves.easeOutQuad),
                            const SizedBox(height: 8),
                            _Subtitle(
                              subtitle: subtitle,
                              textAlign: textAlign,
                              isWide: isWide,
                            ).animate().fade(duration: 600.ms, delay: 100.ms).slideY(begin: -0.1, curve: Curves.easeOutQuad),
                            if (actions != null) ...[
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: actions!,
                              ).animate().fade(duration: 600.ms, delay: 300.ms).scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
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

class _HeaderPattern extends StatelessWidget {
  final double size;
  final Color color;
  const _HeaderPattern({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Container(
          width: size * 0.7,
          height: size * 0.7,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
          ),
        ),
      ),
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
      style: AppTheme.serif(
        size: isWide ? 56 : 36,
        weight: FontWeight.w800,
        color: AppColors.white,
        letterSpacing: -1,
      ).copyWith(
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
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
        weight: FontWeight.w700,
        color: AppColors.gold,
        letterSpacing: 3.0,
      ),
    );
  }
}

// ─── Header Icon Button ───────────────────────────────────────────────────
class HeaderIconButton extends StatefulWidget {
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
  State<HeaderIconButton> createState() => _HeaderIconButtonState();
}

class _HeaderIconButtonState extends State<HeaderIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: 100.ms,
        child: widget.label != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.gold, AppColors.goldDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, color: AppColors.white, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      widget.label!,
                      style: AppTheme.sans(
                        size: 14,
                        weight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  boxShadow: [
                    if (_isPressed)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: -2,
                      ),
                  ],
                ),
                child: Icon(widget.icon, color: AppColors.white, size: 26),
              ),
      ),
    );
  }
}

// ─── App Card Component ───────────────────────────────────────────────────
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool animateOnTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.onTap,
    this.animateOnTap = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.slate100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onTap != null) {
      return _AnimatedTap(
        onTap: onTap!,
        animate: animateOnTap,
        child: card,
      );
    }
    return card;
  }
}

class _AnimatedTap extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool animate;
  const _AnimatedTap({required this.child, required this.onTap, this.animate = true});

  @override
  State<_AnimatedTap> createState() => _AnimatedTapState();
}

class _AnimatedTapState extends State<_AnimatedTap> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) {
      return GestureDetector(onTap: widget.onTap, child: widget.child);
    }
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: 100.ms,
        child: widget.child,
      ),
    );
  }
}

// ─── Button Component ─────────────────────────────────────────────────────
class PrimaryButton extends StatefulWidget {
  final String label;
  final Future<void> Function()? onTap;
  final bool isLoading;
  final Color? color;
  final Color? textColor;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.color,
    this.textColor,
    this.icon,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.color ?? AppColors.primary;
    final textC = widget.textColor ?? AppColors.white;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.isLoading || widget.onTap == null
          ? null
          : () async {
              await widget.onTap!();
            },
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: 150.ms,
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              if (!widget.isLoading)
                BoxShadow(
                  color: bg.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
            ],
            gradient: widget.color == null 
              ? LinearGradient(
                  colors: [bg, bg.withValues(alpha: 0.85)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: textC,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: textC, size: 20),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        widget.label,
                        style: AppTheme.sans(
                          size: 16,
                          weight: FontWeight.w800,
                          color: textC,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// ─── Shimmer Loading ──────────────────────────────────────────────────────
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 1500.ms)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              colors: const [
                Color(0xFFEBEBEB),
                Color(0xFFF4F4F4),
                Color(0xFFEBEBEB),
              ],
              stops: const [0.1, 0.5, 0.9],
              begin: Alignment(-1.0 + _controller.value * 2, -0.3),
              end: Alignment(1.0 + _controller.value * 2, 0.3),
            ),
          ),
        );
      },
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(icon, size: 56, color: AppColors.slate300),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .moveY(begin: -5, end: 5, duration: 2000.ms, curve: Curves.easeInOut),
          const SizedBox(height: 24),
          Text(
            title,
            style: AppTheme.serif(
              size: 24,
              weight: FontWeight.w700,
              color: AppColors.slate900,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 10),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: AppTheme.sans(size: 16, color: AppColors.slate500),
            ),
          ],
        ],
      ).animate().fade(duration: 600.ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTheme.sans(
          size: 11,
          weight: FontWeight.w900,
          color: color,
          letterSpacing: 1.0,
        ),
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
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.sans(
                    size: 14,
                    weight: FontWeight.w700,
                    color: AppColors.slate500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: AppTheme.serif(
                    size: 28,
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
