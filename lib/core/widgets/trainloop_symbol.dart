import 'package:flutter/widgets.dart';

/// Símbolo de marca: la cinta en bucle con la corona del cronómetro.
///
/// El contorno sale del vector maestro en Figma (310 × 258) y se pinta con el
/// degradado orquídea de la marca; es decorativo, así que no lleva semántica.
class TrainloopSymbol extends StatelessWidget {
  const TrainloopSymbol({super.key, this.height = 28});

  final double height;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        height: height,
        width: height * _symbolSize.width / _symbolSize.height,
        child: const CustomPaint(painter: _SymbolPainter()),
      ),
    );
  }
}

const _symbolSize = Size(310, 258);

// Orquídea (acento oscuro → acento claro), igual que el ícono de la app.
const _gradient = LinearGradient(
  colors: [Color(0xFFD45CFF), Color(0xFF8A2BBF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class _SymbolPainter extends CustomPainter {
  const _SymbolPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.height / _symbolSize.height;
    canvas.scale(scale);
    final path = Path()..addPolygon(_outline, true);
    final paint = Paint()
      ..shader = _gradient.createShader(Offset.zero & _symbolSize)
      ..isAntiAlias = true;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SymbolPainter oldDelegate) => false;
}

const _outline = <Offset>[
  Offset(252, 11),
  Offset(220, 1),
  Offset(199, 0),
  Offset(196, 7),
  Offset(195, 19),
  Offset(197, 22),
  Offset(206, 23),
  Offset(210, 26),
  Offset(207, 38),
  Offset(205, 40),
  Offset(177, 40),
  Offset(150, 50),
  Offset(136, 59),
  Offset(119, 76),
  Offset(110, 89),
  Offset(111, 94),
  Offset(130, 99),
  Offset(145, 86),
  Offset(162, 77),
  Offset(187, 71),
  Offset(216, 74),
  Offset(237, 84),
  Offset(257, 102),
  Offset(265, 118),
  Offset(268, 130),
  Offset(268, 147),
  Offset(265, 159),
  Offset(260, 169),
  Offset(251, 179),
  Offset(234, 188),
  Offset(224, 189),
  Offset(212, 187),
  Offset(199, 181),
  Offset(155, 144),
  Offset(122, 123),
  Offset(99, 114),
  Offset(82, 111),
  Offset(66, 111),
  Offset(45, 117),
  Offset(30, 126),
  Offset(18, 138),
  Offset(6, 158),
  Offset(0, 178),
  Offset(0, 198),
  Offset(3, 211),
  Offset(15, 233),
  Offset(24, 242),
  Offset(38, 251),
  Offset(59, 257),
  Offset(76, 256),
  Offset(55, 252),
  Offset(37, 243),
  Offset(24, 229),
  Offset(18, 215),
  Offset(18, 201),
  Offset(24, 188),
  Offset(43, 172),
  Offset(59, 168),
  Offset(77, 169),
  Offset(92, 175),
  Offset(111, 187),
  Offset(158, 224),
  Offset(178, 236),
  Offset(205, 245),
  Offset(231, 245),
  Offset(251, 239),
  Offset(275, 224),
  Offset(292, 204),
  Offset(304, 181),
  Offset(309, 159),
  Offset(309, 134),
  Offset(302, 106),
  Offset(290, 86),
  Offset(262, 59),
  Offset(241, 47),
  Offset(234, 46),
  Offset(230, 42),
  Offset(234, 31),
  Offset(240, 31),
  Offset(245, 34),
  Offset(250, 31),
  Offset(254, 18),
  Offset(252, 11),
];
