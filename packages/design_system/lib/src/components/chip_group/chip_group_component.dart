import 'package:flutter/material.dart';

import '../../tokens/app_spacing.dart';
import 'chip_group_view_model.dart';

/// Chips em pílula que quebram linha quando não cabem.
class ChipGroupComponent extends StatelessWidget {
  const ChipGroupComponent({required this.viewModel, super.key});

  final ChipGroupViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final item in viewModel.items)
          ChoiceChip(
            label: Text(item.label),
            selected: item.selected,
            onSelected: item.onTap == null ? null : (_) => item.onTap!(),
          ),
      ],
    );
  }
}
