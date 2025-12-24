import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: LoaderDemo(), debugShowCheckedModeBanner: false);
  }
}

class LoaderDemo extends StatefulWidget {
  const LoaderDemo({super.key});

  @override
  State<LoaderDemo> createState() => _LoaderDemoState();
}

class _LoaderDemoState extends State<LoaderDemo> with SingleTickerProviderStateMixin {
  // Controller untuk mengontrol animasi
  late AnimationController controller;

  // Jarak titik dari pusat dan ukuran titik
  final double radius = 100;
  final double dotSize = 10;

  // Variabel untuk melacak tahapan penjelasan
  int _stage = 1;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();

    // Listener untuk memperbarui UI saat animasi berjalan
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Fungsi untuk maju ke tahapan berikutnya
  void _nextStage() {
    setState(() {
      if (_stage < 6) {
        _stage++;
      }
    });
  }

  // Fungsi untuk kembali ke tahapan sebelumnya
  void _prevStage() {
    setState(() {
      if (_stage > 1) {
        _stage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menghitung sudut dalam radian dari nilai controller
    final angle = controller.value * 2 * math.pi;
    final dx = radius * math.cos(angle);
    final dy = radius * math.sin(angle);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Animasi Trigonometri", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            // Area kartesian + animasi titik
            SizedBox(
              width: 300,
              height: 300,
              child: CustomPaint(
                painter: CartesianPainter(
                  stage: _stage, // Meneruskan tahapan ke painter
                  angle: angle,
                  dotSize: dotSize,
                  radius: radius,
                  dx: dx,
                  dy: dy,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Teks penjelasan berdasarkan tahapan
            _buildExplanationText(),
            const SizedBox(height: 20),
            // Tombol navigasi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: _stage > 1 ? _prevStage : null, child: const Text('Kembali')),
                Text('Tahap $_stage/6', style: const TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton(onPressed: _stage < 6 ? _nextStage : null, child: const Text('Lanjut')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan teks penjelasan di setiap tahapan
  Widget _buildExplanationText() {
    switch (_stage) {
      case 1:
        return Column(children: [const Text("Tahap 1: Kanvas Putih", style: TextStyle(fontSize: 16))]);
      case 2:
        return const Text("Tahap 2: Menambahkan Sumbu Kartesian", style: TextStyle(fontSize: 16));
      case 3:
        return const Text("Tahap 3: Menambahkan Titik Statis", style: TextStyle(fontSize: 16));
      case 4:
        return Column(
          children: [
            const Text("Tahap 4: Penjelasan Komponen X", style: TextStyle(fontSize: 16)),
            const Text("x = r × cos(\u03b8)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              "x = ${(_stage >= 4 ? (radius * math.cos(controller.value * 2 * math.pi)).toStringAsFixed(1) : '0.0')}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        );
      case 5:
        return Column(
          children: [
            const Text("Tahap 5: Penjelasan Komponen Y", style: TextStyle(fontSize: 16)),
            const Text("y = r × sin(\u03b8)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              "y = ${(_stage >= 5 ? (radius * math.sin(controller.value * 2 * math.pi)).toStringAsFixed(1) : '0.0')}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        );
      case 6:
        return Column(
          children: [
            const Text("Tahap 6: Tampilan Akhir (Animasi Melingkar)", style: TextStyle(fontSize: 16)),
            const Text("x = r × cos(\u03b8)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("y = r × sin(\u03b8)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              "Nilai x: ${(radius * math.cos(controller.value * 2 * math.pi)).toStringAsFixed(1)}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Nilai y: ${(radius * math.sin(controller.value * 2 * math.pi)).toStringAsFixed(1)}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class CartesianPainter extends CustomPainter {
  final int stage;
  final double radius;
  final double angle;
  final double dotSize;
  final double dx;
  final double dy;

  CartesianPainter({
    required this.stage,
    required this.radius,
    required this.angle,
    required this.dotSize,
    required this.dx,
    required this.dy,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final dotPaint = Paint()..color = Colors.blue;
    final projectionPaint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Tahap 1: Kanvas Putih
    // Tidak ada gambar yang diperlukan di sini.

    // Tahap 2: Sumbu Kartesian
    if (stage >= 2) {
      final axisPaint = Paint()
        ..color = Colors.grey
        ..strokeWidth = 1;
      canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), axisPaint); // Sumbu X
      canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), axisPaint); // Sumbu Y
    }

    // Tahap 3: Menambahkan Titik Statis
    if (stage == 3) {
      canvas.drawCircle(center.translate(0, 0), dotSize, dotPaint);
    }

    // Tahap 4: Penjelasan x = r * cos(theta)
    if (stage == 4) {
      // Garis proyeksi ke sumbu X
      canvas.drawLine(center, center.translate(dx, 0), projectionPaint);
      // Titik bergerak di sumbu X
      canvas.drawCircle(center.translate(dx, 0), dotSize, dotPaint);
    }

    // Tahap 5: Penjelasan y = r * sin(theta)
    if (stage == 5) {
      // Garis proyeksi ke sumbu Y
      canvas.drawLine(center, center.translate(0, dy), projectionPaint);
      // Titik bergerak di sumbu Y
      canvas.drawCircle(center.translate(0, dy), dotSize, dotPaint);
    }

    // Tahap 6: Tampilan Akhir (Animasi Melingkar)
    if (stage == 6) {
      // Gambar lingkaran panduan
      final circlePaint = Paint()
        ..color = Colors.grey.withOpacity(0.5)
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, circlePaint);

      // Garis proyeksi ke sumbu X
      canvas.drawLine(center.translate(dx, dy), center.translate(dx, 0), projectionPaint);
      // Garis proyeksi ke sumbu Y
      canvas.drawLine(center.translate(dx, dy), center.translate(0, dy), projectionPaint);
      // Garis radius
      canvas.drawLine(center, center.translate(dx, dy), projectionPaint);

      // Titik bergerak melingkar
      canvas.drawCircle(center.translate(dx, dy), dotSize, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Selalu repaint karena animasi sedang berjalan
    return true;
  }
}
