import 'dart:math';

import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// void main() {
//   runApp(MaterialApp(
//     home: QrCodePage(),
//   ));
// }

class qr extends StatefulWidget {
  const qr({super.key});

  @override
  State<qr> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<qr> {
  final supabase = Supabase.instance.client;
  String _randomNumbers = '';
  String? storedRandomNumber; //to store the random number generated

  @override
  void initState() {
    super.initState();
    _generateRandomNumbers();
  }

  void _generateRandomNumbers() async {
    await supabase.from('notes').delete().match({'course': 'CSET-311'});
    final _random = Random();
    _randomNumbers =
        (_random.nextInt(900000) + 1000000).toString(); // 7-digit string
    storedRandomNumber = _randomNumbers; // store the generated random number
    await supabase.from('notes').insert({
      'name': "eht e sham",
      'course': "CSET-311",
      'key': storedRandomNumber
    });
    print("qr generated");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Generator"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              painter: QrPainter(
                data: _randomNumbers,
                options: QrOptions(
                  shapes: QrShapes(
                    darkPixel: QrPixelShapeRoundCorners(cornerFraction: 0.05),
                    frame: QrFrameShapeCircle(),
                    ball: QrBallShapeCircle(),
                  ),
                  colors: QrColors(
                    dark: QrColorSolid(Colors.black),
                    light: QrColorSolid(Colors.black),
                  ),
                ),
              ),
              size: const Size(300, 300),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateRandomNumbers,
              child: const Text("Generate New QR Code"),
            ),
          ],
        ),
      ),
    );
  }
}
