import 'package:flutter/foundation.dart';

/// Um chip já pronto para desenhar.
typedef ChipItem = ({String label, bool selected, VoidCallback? onTap});

/// Grupo de chips ("Prova · Trabalho · Lista · Seminário").
///
/// Com [multiSelect] falso, funciona como escolha única. O toque em cada
/// chip é delegado para [onToggled] com o índice; quem decide o que fica
/// marcado é a tela.
class ChipGroupViewModel {
  const ChipGroupViewModel({
    required this.options,
    required this.selected,
    this.multiSelect = false,
    this.enabled = true,
    this.onToggled,
  });

  final List<String> options;

  /// Índices marcados.
  final Set<int> selected;
  final bool multiSelect;
  final bool enabled;
  final ValueChanged<int>? onToggled;

  List<ChipItem> get items => [
    for (var i = 0; i < options.length; i++)
      (
        label: options[i],
        selected: selected.contains(i),
        onTap: enabled && onToggled != null ? () => onToggled!(i) : null,
      ),
  ];

  /// Ajuda a tela a calcular a nova seleção depois de um toque.
  Set<int> toggled(int index) {
    if (!multiSelect) return {index};
    final next = {...selected};
    if (!next.remove(index)) next.add(index);
    return next;
  }
}
