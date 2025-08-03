import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:material_shapes/material_shapes.dart';

export 'package:material_shapes/material_shapes.dart';

final List<({RoundedPolygon shape, String title})> materialShapes = [
  (shape: MaterialShapes.circle, title: 'Circle'),
  (shape: MaterialShapes.square, title: 'Square'),
  (shape: MaterialShapes.slanted, title: 'Slanted'),
  (shape: MaterialShapes.arch, title: 'Arch'),
  (shape: MaterialShapes.semiCircle, title: 'Semicircle'),
  (shape: MaterialShapes.oval, title: 'Oval'),
  (shape: MaterialShapes.pill, title: 'Pill'),
  (shape: MaterialShapes.triangle, title: 'Triangle'),
  (shape: MaterialShapes.arrow, title: 'Arrow'),
  (shape: MaterialShapes.fan, title: 'Fan'),
  (shape: MaterialShapes.diamond, title: 'Diamond'),
  (shape: MaterialShapes.clamShell, title: 'Clammshell'),
  (shape: MaterialShapes.pentagon, title: 'Pentagon'),
  (shape: MaterialShapes.gem, title: 'Gem'),
  (shape: MaterialShapes.verySunny, title: 'Very sunny'),
  (shape: MaterialShapes.sunny, title: 'Sunny'),
  (shape: MaterialShapes.cookie4Sided, title: '4-sided cookie'),
  (shape: MaterialShapes.cookie6Sided, title: '6-sided cookie'),
  (shape: MaterialShapes.cookie7Sided, title: '8-sided cookie'),
  (shape: MaterialShapes.cookie9Sided, title: '9-sided cookie'),
  (shape: MaterialShapes.cookie12Sided, title: '12-sided cookie'),
  (shape: MaterialShapes.clover4Leaf, title: '4-leaf clover'),
  (shape: MaterialShapes.clover8Leaf, title: '8-leaf clover'),
  (shape: MaterialShapes.burst, title: 'Burst'),
  (shape: MaterialShapes.softBurst, title: 'Soft burst'),
  (shape: MaterialShapes.boom, title: 'Boom'),
  (shape: MaterialShapes.softBoom, title: 'Soft boom'),
  (shape: MaterialShapes.puffyDiamond, title: 'Puffy diamond'),
  (shape: MaterialShapes.puffy, title: 'Puffy'),
  (shape: MaterialShapes.flower, title: 'Flower'),
  (shape: MaterialShapes.ghostish, title: 'Ghost-ish'),
  // (shape: MaterialShapes.pixelCircle, title: 'Pixel circle'),
  // (shape: MaterialShapes.pixelTriangle, title: 'Pixel triangle'),
  (shape: MaterialShapes.bun, title: 'Bun'),
  // (shape: MaterialShapes.heart, title: 'Heart'),
];

class MaterialShapedWidget extends StatelessWidget {
  final RoundedPolygon shape;
  final Size size;
  final Widget? child;
  const MaterialShapedWidget({super.key, required this.shape, required this.size, this.child});

  @override
  Widget build(BuildContext context) {
    final path = shape.toPath();
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 48,
        minWidth: 48,
        maxWidth: size.width, maxHeight: size.height),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipPath(
          clipper: _MorphClipper(path: path, size: size),
          child: child ?? Container(color: const Color(0xFF201D23), child: const SizedBox.expand()),
        ),
      ),
    );
  }
}

class AnimatedShape extends StatefulWidget {
  final Size size;
  final Duration delayedDuration;
  final Duration morphDuration;
  final Widget? child;
  const AnimatedShape({
    super.key,
    this.size = const Size(300, 300),
    this.child,
    this.delayedDuration = const Duration(seconds: 1),
    this.morphDuration = const Duration(seconds: 1),
  });

  @override
  State<AnimatedShape> createState() => _AnimatedShapeState();
}

