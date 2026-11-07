/// Design system do app UniPlan: tokens, tema e componentes.
///
/// Todo componente segue o padrão ViewModel → Factory → Component → Widget:
/// a tela monta a ViewModel (dados, estado e funções de ação), pede o widget
/// à Factory e a Factory decide qual Component concreto criar.
library;

// Tokens
export 'src/tokens/app_colors.dart';
export 'src/tokens/app_durations.dart';
export 'src/tokens/app_radius.dart';
export 'src/tokens/app_spacing.dart';
export 'src/tokens/app_tone.dart';
export 'src/tokens/app_typography.dart';

// Tema
export 'src/theme/app_semantic_colors.dart';
export 'src/theme/app_theme.dart';

// Componentes: cada um expõe a ViewModel e a Factory. Os Components
// concretos ficam internos, para a tela sempre passar pela Factory.
export 'src/components/activity_tile/activity_tile_factory.dart';
export 'src/components/activity_tile/activity_tile_view_model.dart';
export 'src/components/avatar/avatar_factory.dart';
export 'src/components/avatar/avatar_view_model.dart';
export 'src/components/badge/badge_factory.dart';
export 'src/components/badge/badge_view_model.dart';
export 'src/components/buttons/button_factory.dart';
export 'src/components/buttons/button_view_model.dart';
export 'src/components/checkbox/checkbox_factory.dart';
export 'src/components/checkbox/checkbox_view_model.dart';
export 'src/components/chip_group/chip_group_factory.dart';
export 'src/components/chip_group/chip_group_view_model.dart';
export 'src/components/class_card/class_card_factory.dart';
export 'src/components/class_card/class_card_view_model.dart';
export 'src/components/logo/logo_factory.dart';
export 'src/components/logo/logo_view_model.dart';
export 'src/components/nav_bar/nav_bar_component.dart' show navBarHeight;
export 'src/components/nav_bar/nav_bar_factory.dart';
export 'src/components/nav_bar/nav_bar_view_model.dart';
export 'src/components/progress_bar/progress_bar_factory.dart';
export 'src/components/progress_bar/progress_bar_view_model.dart';
export 'src/components/schedule_tile/schedule_tile_factory.dart';
export 'src/components/schedule_tile/schedule_tile_view_model.dart';
export 'src/components/section_header/section_header_factory.dart';
export 'src/components/section_header/section_header_view_model.dart';
export 'src/components/segmented/segmented_factory.dart';
export 'src/components/segmented/segmented_view_model.dart';
export 'src/components/sheet_scaffold/sheet_scaffold_factory.dart';
export 'src/components/sheet_scaffold/sheet_scaffold_view_model.dart';
export 'src/components/stat_card/stat_card_factory.dart';
export 'src/components/stat_card/stat_card_view_model.dart';
export 'src/components/state_view/state_view_factory.dart';
export 'src/components/state_view/state_view_view_model.dart';
export 'src/components/subject_card/subject_card_factory.dart';
export 'src/components/subject_card/subject_card_view_model.dart';
export 'src/components/text_field/text_field_factory.dart';
export 'src/components/text_field/text_field_view_model.dart';
export 'src/components/toggle/toggle_factory.dart';
export 'src/components/toggle/toggle_view_model.dart';
