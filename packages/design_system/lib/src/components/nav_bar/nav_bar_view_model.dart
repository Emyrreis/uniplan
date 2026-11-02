import 'package:flutter/widgets.dart';

/// Um destino da barra: ícone + nome (o nome é lido pelo leitor de tela).
typedef NavBarDestination = ({IconData icon, String label});

/// Um destino já pronto para desenhar.
typedef NavBarEntry = ({
  IconData icon,
  String label,
  bool selected,
  VoidCallback? onTap,
});

/// Barra de navegação inferior ("Hoje · Disciplinas · Atividades · Perfil").
///
/// A troca de aba é delegada para [onSelected]; a aba marcada vem de
/// [selectedIndex], que a tela guarda.
class NavBarViewModel {
  const NavBarViewModel({
    required this.destinations,
    required this.selectedIndex,
    this.onSelected,
  });

  final List<NavBarDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;

  List<NavBarEntry> get entries => [
    for (var i = 0; i < destinations.length; i++)
      (
        icon: destinations[i].icon,
        label: destinations[i].label,
        selected: i == selectedIndex,
        onTap: onSelected == null ? null : () => onSelected!(i),
      ),
  ];
}
