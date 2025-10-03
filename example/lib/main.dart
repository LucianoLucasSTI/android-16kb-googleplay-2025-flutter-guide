import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Viewer with 16KB Page Size Support',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
      ),
      home: OnboardingPage(),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter PDF Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PdfPage()),
            );
          },
          child: const Text('Read PDF'),
        ),
      ),
    );
  }
}

class PdfPage extends StatefulWidget {
  const PdfPage({super.key});

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  String? _pdfPath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdfFromAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: Stack(
        children: [
          if (_pdfPath != null)
            PDFView(
              filePath: _pdfPath!,
              onViewCreated: (PDFViewController pdfViewController) {
                debugPrint('PDF loaded successfully');
              },
              onPageChanged: (int? page, int? total) {
                debugPrint('Current Page: $page, Total Pages: $total');
              },
              onPageError: (int? page, dynamic error) {
                debugPrint('Error on page $page: $error');
              },
            ),
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading PDF...'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _loadPdfFromAssets() async {
    try {
      // Adds a 3-second delay to simulate loading
      await Future.delayed(const Duration(seconds: 3));

      // Loads the PDF content from assets
      ByteData bytes = await rootBundle.load('assets/pdf/document.pdf');

      // Creates a temporary file
      Directory tempDir = await Directory.systemTemp.createTemp();
      String tempPath = '${tempDir.path}/document.pdf';

      // Writes the content to the temporary file
      File file = File(tempPath);
      await file.writeAsBytes(bytes.buffer.asUint8List());

      // Updates the state with the file path
      setState(() {
        _pdfPath = tempPath;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading PDF: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
