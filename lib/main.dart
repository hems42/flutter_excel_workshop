import 'package:flutter/material.dart';
import 'package:flutter_excel_workshop/excel_manager.dart';
import 'package:flutter_excel_workshop/pdf_manager.dart';

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
      backgroundColor: Colors.amber,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Bartel Yaşam Aktivite Zamazingosu",
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              SizedBox(
                height: 30,
              ),
              Image.asset("assets/images/launch_icon_2.png"),
              SizedBox(
                height: 60,
              ),
              SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey)),
                    child: Text(
                      'Dosya Seç !!!',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    onPressed: () async {
                      var pdfManager = PdfManager(context: context);

                      await pdfManager.populateInstances();

                      ExcelManager excelManager = ExcelManager(context);

                      await excelManager
                          .getEshActivityIndexListFromExcelFile()
                          .then((value) async {
                        print("okunan indeks sayısı : $value");

                        await pdfManager.saveAllPdf(
                            onProgress: (progress) {
                              print(
                                  "oluşturulan pdf anlık yüzdesi : $progress");
                            },
                            allActivtyIndex: value ?? [],
                            folderName: "Bartel Aktivite Pdf Dosyaları");

                        await excelManager.exportToExcelList(value ?? [],
                            onProgress: (progress) {
                          print(
                              "oluşturulan excel satır anlık yüzdesi : $progress");
                        });
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