class _AnimatedShapeState extends State<AnimatedShape> with SingleTickerProviderStateMixin {
  static final List<({RoundedPolygon shape, String title})> _shapes = [
    (shape: MaterialShapes.circle, title: 'Circle'),
    (shape: MaterialShapes.square, title: 'Square'),
    (shape: MaterialShapes.slanted, title: 'Slanted'),
    (shape: MaterialShapes.arch, title: 'Arch'),
    (shape: MaterialShapes.semiCircle, title: 'Semicircle'),
    (shape: MaterialShapes.oval, title: 'Oval'),
    (shape: MaterialShapes.pill, title: 'Pill'),
    (shape: MaterialShapes.triangle, title: 'Triangle'),
    (shape: MaterialShapes.arrow, title: 'Arrow'),
    (shape: MaterialShapes.fan, title: 'Fan'),
    (shape: MaterialShapes.diamond, title: 'Diamond'),
    (shape: MaterialShapes.clamShell, title: 'Clammshell'),
    (shape: MaterialShapes.pentagon, title: 'Pentagon'),
    (shape: MaterialShapes.gem, title: 'Gem'),
    (shape: MaterialShapes.verySunny, title: 'Very sunny'),
    (shape: MaterialShapes.sunny, title: 'Sunny'),
    (shape: MaterialShapes.cookie4Sided, title: '4-sided cookie'),
    (shape: MaterialShapes.cookie6Sided, title: '6-sided cookie'),
    (shape: MaterialShapes.cookie7Sided, title: '8-sided cookie'),
    (shape: MaterialShapes.cookie9Sided, title: '9-sided cookie'),
    (shape: MaterialShapes.cookie12Sided, title: '12-sided cookie'),
    (shape: MaterialShapes.clover4Leaf, title: '4-leaf clover'),
    (shape: MaterialShapes.clover8Leaf, title: '8-leaf clover'),
    (shape: MaterialShapes.burst, title: 'Burst'),
    (shape: MaterialShapes.softBurst, title: 'Soft burst'),
    (shape: MaterialShapes.boom, title: 'Boom'),
    (shape: MaterialShapes.softBoom, title: 'Soft boom'),
    (shape: MaterialShapes.puffyDiamond, title: 'Puffy diamond'),
    (shape: MaterialShapes.puffy, title: 'Puffy'),
    (shape: MaterialShapes.flower, title: 'Flower'),
    (shape: MaterialShapes.ghostish, title: 'Ghost-ish'),
    // (shape: MaterialShapes.pixelCircle, title: 'Pixel circle'),
    // (shape: MaterialShapes.pixelTriangle, title: 'Pixel triangle'),
    (shape: MaterialShapes.bun, title: 'Bun'),
    (shape: MaterialShapes.heart, title: 'Heart'),
  ];

  late final ValueNotifier<int> _shapeIndex;

  late final ValueNotifier<int> _morphIndex;

  late final List<Morph> _morphs;

  late final AnimationController _controller;

  Timer? _timer;

  final _bouncySimulation = SpringSimulation(
    SpringDescription.withDampingRatio(ratio: 0.5, stiffness: 400, mass: 1),
    0,
    1,
    5,
    snapToEnd: true,
  );

  // This simulation used for Heart shape morphing, as progress greater than 1
  // produces sharp weird shape.
  final _lessBouncySimulation = SpringSimulation(
    SpringDescription.withDampingRatio(ratio: 0.8, stiffness: 300, mass: 1),
    0,
    1,
    0,
    snapToEnd: true,
  );

  @override
  void initState() {
    super.initState();

    _shapeIndex = ValueNotifier(0);
    _morphIndex = ValueNotifier(0);

    _morphs = <Morph>[];
    for (var i = 0; i < _shapes.length; i++) {
      _morphs.add(Morph(_shapes[i].shape, _shapes[(i + 1) % _shapes.length].shape));
    }
    _morphs.shuffle();

    _controller = AnimationController.unbounded(vsync: this);

    Future.delayed(widget.delayedDuration, () {
      if (!mounted) {
        return;
      }

      _timer = Timer.periodic(widget.morphDuration, (_) => _onAnimationDone());

      _controller
        ..value = 0
        ..animateWith(_bouncySimulation);

      _shapeIndex.value += 1;
    });
  }

