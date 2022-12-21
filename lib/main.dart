import 'package:flutter/material.dart';
import 'package:flutter_excel_workshop/esh_activity_index.dart';
import 'package:flutter_excel_workshop/pdf_manager.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
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
        child: ElevatedButton(
            child: Text('Create Excel'),
            onPressed: () async {
              var a = PdfManager(context: context);

              await a.populateInstances();
              var document =
                  a.getPdfDocumentByEshActivityIndex(a.getEshModel());

              final List<int> bytes = await document.save();

              document.dispose();

              String folder = "";
              await getExternalStorageDirectory()
                  .then((value) => folder = value!.path);

            
             String pathFolder = '$folder/Output.pdf';

                final File file = File(pathFolder);
                await file.writeAsBytes(bytes, flush: true);
                OpenFile.open(file.path);
            }),
      ),
    );
  }

  Future<void> createExcel() async {
    final Workbook workbook = Workbook(2);
    final Worksheet sheet = workbook.worksheets[1];
    int i = 1;
    sheet.getRangeByIndex(2, 1, 10000, 3).cells.forEach((element) {
      element.setText("ananin ami $i");
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
    //----------
    String fontPathArial = 'assets/fonts/arial.ttf';
    String fontPathTimes = 'assets/fonts/times.ttf';
    String fontPathArialBold = 'assets/fonts/arial_bold.ttf';
    String fontPathTimesBold = 'assets/fonts/times_bold.ttf';

    //----------
    PdfPen pdfPen = PdfPen(PdfColor(0, 0, 0), width: 0.8);

    PdfSolidBrush pdfSolidBrush = PdfSolidBrush(PdfColor(0, 0, 0));

    PdfFont fontTimesBold = await getPdfFontFromAssets(
        assetsPath: fontPathTimesBold, fontSize: 12.0);

    PdfFont fontArialBold = await getPdfFontFromAssets(
        assetsPath: fontPathArialBold, fontSize: 9.0);

    PdfFont fontArialNormal =
        await getPdfFontFromAssets(assetsPath: fontPathArial, fontSize: 9.0);

    // --- Sayfa 1
    PdfPage page1 = document.pages.add();
    PdfGraphics graphics1 = page1.graphics;

    //------ başlık bölümü
    graphics1.drawString(
        'Barthel Günlük Yasam Aktiviteleri Indeksi', fontTimesBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(160, 5, 0, 0));

    graphics1.drawLine(pdfPen, Offset(5, 25), Offset(570, 25));

    graphics1.drawString('Parametre', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(25, 32, 0, 0));

    graphics1.drawString('Değerlendirme', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(155, 32, 0, 0));

    graphics1.drawString('Puan', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(395, 32, 0, 0));

    graphics1.drawString('Hastanın \n Puanı', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(465, 27, 0, 0));

    graphics1.drawLine(pdfPen, Offset(5, 50), Offset(570, 50));

    //-------------- beslenme bölümü

    graphics1.drawString('Beslenme', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(25, 75, 0, 0));

    graphics1.drawString(
        'Tam bağımsız yemek yemek için gerekli aletleri \n kullanabilir.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 52, 0, 0));

    graphics1.drawString('10', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(400, 55, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 55, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 75), Offset(570, 75));
    //------------------
    graphics1.drawString('Bir miktar yardıma ihtiyaç duyar.', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(155, 78, 0, 0));

    graphics1.drawString('5', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(403, 78, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 78, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 90), Offset(570, 90));

    //------------------
    graphics1.drawString('Tam Bağımlıdır.', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(155, 92, 0, 0));

    graphics1.drawString('0', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 92, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 92, 0, 0));

    graphics1.drawLine(pdfPen, Offset(5, 105), Offset(570, 105));

    //-------------------

    //-------------- yıkanma bölümü

    graphics1.drawString('Yıkanma', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(25, 120, 0, 0));

    graphics1.drawString(
        'Hasta yardımsız olarak küvette yıkanabilir, duş alabilir \n ya da keselenebilir.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 107, 0, 0));

    graphics1.drawString('5', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 110, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 110, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 130), Offset(570, 130));

    //------------------

    graphics1.drawString('Yadıma ihtiyacı vardır.', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(155, 132, 0, 0));

    graphics1.drawString('0', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 132, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 132, 0, 0));

    graphics1.drawLine(pdfPen, Offset(5, 142), Offset(570, 142));

//-------------- kendine bakım bölümü

    graphics1.drawString('Kendine Bakım', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(25, 157, 0, 0));

    graphics1.drawString(
        'Elini yüzünü yıkayabilir dişlerini fırçalayabilir, tıraş \n olabilir, makyaj yapabilir.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 144, 0, 0));

    graphics1.drawString('5', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 148, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 148, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 165), Offset(570, 165));

    //------------------

    graphics1.drawString(
        'Kişisel bakımda yardıma ihtiyaç duyar.', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(155, 168, 0, 0));

    graphics1.drawString('0', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 168, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 168, 0, 0));

    graphics1.drawLine(pdfPen, Offset(5, 180), Offset(570, 180));

//-------------- Giyinip soyunma bölümü

    graphics1.drawString('Giyinip Soyunma', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(25, 205, 0, 0));

    graphics1.drawString(
        'Hasta giyinip soyunabilir. Ayakkabı bağlarını çözebilir.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 182, 0, 0));

    graphics1.drawString('10', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(402, 182, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 182, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 194), Offset(570, 194));

    //------------------

    graphics1.drawString(
        'Yardıma gereksinim duyar (İşin en az %50’sini kendisi \n yapabilmelidir.)',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 196, 0, 0));

    graphics1.drawString('5', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 200, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 200, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 220), Offset(570, 220));

    //------------------

    graphics1.drawString('Tam Bağımlıdır.', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(155, 222, 0, 0));

    graphics1.drawString('0', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 222, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 222, 0, 0));

    graphics1.drawLine(pdfPen, Offset(5, 234), Offset(570, 234));

