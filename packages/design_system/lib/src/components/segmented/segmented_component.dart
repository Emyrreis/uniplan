import 'package:flutter/material.dart';

import '../../tokens/app_durations.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';
import 'segmented_view_model.dart';

/// Pílula lavanda com os segmentos; o marcado fica violeta.
class SegmentedComponent extends StatelessWidget {
  const SegmentedComponent({required this.viewModel, super.key});

  final SegmentedViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: AppRadius.pillAll,
      ),
      child: Row(
        children: [
          for (final item in viewModel.items)
            Expanded(child: _Segment(item: item)),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.item});

  final SegmentItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final foreground = item.selected ? scheme.onPrimary : scheme.onSurface;

    return Semantics(
      button: true,
      selected: item.selected,
      child: AnimatedContainer(
        duration: AppDurations.normal,
        height: 40,
        decoration: BoxDecoration(
          color: item.selected ? scheme.primary : Colors.transparent,
          borderRadius: AppRadius.pillAll,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: item.onTap,
            child: Center(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(color: foreground),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
