import 'package:flutter/material.dart';
import 'package:uniplan_design_system/uniplan_design_system.dart';

import '../gallery_coordinator.dart';
import '../page_host.dart';

typedef Swatch = ({String name, Color color, Color onColor});

/// Cores, tipografia e tons do tema atual.
class TokensViewModel extends GalleryViewModel {
  SheetScaffoldViewModel get scaffold => const SheetScaffoldViewModel(
    title: 'Fundamentos',
    leading: GalleryCoordinator.backButton,
    trailing: GalleryCoordinator.themeButton,
  );

  /// A logo nas duas variações: só o símbolo e completa.
  List<LogoViewModel> get logos => const [
    LogoViewModel(size: 64),
    LogoViewModel(size: 40),
    LogoViewModel(size: 24),
  ];

  LogoViewModel get fullLogo => const LogoViewModel(
    type: LogoType.full,
    size: 56,
    onHeader: true,
    tagline: 'Seu semestre organizado num só lugar',
  );

  List<Swatch> swatches(AppColorPalette p) => [
    (name: 'primary', color: p.primary, onColor: p.onPrimary),
    (name: 'primaryContainer', color: p.primaryContainer, onColor: p.onPrimaryContainer),
    (name: 'accent', color: p.accent, onColor: p.onAccent),
    (name: 'success', color: p.success, onColor: p.onSuccess),
    (name: 'warning', color: p.warning, onColor: p.onWarning),
    (name: 'error', color: p.error, onColor: p.onError),
    (name: 'background', color: p.background, onColor: p.onSurface),
    (name: 'surface', color: p.surface, onColor: p.onSurface),
    (name: 'header', color: p.header, onColor: p.onHeader),
  ];

  List<({String name, TextStyle? style})> typeScale(TextTheme t) => [
    (name: 'headlineMedium 26', style: t.headlineMedium),
    (name: 'titleLarge 20', style: t.titleLarge),
    (name: 'titleMedium 15', style: t.titleMedium),
    (name: 'titleSmall 14', style: t.titleSmall),
    (name: 'bodyMedium 14', style: t.bodyMedium),
    (name: 'bodySmall 12', style: t.bodySmall),
    (name: 'labelSmall 11', style: t.labelSmall),
  ];

  List<BadgeViewModel> get tones => [
    for (final tone in AppTone.values)
      BadgeViewModel(label: tone.name, tone: tone),
  ];
}

class TokensPage extends StatelessWidget {
  const TokensPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageHost<TokensViewModel>(
      create: TokensViewModel.new,
      builder: (context, viewModel) {
        final palette = context.semanticColors.palette;
        final textTheme = Theme.of(context).textTheme;
        return SheetScaffoldFactory.create(
          viewModel.scaffold,
          // Logo completa sobre a faixa do topo, como no Login.
          header: LogoFactory.create(viewModel.fullLogo),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.screen),
            children: [
              SectionHeaderFactory.create(
                const SectionHeaderViewModel(title: 'Logo · símbolo'),
              ),
              Row(
                children: [
                  for (final logo in viewModel.logos) ...[
                    LogoFactory.create(logo),
                    const SizedBox(width: AppSpacing.lg),
                  ],
                ],
              ),
              SectionHeaderFactory.create(
                const SectionHeaderViewModel(title: 'Cores do tema atual'),
              ),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                children: [
                  for (final s in viewModel.swatches(palette)) _SwatchBox(s),
                ],
              ),
              SectionHeaderFactory.create(
                const SectionHeaderViewModel(title: 'Tipografia · Poppins'),
              ),
              for (final type in viewModel.typeScale(textTheme))
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(type.name, style: type.style),
                ),
              SectionHeaderFactory.create(
                const SectionHeaderViewModel(title: 'Tons (AppTone)'),
              ),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final tone in viewModel.tones) BadgeFactory.create(tone),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SwatchBox extends StatelessWidget {
  const _SwatchBox(this.swatch);

  final Swatch swatch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        color: swatch.color,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Text(
        swatch.name,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: swatch.onColor),
      ),
    );
  }
}
