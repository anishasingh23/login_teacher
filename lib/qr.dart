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
    final sm = ScaffoldMessenger.of(context);
    final faculty_id = supabase.auth.currentUser?.userMetadata?['faculty_id'];
    print("Id ${faculty_id[0]['faculty_id']}");
    final _random = Random();
    _randomNumbers =
        (_random.nextInt(900000) + 1000000).toString(); // 7-digit string
    storedRandomNumber = _randomNumbers; // store the generated random number

    // checking if teacher has already generated the qr or not
    final exists = await supabase
        .from('keys_table')
        .select('active')
        .eq('faculty_id', faculty_id[0]['faculty_id']);

    if (exists.isEmpty || exists[0]['active'] == 0) {
      await supabase.from('keys_table').insert({
        'key_value': storedRandomNumber,
        'public_enkey': 123,
        'private_enkey': 251,
        'faculty_id': faculty_id[0]['faculty_id'],
        'active': 1
      });
      sm.showSnackBar(SnackBar(content: Text("Qr Generated")));
      print("qr generated");

      Future.delayed(Duration(seconds: 15), () async {
        await Supabase.instance.client.from('keys_table').update(
            {'active': 0}).eq('key_value', storedRandomNumber.toString());
        print("Updated");
      });
    } else {
      sm.showSnackBar(SnackBar(
        content: Text("Qr Already generated"),
        backgroundColor: Colors.redAccent[100],
      ));
      //  not optimatal => rather try to disable button or freeze state for 15 seconds
      Future.delayed(Duration(seconds: 15), () async {
        await Supabase.instance.client.from('keys_table').update(
            {'active': 0}).eq('key_value', storedRandomNumber.toString());
        print("Updated");
      });
    }
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
