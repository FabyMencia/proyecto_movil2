import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
class PDFViewerPage extends StatefulWidget {
 final String assetPath;

  const PDFViewerPage({Key? key, required this.assetPath}) : super(key: key);
  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
   String? localPath;
 @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<void> loadPdf() async {
    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/temp.pdf");
    final data = await DefaultAssetBundle.of(context).load(widget.assetPath);
    await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
    setState(() {
      localPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: localPath == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(filePath: localPath!),
    );
  }
}

