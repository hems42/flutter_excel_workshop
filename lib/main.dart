import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            ElevatedButton(child: Text('Create Excel'), onPressed: createPdf),
      ),
    );
  }

  Future<void> createExcel() async {
    final Workbook workbook = Workbook(2);
    final Worksheet sheet = workbook.worksheets[1];
    int i = 1;
    sheet.getRangeByIndex(2, 1, 10000, 3).cells.forEach((element) {
      element.setText("ananın amı $i");
      i++;
    });

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Output.xlsx')
        ..click();
    } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName =
          Platform.isWindows ? '$path\\Output.xlsx' : '$path/Output.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }
  }

  Future<void> createPdf() async {
    // Create a new PDF document.
    final PdfDocument document = PdfDocument();
    PdfPageSettings settings = PdfPageSettings();
    PdfFont fontNormal = PdfStandardFont(PdfFontFamily.helvetica, 12);
    PdfFont fontInce = PdfStandardFont(PdfFontFamily.helvetica, 9);
    PdfPen pdfPen = PdfPen(
      PdfColor(0, 0, 0),
      width: 0.8,
    );
    PdfSolidBrush pdfSolidBrush = PdfSolidBrush(PdfColor(0, 0, 0));

// Add a PDF page and draw text.
    PdfPage page1 = document.pages.add();
    PdfGraphics graphics1 = page1.graphics;
    graphics1.drawString(
        'Barthel Gunluk Yasam Aktiviteleri Indeksi', fontNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(160, 5, 0, 0));

    graphics1.drawLine(pdfPen, Offset(5, 25), Offset(570, 25));

      graphics1.drawString(
        'Parametre', fontInce,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(25, 32, 0, 0));

         graphics1.drawString(
        'Degerlendirme', fontInce,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(155, 32, 0, 0));

        graphics1.drawString(
        'Puan', fontInce,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(395, 32, 0, 0));

          graphics1.drawString(
        'Hastanin \n Puani', fontInce,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(465, 29, 0, 0));

  graphics1.drawLine(pdfPen, Offset(5, 50), Offset(570, 50));
    graphics1.rotateTransform(-90);

    graphics1.drawString("mobilite", fontNormal,
        bounds: const Rect.fromLTWH(-400, 100, 150, 20));

    graphics1.drawLine(pdfPen, Offset(-400, 115), Offset(-355, 115));

    graphics1.rotateTransform(90);

    graphics1.drawString("mobilite", fontNormal,
        bounds: const Rect.fromLTWH(400, 200, 150, 20));
    graphics1.drawLine(pdfPen, Offset(400, 225), Offset(455, 225));

    PdfPage page2 = document.pages.add();

    page2.graphics.drawString(
        'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: const Rect.fromLTWH(0, 100, 150, 20));

// Save the document.
    // File file =  await File('HelloWorld.pdf').writeAsBytes(await document.save());
// Dispose the document.
    final List<int> bytes = await document.save();
    document.dispose();

    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Output.pdf')
        ..click();
    } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName =
          Platform.isWindows ? '$path\\Output.pdf' : '$path/Output.pdf';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(file.path);
    }
  }

  Future<void> readExcel() async {
    final Workbook workbook = Workbook(2);
    final Worksheet sheet = workbook.worksheets[1];
    sheet.getRangeByName('A2').setText('Hello World!');
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Output.xlsx')
        ..click();
    } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName =
          Platform.isWindows ? '$path\\Output.xlsx' : '$path/Output.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }
  }

 
  Future<void> readExcel2() async {
    /// Use FilePicker to pick files in Flutter Web
  
  /*final pickedFile = await FilePicker.getFile(
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
    
  );
  
  /// file might be picked
  
  var bytes = await pickedFile.readAsBytes();
  var excel = Excel.decodeBytes(bytes);
  for (var table in excel.tables.keys) {
    print(table); //sheet Name
    print(excel.tables[table]!.maxCols);
    print(excel.tables[table]!.maxRows);
    for (var row in excel.tables[table]!.rows) {
      print("$row");
    }
  }*/
  }

}
