import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_excel_workshop/cutom_components/custom_circle_progress_indicator.dart';
import 'package:flutter_excel_workshop/excel_manager.dart';
import 'package:flutter_excel_workshop/pdf_manager.dart';
import 'package:flutter_excel_workshop/progres_companent_mixin.dart';
import 'package:open_file/open_file.dart';

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

class _MyHomePageState extends State<MyHomePage> with ProgressCompanentMixin {
  late final PdfManager pdfManager;
  late final ExcelManager excelManager;
  bool isInit = false;
  @override
  void initState() {
    excelManager = ExcelManager();
    pdfManager = PdfManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!pdfManager.isSetContext) {
      pdfManager.setContext(context);
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/launch_icon_5.jpg"),
                fit: BoxFit.fill)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 50),
              ozetTablosu(),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(25),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                        shadowColor: MaterialStateProperty.all(Colors.black),
                        enableFeedback: true,
                        backgroundColor:
                            MaterialStateProperty.all(Colors.yellow)),
                    child: Text(
                      'Dosya Seç',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    onPressed: () async {
                      if (!pdfManager.isPopulated) {
                        await pdfManager.populateInstances();
                      }
                      temizle();

                      try {
                        await excelManager.getEshActivityIndexListFromExcelFile(
                          onProgress: (progress) {
                            ilerlemeDurumuGuncelle(progress);
                            ilerlemeYuzdesi = progress;
                            guncelle();
                          },
                          isStarted: (isStarted) {
                            durum = durumDosyaSecildi;
                            yapilanIslem = yapilanIslemSecilenDosyaOkunuyor;
                            guncelle();
                          },
                        ).then((value) async {
                          if (value != null) {
                            yudeSifirla();
                            durum = durum = durumSecilenDosyaOkundu;
                            yapilanIslem = yapilanIslemPdfDosyalarolusturuluyor;
                            guncelle();
                            print("okunan indeks sayısı : $value");

                            await pdfManager.saveAllPdf(
                                onProgress: (progress) {
                                  ilerlemeDurumuGuncelle(progress);
                                  ilerlemeYuzdesi = progress;

                                  guncelle();
                                  print(
                                      "oluşturulan pdf anlık yüzdesi : $progress");
                                },
                                allActivtyIndex: value,
                                folderName: "Bartel Aktivite Pdf Dosyaları");

                            await excelManager.exportToExcelList(
                              value,
                              isStarted: (isStarted) {
                                if (isStarted) {
                                  yudeSifirla();
                                  durum = durum = durumPdfDosyalarOlusturuldu;
                                  yapilanIslem =
                                      yapilanIslemExcelOzetListesiOlusturuluyor;
                                  guncelle();
                                }
                              },
                              onProgress: (progress) {
                                ilerlemeDurumuGuncelle(progress);
                                ilerlemeYuzdesi = progress;
                                guncelle();
                                print(
                                    "oluşturulan excel satır anlık yüzdesi : $progress");
                              },
                              createdFolderPath: (createdFilePath) async {
                                print(
                                    'oluşturulan dosya path $createdFilePath');
                              // await OpenFile.open('$createdFilePath\\');
                              },
                            );

                            durum = durum = durumExcelOzetListesiOlusturuldu;
                            yapilanIslem = '';
                            sonuc = sonucBasarili;
                            guncelle();
                          } else {
                            durum = durum = durumHenuzDosyaSecilmedi;
                            yapilanIslem = '';
                            sonuc = sonucDosyaSEcmeIptalEdildi;
                            guncelle();
                            print("Dosya Seçim İşlemi İptal Edildi");
                          }
                        });
                      } catch (e) {
                        temizle();
                        durum = durum = durumHenuzDosyaSecilmedi;
                        yapilanIslem = '';
                        yudeSifirla();
                        sonuc = sonucHata;
                        guncelle();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  guncelle() {
    setState(() {});
  }
}