  @override
  void dispose() {
    _shapeIndex.dispose();
    _morphIndex.dispose();
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onAnimationDone() {
    if (!mounted) {
      return;
    }

    _morphIndex.value = (_morphIndex.value + 1) % _morphs.length;
    _shapeIndex.value = (_shapeIndex.value + 1) % _shapes.length;

    final isHeart = _shapeIndex.value == _shapes.length - 1;
    _controller
      ..value = 0
      ..animateWith(isHeart ? _lessBouncySimulation : _bouncySimulation);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.size.width, maxHeight: widget.size.height),
        child: AspectRatio(
          aspectRatio: 1,
          child: AnimatedBuilder(
            animation: Listenable.merge([_morphIndex, _controller]),
            builder: (context, child) {
              final path = _morphs[_morphIndex.value].toPath(progress: _controller.value);

              return ClipPath(
                clipper: _MorphClipper(path: path, size: widget.size),
                child: widget.child ?? Container(color: const Color(0xFF201D23), child: const SizedBox.expand()),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MorphClipper extends CustomClipper<Path> {
  _MorphClipper({required this.path, required this.size});

  final Path path;
  final Size size;

  @override
  Path getClip(Size size) {
    // Scale the path to fit the widget size
    final matrix = Matrix4.identity();
    matrix.scale(size.width, size.height);

    return path.transform(matrix.storage);
  }

  @override
  bool shouldReclip(_MorphClipper oldClipper) {
    return oldClipper.path != path;
  }
}

class MorphClipper extends CustomClipper<Path> {
  MorphClipper({required this.path, required this.size});

  final Path path;
  final Size size;

  @override
  Path getClip(Size size) {
    // Scale the path to fit the widget size
    final matrix = Matrix4.identity();
    matrix.scale(size.width, size.height);

    return path.transform(matrix.storage);
  }

  @override
  bool shouldReclip(MorphClipper oldClipper) {
    return oldClipper.path != path;
  }
}

// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/physics.dart';
// import 'package:material_shapes/material_shapes.dart';

// class AnimatedShape extends StatefulWidget {
//   final Size size;
//   final Widget? child;
//   const AnimatedShape({super.key, this.size = const Size(300, 300), this.child});

//   @override
//   State<AnimatedShape> createState() => _AnimatedShapeState();
// }

// class _AnimatedShapeState extends State<AnimatedShape> with SingleTickerProviderStateMixin {
//   static final List<({RoundedPolygon shape, String title})> _shapes = [
//     (shape: MaterialShapes.circle, title: 'Circle'),
//     (shape: MaterialShapes.square, title: 'Square'),
//     (shape: MaterialShapes.slanted, title: 'Slanted'),
//     (shape: MaterialShapes.arch, title: 'Arch'),
//     (shape: MaterialShapes.semiCircle, title: 'Semicircle'),
//     (shape: MaterialShapes.oval, title: 'Oval'),
//     (shape: MaterialShapes.pill, title: 'Pill'),
//     (shape: MaterialShapes.triangle, title: 'Triangle'),
//     (shape: MaterialShapes.arrow, title: 'Arrow'),
//     (shape: MaterialShapes.fan, title: 'Fan'),
//     (shape: MaterialShapes.diamond, title: 'Diamond'),
//     (shape: MaterialShapes.clamShell, title: 'Clammshell'),
//     (shape: MaterialShapes.pentagon, title: 'Pentagon'),
//     (shape: MaterialShapes.gem, title: 'Gem'),
//     (shape: MaterialShapes.verySunny, title: 'Very sunny'),
//     (shape: MaterialShapes.sunny, title: 'Sunny'),
//     (shape: MaterialShapes.cookie4Sided, title: '4-sided cookie'),
//     (shape: MaterialShapes.cookie6Sided, title: '6-sided cookie'),
//     (shape: MaterialShapes.cookie7Sided, title: '8-sided cookie'),
//     (shape: MaterialShapes.cookie9Sided, title: '9-sided cookie'),
//     (shape: MaterialShapes.cookie12Sided, title: '12-sided cookie'),
//     (shape: MaterialShapes.clover4Leaf, title: '4-leaf clover'),
//     (shape: MaterialShapes.clover8Leaf, title: '8-leaf clover'),
//     (shape: MaterialShapes.burst, title: 'Burst'),
//     (shape: MaterialShapes.softBurst, title: 'Soft burst'),
//     (shape: MaterialShapes.boom, title: 'Boom'),
//     (shape: MaterialShapes.softBoom, title: 'Soft boom'),
//     (shape: MaterialShapes.puffyDiamond, title: 'Puffy diamond'),
//     (shape: MaterialShapes.puffy, title: 'Puffy'),
//     (shape: MaterialShapes.flower, title: 'Flower'),
//     (shape: MaterialShapes.ghostish, title: 'Ghost-ish'),
//     // (shape: MaterialShapes.pixelCircle, title: 'Pixel circle'),
//     // (shape: MaterialShapes.pixelTriangle, title: 'Pixel triangle'),
//     (shape: MaterialShapes.bun, title: 'Bun'),
//     (shape: MaterialShapes.heart, title: 'Heart'),
//   ];

//   late final ValueNotifier<int> _shapeIndex;

//   late final ValueNotifier<int> _morphIndex;

//   late final List<Morph> _morphs;

//   late final AnimationController _controller;

//   Timer? _timer;

//   final _bouncySimulation = SpringSimulation(
//     SpringDescription.withDampingRatio(ratio: 0.5, stiffness: 400, mass: 1),
//     0,
//     1,
//     5,
//     snapToEnd: true,
//   );

//   // This simulation used for Heart shape morphing, as progress greater than 1
//   // produces sharp weird shape.
//   final _lessBouncySimulation = SpringSimulation(
//     SpringDescription.withDampingRatio(ratio: 0.8, stiffness: 300, mass: 1),
//     0,
//     1,
//     0,
//     snapToEnd: true,
//   );

//   @override
//   void initState() {
//     super.initState();

//     _shapeIndex = ValueNotifier(0);
//     _morphIndex = ValueNotifier(0);

//     _morphs = <Morph>[];
//     for (var i = 0; i < _shapes.length; i++) {
//       _morphs.add(Morph(_shapes[i].shape, _shapes[(i + 1) % _shapes.length].shape));
//     }

//     _controller = AnimationController.unbounded(vsync: this);

//     Future.delayed(const Duration(seconds: 1), () {
//       if (!mounted) {
//         return;
//       }

//       _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onAnimationDone());

//       _controller
//         ..value = 0
//         ..animateWith(_bouncySimulation);

//       _shapeIndex.value += 1;
//     });
//   }

//   @override
//   void dispose() {
//     _shapeIndex.dispose();
//     _morphIndex.dispose();
//     _controller.dispose();
//     _timer?.cancel();
//     super.dispose();
//   }

//   void _onAnimationDone() {
//     if (!mounted) {
//       return;
//     }

//     _morphIndex.value = (_morphIndex.value + 1) % _morphs.length;
//     _shapeIndex.value = (_shapeIndex.value + 1) % _shapes.length;

//     final isHeart = _shapeIndex.value == _shapes.length - 1;
//     _controller
//       ..value = 0
//       ..animateWith(isHeart ? _lessBouncySimulation : _bouncySimulation);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RepaintBoundary(
//       child: ConstrainedBox(
//         constraints: BoxConstraints(maxWidth: widget.size.width, maxHeight: widget.size.height),
//         child: AspectRatio(
//           aspectRatio: 1,
//           child: CustomPaint(
//             painter: _MorphPainter(morphs: _morphs, morphIndex: _morphIndex, progress: _controller),
//             willChange: true,
//             child: widget.child ?? const SizedBox.expand(),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _MorphPainter extends CustomPainter {
//   _MorphPainter({required this.morphs, required this.morphIndex, required this.progress})
//     : super(repaint: Listenable.merge([morphIndex, progress]));

//   final List<Morph> morphs;

//   final ValueListenable<int> morphIndex;

//   final Animation<double> progress;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final path = morphs[morphIndex.value].toPath(progress: progress.value);

//     canvas
//       ..save()
//       ..scale(size.width)
//       ..drawPath(
//         path,
//         Paint()
//           ..style = PaintingStyle.fill
//           ..color = const Color(0xFF201D23),
//       )
//       ..restore();
//   }

//   @override
//   bool shouldRepaint(_MorphPainter oldDelegate) {
//     return oldDelegate.morphs != morphs || oldDelegate.morphIndex != morphIndex || oldDelegate.progress != progress;
//   }
// }
