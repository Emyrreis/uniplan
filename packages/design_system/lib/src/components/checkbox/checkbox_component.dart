import 'package:flutter/material.dart';

import '../../tokens/app_durations.dart';
import '../../tokens/app_radius.dart';
import '../../tokens/app_spacing.dart';
import 'checkbox_view_model.dart';

/// Quadrado arredondado de 22px dentro de uma área de toque de 44px.
/// Marcado: preenchido de violeta com o "check"; o texto fica riscado.
class CheckboxComponent extends StatelessWidget {
  const CheckboxComponent({required this.viewModel, super.key});

  final CheckboxViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = viewModel.label;

    final box = AnimatedContainer(
      duration: AppDurations.fast,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: viewModel.checked ? scheme.primary : Colors.transparent,
        borderRadius: AppRadius.smAll,
        border: Border.all(color: scheme.primary, width: 2),
      ),
      child: viewModel.checked
          ? Icon(Icons.check, size: 16, color: scheme.onPrimary)
          : null,
    );

    return Semantics(
      checked: viewModel.checked,
      label: label ?? viewModel.semanticLabel,
      child: InkWell(
        borderRadius: AppRadius.mdAll,
        onTap: viewModel.onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: AppSpacing.touch,
            minHeight: AppSpacing.touch,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: AppSpacing.touch,
                child: Center(child: box),
              ),
              if (label != null)
                Flexible(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      decoration: viewModel.checked
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