//-------------- Bağırsak Bakımı bölümü

    graphics1.drawString('Bağırsak Bakımı', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(25, 259, 0, 0));

    graphics1.drawString(
        'Suppozituvar kullanabilir ya da gerekirse lavman \n yapabilir.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 236, 0, 0));

    graphics1.drawString('10', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(402, 240, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 240, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 260), Offset(570, 260));

    //------------------

    graphics1.drawString(
        'Hasta belirtilen aktiviteler için yardıma gereksinim \n duyar.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 262, 0, 0));

    graphics1.drawString('5', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 266, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 266, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 286), Offset(570, 286));

    //------------------

    graphics1.drawString('İnkontinansı mevcuttur.', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(155, 288, 0, 0));

    graphics1.drawString('0', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 288, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 288, 0, 0));

    graphics1.drawLine(pdfPen, Offset(5, 300), Offset(570, 300));

//-------------- Mesane Bakımı bölümü

    graphics1.drawString('Mesane Bakımı', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(25, 325, 0, 0));

    graphics1.drawString(
        'Hasta gece ve gündüz mesanesini kontrol \n edebilmelidir. Sonda bakımını bağımsız bir şekilde \n kendisi yapabilmelidir.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 302, 0, 0));

    graphics1.drawString('10', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(402, 310, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 310, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 334), Offset(570, 334));

    //------------------

    graphics1.drawString(
        'Bazen tuvalete yetişemez ya da sürgüyü bekleyemez \n altına kaçırır.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 336, 0, 0));

    graphics1.drawString('5', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 340, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 340, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 360), Offset(570, 360));

    //------------------

    graphics1.drawString(
        'İnkontinandır veya kateterlidir ve mesanesini \n kontrol edemez.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 362, 0, 0));

    graphics1.drawString('0', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 366, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 366, 0, 0));

    graphics1.drawLine(pdfPen, Offset(5, 386), Offset(570, 386));

//-------------- Tuvalte Kullanımı bölümü

    graphics1.drawString('Tuvalet Kullanımı', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(25, 411, 0, 0));

    graphics1.drawString(
        'Duvardan ya da bardan destek alabilir tuvalet kâğıdını \n kendi kullanabilir.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 388, 0, 0));

    graphics1.drawString('10', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(402, 392, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 392, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 412), Offset(570, 412));

    //------------------

    graphics1.drawString(
        'Elbiselerini giyip çıkarmak, tuvalet kâğıdını kullanmak \n için bir miktar yardım',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 414, 0, 0));

    graphics1.drawString('5', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 418, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 418, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 438), Offset(570, 438));

    //------------------

    graphics1.drawString('Tam Bağımlıdır.', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(155, 440, 0, 0));

    graphics1.drawString('0', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 440, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 440, 0, 0));

    graphics1.drawLine(pdfPen, Offset(5, 452), Offset(570, 452));

