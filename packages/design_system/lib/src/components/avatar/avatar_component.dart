import 'package:flutter/material.dart';

import '../../theme/app_semantic_colors.dart';
import 'avatar_view_model.dart';

class AvatarComponent extends StatelessWidget {
  const AvatarComponent({required this.viewModel, super.key});

  final AvatarViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final tone = context.semanticColors.tone(viewModel.tone);
    return Semantics(
      label: viewModel.name,
      image: true,
      child: CircleAvatar(
        radius: viewModel.size / 2,
        backgroundColor: tone.background,
        foregroundImage: viewModel.hasImage
            ? NetworkImage(viewModel.imageUrl!)
            : null,
        child: Text(
          viewModel.initials,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: tone.foreground,
            fontSize: viewModel.fontSize,
          ),
        ),
      ),
    );
  }
}
