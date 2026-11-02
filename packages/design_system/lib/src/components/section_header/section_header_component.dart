import 'package:flutter/material.dart';

import '../../tokens/app_spacing.dart';
import '../buttons/button_factory.dart';
import '../buttons/button_view_model.dart';
import 'section_header_view_model.dart';

class SectionHeaderComponent extends StatelessWidget {
  const SectionHeaderComponent({required this.viewModel, super.key});

  final SectionHeaderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                viewModel.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          if (viewModel.hasAction)
            // Reaproveita o botão de texto do próprio design system.
            ButtonFactory.create(
              ButtonViewModel(
                type: ButtonType.text,
                label: viewModel.actionLabel!,
                onPressed: viewModel.onAction,
              ),
            ),
        ],
      ),
    );
  }
}