//-------------- Tekerlekli Sandalyeden Yatağa ve Tersi Transferler bölümü

    graphics1.drawString(
        'Tekerlekli Sandalyeden \n Yatağa ve Tersi \n Transferler',
        fontArialBold,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(25, 472, 0, 0));

    graphics1.drawString('Tam bağımsızdır.', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(155, 454, 0, 0));

    graphics1.drawString('15', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(402, 454, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 454, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 466), Offset(570, 466));

    //------------------

    graphics1.drawString(
        'Geçişler sırasında minimal yardım alır (sözel veya \n fiziksel).',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 468, 0, 0));

    graphics1.drawString('10', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 472, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 472, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 492), Offset(570, 492));

    //------------------

    graphics1.drawString(
        'Tek başına yatakta oturma pozisyonuna geçebilir ama \n geçiş için yardım alır.).',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 494, 0, 0));

    graphics1.drawString('5', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 498, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 498, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 518), Offset(570, 518));

    //------------------

    graphics1.drawString('Tam Bağımlıdır.', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(155, 520, 0, 0));

    graphics1.drawString('0', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 520, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 520, 0, 0));

    graphics1.drawLine(pdfPen, Offset(5, 532), Offset(570, 532));

    // ------------------ Mobilite Yan Yazısı
    graphics1.rotateTransform(-90);

    graphics1.drawString("Mobilite", fontArialBold,
        bounds: const Rect.fromLTWH(-625, 12, 150, 20));

    graphics1.rotateTransform(90);

    //-------------- Mobilite : Düzgün Yüzeyde Yürüme bölümü

    graphics1.drawString('Düzgün Yüzeyde \n Yürüme', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(30, 565, 0, 0));

    graphics1.drawString(
        'Hasta yardımsız olarak 45 metre yürüyebilir.' +
            'Birey, \n baston, koltuk değneği, yürüteç kullanabilir. \n' +
            '(Birey kullanıyorsa kilitleyip açabilmeli, oturup \n kalkabilmeli,' +
            ' mekanik destekleri yardımsız \n kullanabilmelidir.)',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 534, 0, 0));

    graphics1.drawString('15', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(402, 550, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 550, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 585), Offset(570, 585));

//------------------

    graphics1.drawString(
        'Hasta bir kişinin sözel veya fiziksel yardımıyla 45 metre \n yürüyebilir.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 587, 0, 0));

    graphics1.drawString('10', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(402, 591, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 591, 0, 0));

    graphics1.drawLine(pdfPen, Offset(25, 611), Offset(570, 611));

    //-------------- Mobilite : Tekerlekli Sandalyeyi Kullanabilme (Uygunsa) bölümü

    graphics1.drawString(
        'Tekerlekli \n Sandalyeyi \n Kullanabilme \n (Uygunsa)', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(30, 618, 0, 0));

    graphics1.drawString(
        'Hasta yürüyemez ama tekerlekli sandalyeyi \n kullanabilir.' +
            'Hasta köşeleri dönebilir. Yatağa, tuvalete \n yanaşabilir.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 613, 0, 0));

    graphics1.drawString('5', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(402, 622, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 622, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 647), Offset(570, 647));

    //------------------

    graphics1.drawString(
        'Tekerlekli sandalyede oturabilir ancak kullanamaz.', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(155, 649, 0, 0));

    graphics1.drawString('0', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 649, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 649, 0, 0));

    graphics1.drawLine(pdfPen, Offset(5, 661), Offset(570, 661));

    //-------------- Merdiven İnip Çıkma bölümü

    graphics1.drawString('Merdiven İnip Çıkma', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(25, 685, 0, 0));

    graphics1.drawString(
        'Bağımsız inip çıkabilir, ancak destek kullanabilir \n (tırabzan, baston, koltuk değneği…)',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 663, 0, 0));

    graphics1.drawString('10', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(402, 667, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 667, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 687), Offset(570, 687));

    //------------------

    graphics1.drawString(
        'Hasta yukardaki işleri yapmak için yardıma veya \n gözetime ihtiyaç duyar.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(155, 689, 0, 0));

    graphics1.drawString('5', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 693, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 693, 0, 0));

    graphics1.drawLine(pdfPen, Offset(155, 713), Offset(570, 713));

    //------------------

    graphics1.drawString('Yapamaz.', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(155, 715, 0, 0));

    graphics1.drawString('0', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(404, 715, 0, 0));

    graphics1.drawString('X', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(475, 715, 0, 0));

    graphics1.drawLine(pdfPen, Offset(5, 727), Offset(570, 727));

    // --- Sayfa 2

    PdfPage page2 = document.pages.add();

    PdfGraphics graphics2 = page2.graphics;

    //------ başlık bölümü
    graphics2.drawString(
        'Barthel Günlük Yasam Aktiviteleri Indeksi', fontTimesBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(160, 5, 0, 0));

    // --- Hasta Adı Soyadı Bölümü

    graphics2.drawString('Hastanın Adı Soyadı : OSMAN BARUTÇU', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(2, 80, 0, 0));

    // ---- tarih saat bölümü
    graphics2.drawString('Tarih/Saat : 20.12.2022 -/- 00:48', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(2, 100, 0, 0));

    // ---- hasta yakını adı soyadı  bölümü
    graphics2.drawString(
        'Bilgi Alınan Kişi Adı-Soyadı : İBRAHİM BARUTÇU', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(2, 120, 0, 0));

    // ---- hasta yakını yakınlık derecesi  bölümü
    graphics2.drawString('Bilgi Alınan Kişinin Yakınlığı : OĞLU', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(2, 140, 0, 0));

    // ---- hasta indeks puanı toplamı bölümü
    graphics2.drawString(
        'Hastanın Toplam Puanı (0-100) * : 100 \n', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(2, 160, 0, 0));

    //-------------
    graphics2.drawString(
        '* Hastanın toplam puanı yazılmalıdır.', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(2, 170, 0, 0));

    // tablo kısmı
    final PdfGrid grid = PdfGrid();
    grid.style.font = fontArialNormal;
    String tikIsareti = ' \t \t \t         X';
