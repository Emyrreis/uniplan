import 'package:flutter/widgets.dart';

/// ViewModel base das páginas da galeria: ignora avisos que chegam depois
/// que a página fechou (ex.: um Future.delayed terminando).
abstract class GalleryViewModel extends ChangeNotifier {
  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// Cria a ViewModel uma vez, redesenha a View quando ela avisa mudança e
/// descarta a ViewModel ao sair da página.
class PageHost<T extends GalleryViewModel> extends StatefulWidget {
  const PageHost({required this.create, required this.builder, super.key});

  final T Function() create;
  final Widget Function(BuildContext context, T viewModel) builder;

  @override
  State<PageHost<T>> createState() => _PageHostState<T>();
}

class _PageHostState<T extends GalleryViewModel> extends State<PageHost<T>> {
  late final T _viewModel = widget.create();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) => widget.builder(context, _viewModel),
    );
  }
}
