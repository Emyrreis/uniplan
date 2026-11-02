import 'package:flutter/foundation.dart';

/// Um segmento já pronto para desenhar.
typedef SegmentItem = ({String label, bool selected, VoidCallback? onTap});

/// Controle segmentado ("Pendentes | Entregues | Todas").
///
/// A escolha é delegada para [onSelected]; o segmento marcado vem de
/// [selectedIndex], que a tela guarda.
class SegmentedViewModel {
  const SegmentedViewModel({
    required this.segments,
    required this.selectedIndex,
    this.enabled = true,
    this.onSelected,
  });

  final List<String> segments;
  final int selectedIndex;
  final bool enabled;
  final ValueChanged<int>? onSelected;

  /// Os segmentos com "marcado" e ação já calculados, para o `build()` só
  /// percorrer a lista.
  List<SegmentItem> get items => [
    for (var i = 0; i < segments.length; i++)
      (
        label: segments[i],
        selected: i == selectedIndex,
        onTap: enabled && onSelected != null ? () => onSelected!(i) : null,
      ),
  ];
}
