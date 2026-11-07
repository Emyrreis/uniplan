import 'package:flutter/material.dart';

import '../../theme/app_semantic_colors.dart';
import 'avatar_view_model.dart';

/// Foto ou iniciais. Com `onEdit`, vira um botão com o selo de câmera.
class AvatarComponent extends StatelessWidget {
  const AvatarComponent({required this.viewModel, super.key});

  final AvatarViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final tone = context.semanticColors.tone(viewModel.tone);

    final circle = CircleAvatar(
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
    );

    if (!viewModel.editable) {
      return Semantics(label: viewModel.name, image: true, child: circle);
    }

    final scheme = Theme.of(context).colorScheme;
    final badge = viewModel.badgeSize;

    return Semantics(
      button: true,
      label: 'Alterar foto de perfil',
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: viewModel.onEdit,
        child: SizedBox.square(
          dimension: viewModel.size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ExcludeSemantics(child: circle),
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  width: badge,
                  height: badge,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.photo_camera_outlined,
                    size: badge * 0.5,
                    color: scheme.onPrimary,
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
