import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class BlankScaffold extends StatefulWidget {
  final Widget body;
  final bool showLeading;
  final Widget? floatingActionButton;
  const BlankScaffold({
    super.key,
    required this.body,
    this.showLeading = true,
    this.floatingActionButton,
  });

  @override
  State<BlankScaffold> createState() => _BlankScaffoldState();
}

class _BlankScaffoldState extends State<BlankScaffold>
    with TickerProviderStateMixin {
  // gradient controller
  late MeshGradientController _meshController;

  @override
  void initState() {
    super.initState();
    // gradient decoration
    _meshController = MeshGradientController(
      points: [
        MeshGradientPoint(
          position: const Offset(0.2, 0.6),
          color: const Color.fromARGB(255, 52, 10, 92),
        ),
        MeshGradientPoint(
          position: const Offset(0.4, 0.5),
          color: const Color.fromARGB(255, 119, 90, 224),
        ),
        MeshGradientPoint(
          position: const Offset(0.7, 0.4),
          color: const Color.fromARGB(255, 28, 25, 219),
        ),
        MeshGradientPoint(
          position: const Offset(0.4, 0.9),
          color: const Color.fromARGB(255, 26, 114, 165),
        ),
      ],
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.floatingActionButton,
      body: Stack(
        children: [
          Positioned.fill(
            child: MeshGradient(
              controller: _meshController,
              options: MeshGradientOptions(blend: 3.5, noiseIntensity: 0.5),
            ),
          ),
          Positioned.fill(child: widget.body),
          if (widget.showLeading)
            Positioned(
              top: 30,
              left: 15,
              child: IconButton(
                key: Key('backButton'),
                icon: Ink(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    size: 35,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
        ],
      ),
    );
  }
}
