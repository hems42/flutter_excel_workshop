import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excel_workshop/esh_activity_index.dart';
import 'package:flutter_excel_workshop/excel_manager.dart';
import 'package:flutter_excel_workshop/pdf_manager.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'dart:convert';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'circle_progre_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: MyHomePage(title: 'Barter Aktivite Liste İşleyicisi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has pdfManager State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in pdfManager Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red)),
            child: Text('Listeyi İşle !!!'),
            onPressed: () async {
              var pdfManager = PdfManager(context: context);

              await pdfManager.populateInstances();

              ExcelManager excelManager = ExcelManager(context);

              await excelManager
                  .getEshActivityIndexListFromExcelFile()
                  .then((value) async {
                await pdfManager.saveAllPdf(
                    onProgress: (progress) {
                      print("oluşturulan pdf anlık yüzdesi : $progress");
                    },
                    allActivtyIndex: value ?? [],
                    folderName: "Bartel Aktivite Pdf Dosyaları");

                await excelManager.exportToExcelList(value ?? [], onProgress: (progress) {
                  print("oluşturulan excel satır anlık yüzdesi : $progress");
                });
              });
            }),
      ),
    );
  }
}
