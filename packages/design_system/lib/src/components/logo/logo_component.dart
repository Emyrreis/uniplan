import 'package:flutter/material.dart';

import '../../theme/app_semantic_colors.dart';
import '../../tokens/app_spacing.dart';
import '../../tokens/app_tone.dart';
import 'logo_view_model.dart';

/// Base abstrata das logos: as duas variações desenham o mesmo símbolo.
abstract class LogoComponent extends StatelessWidget {
  const LogoComponent({required this.viewModel, super.key});

  final LogoViewModel viewModel;

  /// O símbolo, com as cores certas para onde ele está.
  Widget mark(BuildContext context) {
    final semantic = context.semanticColors;
    final primary = semantic.tone(AppTone.primary);
    final accent = semantic.tone(AppTone.accent).background;

    return SizedBox.square(
      dimension: viewModel.size,
      child: CustomPaint(
        painter: LogoMarkPainter(
          tile: viewModel.onHeader ? Colors.white : primary.background,
          stroke: viewModel.onHeader ? primary.background : primary.foreground,
          accent: accent,
        ),
      ),
    );
  }
}

/// [LogoType.mark]: só o símbolo.
class MarkLogoComponent extends LogoComponent {
  const MarkLogoComponent({required super.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: viewModel.semanticLabel,
      image: true,
      child: mark(context),
    );
  }
}

/// [LogoType.full]: símbolo, nome e frase, centralizados.
class FullLogoComponent extends LogoComponent {
  const FullLogoComponent({required super.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = viewModel.onHeader
        ? context.semanticColors.onHeader
        : theme.colorScheme.onSurface;
    final tagline = viewModel.tagline;

    return Semantics(
      label: viewModel.semanticLabel,
      container: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExcludeSemantics(child: mark(context)),
          const SizedBox(height: AppSpacing.md),
          Text(
            viewModel.name,
            style: theme.textTheme.displaySmall?.copyWith(
              color: color,
              fontSize: viewModel.nameFontSize,
              letterSpacing: -0.5,
            ),
          ),
          if (tagline != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              tagline,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }
}

/// Desenha o símbolo numa grade de 64 × 64, a mesma do arquivo
/// `docs/marca/uniplan-logo.svg`:
/// quadrado com cantos de 18, "U" com traço de 7 e o braço direito mais
/// curto, e um ponto de destaque em cima dele (o "marcador" do plano).
class LogoMarkPainter extends CustomPainter {
  const LogoMarkPainter({
    required this.tile,
    required this.stroke,
    required this.accent,
  });

  final Color tile;
  final Color stroke;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide / 64;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, 64 * s, 64 * s),
        Radius.circular(18 * s),
      ),
      Paint()..color = tile,
    );

    final u = Path()
      ..moveTo(20 * s, 18 * s)
      ..lineTo(20 * s, 36 * s)
      ..arcToPoint(
        Offset(44 * s, 36 * s),
        radius: Radius.circular(12 * s),
        clockwise: false,
      )
      ..lineTo(44 * s, 27 * s);

    canvas.drawPath(
      u,
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawCircle(Offset(44 * s, 16.5 * s), 4.5 * s, Paint()..color = accent);
  }

  @override
  bool shouldRepaint(LogoMarkPainter old) =>
      old.tile != tile || old.stroke != stroke || old.accent != accent;
}