// Specify the grid column count.
    grid.columns.add(count: 2);
// Add a grid header row.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Hastanın Puan Aralığı';
    headerRow.cells[1].value = 'Durum Değerlendirmesi**';
// Set header font.
// Add rows to the grid.
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = '  0-20: Tam Bağımlı';
    row.cells[1].value = tikIsareti;
// Add next row.
    row = grid.rows.add();
    row.cells[0].value = '  21-61: İleri Derecede Bağımlı';
    row.cells[1].value = tikIsareti;
// Add next row.
    row = grid.rows.add();
    row.cells[0].value = '  62-90: Orta Derecede Bağımlı';
    row.cells[1].value = tikIsareti;
    // Add next row.
    row = grid.rows.add();
    row.cells[0].value = '  91-99: Hafif Derecede Bağımlı';
    row.cells[1].value = tikIsareti;
    // Add next row.
    row = grid.rows.add();
    row.cells[0].value = '  100: Tam Bağımsız';
    row.cells[1].value = tikIsareti;
// Set grid format.
    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
// Draw table in the PDF page.
    grid.draw(
        page: page2,
        bounds: Rect.fromLTWH(
            2, 200, page2.getClientSize().width, page2.getClientSize().height));

//------------------tablonun dip not bölümü
    graphics2.drawString(
        '** Hastanın toplam puanına göre hangi grupta yer aldığı işaretlenmelidir.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(5, 320, 0, 0));

    // ---- açıklama bölümü
    graphics2.drawString('Açıklama :', fontArialBold,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(2, 400, 0, 0));

    //-------------
    graphics2.drawString(
        'Bir bireyin fonksiyonel bağımsızlığını gösteren, günlük yaşam aktivitelerindeki bağımlı veya bağımsız',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(50, 400, 0, 0));

    graphics2.drawString(
        'olma durumlarını sınıflandırmak amacıyla kullanılmaktadır. Günlük yaşam aktiviteleri indeksi bir hastanın neler \n' +
            'yapabileceğideğil, neleryaptığının kaydedilmesidir. Hasta veya hastanın bakımını üstelenen bireylerden bilgi \n' +
            'alınarak düzenlenebilir. Genellikle hastanın son 24-48 saat içindeki performansı esas alınır.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(2, 410, 0, 0));

    //------ Kaynaklar bölümü
    graphics2.drawString('Kaynaklar :', fontArialNormal,
        brush: pdfSolidBrush, bounds: Rect.fromLTWH(2, 480, 0, 0));

    graphics2.drawString(
        '1.	Collin, C., Wade, D. T., Davies, S., &Horne, V. (1988). TheBarthel ADL Index: a reliabilitystudy. International \n' +
            '       disabilitystudies, 10(2), 61–63. https://doi.org/10.3109/09638288809164103',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(12, 495, 0, 0));

    graphics2.drawString(
        '2.	Küçükdeveci, A. A., Yavuzer, G., Tennant, A., Süldür, N., Sonel, B., &Arasil, T. (2000). Adaptation of \n' +
            '       themodifiedBarthel Index foruse in physicalmedicineandrehabilitation in Turkey. Scandinavianjournal of  \n' +
            '       rehabilitationmedicine, 32(2), 87–92.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(12, 520, 0, 0));

    graphics2.drawString(
        '3.	Mahoney, F. I., &Barthel, D. W. (1965). FunctıonalEvaluatıon: TheBarthel Index. Maryland statemedicaljournal, 14,  \n' +
            '       61–65.',
        fontArialNormal,
        brush: pdfSolidBrush,
        bounds: Rect.fromLTWH(12, 550, 0, 0));

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

  Future<PdfFont> getPdfFontFromAssets(
      {required String assetsPath, required double fontSize}) async {
    var a = await DefaultAssetBundle.of(context).load(assetsPath);

    return PdfTrueTypeFont(a.buffer.asUint8List(a.offsetInBytes), fontSize);
  }
}
