import 'package:flutter/material.dart';

import '../../theme/app_semantic_colors.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';
import 'toggle_view_model.dart';

class ToggleComponent extends StatelessWidget {
  const ToggleComponent({required this.viewModel, super.key});

  final ToggleViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final tone = context.semanticColors.tone(viewModel.tone);
    final icon = viewModel.icon;

    return MergeSemantics(
      child: InkWell(
        borderRadius: AppRadius.mdAll,
        onTap: viewModel.onRowTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 52),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: AppSpacing.touch,
                  height: AppSpacing.touch,
                  decoration: BoxDecoration(
                    color: tone.background,
                    borderRadius: AppRadius.mdAll,
                  ),
                  child: Icon(icon, size: 20, color: tone.foreground),
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Text(
                  viewModel.label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Switch(value: viewModel.value, onChanged: viewModel.action),
            ],
          ),
        ),
      ),
    );
  }
}
