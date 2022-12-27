// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_final_fields
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_excel_workshop/esh_activity_index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfManager {
  PdfManager({required this.context});

  BuildContext context;

  String _fontPathArial = 'assets/fonts/arial.ttf';
  String _fontPathArialBold = 'assets/fonts/arial_bold.ttf';
  String _fontPathTimesBold = 'assets/fonts/times_bold.ttf';
  String _tick = 'X';
  PdfPen pdfPen = PdfPen(PdfColor(0, 0, 0), width: 0.8);
  PdfSolidBrush pdfSolidBrush = PdfSolidBrush(PdfColor(0, 0, 0));
  late final PdfFont _fontTimesBold;
  late final PdfFont _fontArialBold;
  late final PdfFont _fontArialNormal;

  Future<void> populateInstances() async {
    _fontTimesBold = await _getPdfFontFromAssets(
        assetsPath: _fontPathTimesBold, fontSize: 12.0);

    _fontArialBold = await _getPdfFontFromAssets(
        assetsPath: _fontPathArialBold, fontSize: 9.0);

    _fontArialNormal =
        await _getPdfFontFromAssets(assetsPath: _fontPathArial, fontSize: 9.0);
  }

  Future<PdfFont> _getPdfFontFromAssets(
      {required String assetsPath, required double fontSize}) async {
    var a = await DefaultAssetBundle.of(context).load(assetsPath);
    return PdfTrueTypeFont(a.buffer.asUint8List(a.offsetInBytes), fontSize);
  }

  PdfDocument getPdfDocumentByEshActivityIndex(EshActivityIndex activityIndex) {
    final PdfDocument document = PdfDocument();

    // --- Sayfa 1
    PdfPage page1 = document.pages.add();
    PdfGraphics graphics1 = page1.graphics;

    //------ başlık bölümü
    graphics1.drawString(
        'Barthel Günlük Yasam Aktiviteleri Indeksi', _fontTimesBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(160, 5, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(5, 25), const Offset(570, 25));

    graphics1.drawString('Parametre', _fontArialBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(25, 32, 0, 0));

    graphics1.drawString('Değerlendirme', _fontArialBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(155, 32, 0, 0));

    graphics1.drawString('Puan', _fontArialBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(395, 32, 0, 0));

    graphics1.drawString('Hastanın \n Puanı', _fontArialBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(465, 27, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(5, 50), const Offset(570, 50));

    //-------------- beslenme bölümü

    graphics1.drawString('Beslenme', _fontArialBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(25, 75, 0, 0));

    graphics1.drawString(
        'Tam bağımsız yemek yemek için gerekli aletleri \n kullanabilir.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 52, 0, 0));

    graphics1.drawString('10', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(400, 55, 0, 0));

    // graphics1.drawString(_tick, _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 55, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 75), const Offset(570, 75));
    //------------------
    graphics1.drawString('Bir miktar yardıma ihtiyaç duyar.', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(155, 78, 0, 0));

    graphics1.drawString('5', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(403, 78, 0, 0));

    // graphics1.drawString(_tick, _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 78, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 90), const Offset(570, 90));

    //------------------
    graphics1.drawString('Tam Bağımlıdır.', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(155, 92, 0, 0));

    graphics1.drawString('0', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 92, 0, 0));

    // graphics1.drawString(_tick, _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 92, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(5, 105), const Offset(570, 105));

    //------------------- indeks değerlendirme kısmı

    Rect? rect;
    switch (activityIndex.beslenmeParametresi) {
      case 10:
        rect = const Rect.fromLTWH(475, 55, 0, 0);
        break;
      case 5:
        rect = const Rect.fromLTWH(475, 78, 0, 0);
        break;
      case 0:
        rect = const Rect.fromLTWH(475, 92, 0, 0);
        break;
      default:
        rect = const Rect.fromLTWH(475, 55, 0, 0);
    }

    graphics1.drawString(_tick, _fontArialNormal,
        brush: pdfSolidBrush, bounds: rect);

    //-------------- yıkanma bölümü

    graphics1.drawString('Yıkanma', _fontArialBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(25, 120, 0, 0));

    graphics1.drawString(
        'Hasta yardımsız olarak küvette yıkanabilir, duş alabilir \n ya da keselenebilir.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 107, 0, 0));

    graphics1.drawString('5', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 110, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 110, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 130), const Offset(570, 130));

    //------------------

    graphics1.drawString('Yadıma ihtiyacı vardır.', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(155, 132, 0, 0));

    graphics1.drawString('0', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 132, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 132, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(5, 142), const Offset(570, 142));

    //------------------- indeks değerlendirme kısmı

    Rect? rect1;
    switch (activityIndex.yikanmaParametresi) {
      case 5:
        rect1 = const Rect.fromLTWH(475, 110, 0, 0);
        break;
      case 0:
        rect1 = const Rect.fromLTWH(475, 132, 0, 0);
        break;
      default:
        rect1 = const Rect.fromLTWH(475, 110, 0, 0);
    }

    graphics1.drawString(_tick, _fontArialNormal,
        brush: pdfSolidBrush, bounds: rect1);

//-------------- kendine bakım bölümü

    graphics1.drawString('Kendine Bakım', _fontArialBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(25, 157, 0, 0));

    graphics1.drawString(
        'Elini yüzünü yıkayabilir dişlerini fırçalayabilir, tıraş \n olabilir, makyaj yapabilir.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 144, 0, 0));

    graphics1.drawString('5', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 148, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 148, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 165), const Offset(570, 165));

    //------------------

    graphics1.drawString(
        'Kişisel bakımda yardıma ihtiyaç duyar.', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(155, 168, 0, 0));

    graphics1.drawString('0', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 168, 0, 0));

    // graphics1.drawString('X', _fontArialNormal,brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 168, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(5, 180), const Offset(570, 180));

    //------------------- indeks değerlendirme kısmı

    Rect? rect2;
    switch (activityIndex.kendineBakimParametresi) {
      case 5:
        rect2 = const Rect.fromLTWH(475, 148, 0, 0);
        break;
      case 0:
        rect2 = const Rect.fromLTWH(475, 168, 0, 0);
        break;
      default:
        rect2 = const Rect.fromLTWH(475, 148, 0, 0);
    }

    graphics1.drawString(_tick, _fontArialNormal,
        brush: pdfSolidBrush, bounds: rect2);

//-------------- Giyinip soyunma bölümü

    graphics1.drawString('Giyinip Soyunma', _fontArialBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(25, 205, 0, 0));

    graphics1.drawString(
        'Hasta giyinip soyunabilir. Ayakkabı bağlarını çözebilir.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 182, 0, 0));

    graphics1.drawString('10', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(402, 182, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 182, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 194), const Offset(570, 194));

    //------------------

    graphics1.drawString(
        'Yardıma gereksinim duyar (İşin en az %50’sini kendisi \n yapabilmelidir.)',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 196, 0, 0));

    graphics1.drawString('5', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 200, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 200, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 220), const Offset(570, 220));

    //------------------

    graphics1.drawString('Tam Bağımlıdır.', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(155, 222, 0, 0));

    graphics1.drawString('0', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 222, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 222, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(5, 234), const Offset(570, 234));

    //------------------- indeks değerlendirme kısmı

    Rect? rect3;
    switch (activityIndex.giyipSoyunmaParametresi) {
      case 10:
        rect3 = const Rect.fromLTWH(475, 182, 0, 0);
        break;
      case 5:
        rect3 = const Rect.fromLTWH(475, 200, 0, 0);
        break;
      case 0:
        rect3 = const Rect.fromLTWH(475, 222, 0, 0);
        break;
      default:
        rect3 = const Rect.fromLTWH(475, 182, 0, 0);
    }

    graphics1.drawString(_tick, _fontArialNormal,
        brush: pdfSolidBrush, bounds: rect3);

//-------------- Bağırsak Bakımı bölümü

    graphics1.drawString('Bağırsak Bakımı', _fontArialBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(25, 259, 0, 0));

    graphics1.drawString(
        'Suppozituvar kullanabilir ya da gerekirse lavman \n yapabilir.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 236, 0, 0));

    graphics1.drawString('10', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(402, 240, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 240, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 260), const Offset(570, 260));

    //------------------

    graphics1.drawString(
        'Hasta belirtilen aktiviteler için yardıma gereksinim \n duyar.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 262, 0, 0));

    graphics1.drawString('5', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 266, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 266, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 286), const Offset(570, 286));

    //------------------

    graphics1.drawString('İnkontinansı mevcuttur.', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(155, 288, 0, 0));

    graphics1.drawString('0', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 288, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 288, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(5, 300), const Offset(570, 300));

    //------------------- indeks değerlendirme kısmı

    Rect? rect4;
    switch (activityIndex.bagirsakBakimiParametresi) {
      case 10:
        rect4 = const Rect.fromLTWH(475, 240, 0, 0);
        break;
      case 5:
        rect4 = const Rect.fromLTWH(475, 266, 0, 0);
        break;
      case 0:
        rect4 = const Rect.fromLTWH(475, 288, 0, 0);
        break;
      default:
        rect4 = const Rect.fromLTWH(475, 240, 0, 0);
    }

    graphics1.drawString(_tick, _fontArialNormal,
        brush: pdfSolidBrush, bounds: rect4);

//-------------- Mesane Bakımı bölümü

    graphics1.drawString('Mesane Bakımı', _fontArialBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(25, 325, 0, 0));

    graphics1.drawString(
        'Hasta gece ve gündüz mesanesini kontrol \n edebilmelidir. Sonda bakımını bağımsız bir şekilde \n kendisi yapabilmelidir.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 302, 0, 0));

    graphics1.drawString('10', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(402, 310, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 310, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 334), const Offset(570, 334));

    //------------------

    graphics1.drawString(
        'Bazen tuvalete yetişemez ya da sürgüyü bekleyemez \n altına kaçırır.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 336, 0, 0));

    graphics1.drawString('5', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 340, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 340, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 360), const Offset(570, 360));

    //------------------

    graphics1.drawString(
        'İnkontinandır veya kateterlidir ve mesanesini \n kontrol edemez.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 362, 0, 0));

    graphics1.drawString('0', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 366, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 366, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(5, 386), const Offset(570, 386));

    //------------------- indeks değerlendirme kısmı

    Rect? rect5;
    switch (activityIndex.mesaneBakimiParametresi) {
      case 10:
        rect5 = const Rect.fromLTWH(475, 310, 0, 0);
        break;
      case 5:
        rect5 = const Rect.fromLTWH(475, 340, 0, 0);
        break;
      case 0:
        rect5 = const Rect.fromLTWH(475, 366, 0, 0);
        break;
      default:
        rect5 = const Rect.fromLTWH(475, 310, 0, 0);
    }

    graphics1.drawString(_tick, _fontArialNormal,
        brush: pdfSolidBrush, bounds: rect5);

//-------------- Tuvalte Kullanımı bölümü

    graphics1.drawString('Tuvalet Kullanımı', _fontArialBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(25, 411, 0, 0));

    graphics1.drawString(
        'Duvardan ya da bardan destek alabilir tuvalet kâğıdını \n kendi kullanabilir.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 388, 0, 0));

    graphics1.drawString('10', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(402, 392, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 392, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 412), const Offset(570, 412));

    //------------------

    graphics1.drawString(
        'Elbiselerini giyip çıkarmak, tuvalet kâğıdını kullanmak \n için bir miktar yardım',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 414, 0, 0));

    graphics1.drawString('5', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 418, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 418, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 438), const Offset(570, 438));

    //------------------

    graphics1.drawString('Tam Bağımlıdır.', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(155, 440, 0, 0));

    graphics1.drawString('0', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 440, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 440, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(5, 452), const Offset(570, 452));

    //------------------- indeks değerlendirme kısmı

    Rect? rect6;
    switch (activityIndex.tuvaletKullanimiParametresi) {
      case 10:
        rect6 = const Rect.fromLTWH(475, 392, 0, 0);
        break;
      case 5:
        rect6 = const Rect.fromLTWH(475, 418, 0, 0);
        break;
      case 0:
        rect6 = const Rect.fromLTWH(475, 440, 0, 0);
        break;
      default:
        rect6 = const Rect.fromLTWH(475, 392, 0, 0);
    }

    graphics1.drawString(_tick, _fontArialNormal,
        brush: pdfSolidBrush, bounds: rect6);

//-------------- Tekerlekli Sandalyeden Yatağa ve Tersi Transferler bölümü

    graphics1.drawString(
        'Tekerlekli Sandalyeden \n Yatağa ve Tersi \n Transferler',
        _fontArialBold,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(25, 472, 0, 0));

    graphics1.drawString('Tam bağımsızdır.', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(155, 454, 0, 0));

    graphics1.drawString('15', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(402, 454, 0, 0));

    //  graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 454, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 466), const Offset(570, 466));

    //------------------

    graphics1.drawString(
        'Geçişler sırasında minimal yardım alır (sözel veya \n fiziksel).',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 468, 0, 0));

    graphics1.drawString('10', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 472, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 472, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 492), const Offset(570, 492));

    //------------------

    graphics1.drawString(
        'Tek başına yatakta oturma pozisyonuna geçebilir ama \n geçiş için yardım alır.).',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 494, 0, 0));

    graphics1.drawString('5', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 498, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 498, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 518), const Offset(570, 518));

    //------------------

    graphics1.drawString('Tam Bağımlıdır.', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(155, 520, 0, 0));

    graphics1.drawString('0', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 520, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 520, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(5, 532), const Offset(570, 532));

    //------------------- indeks değerlendirme kısmı

    Rect? rect7;
    switch (activityIndex.tekerlekliSandalyedenTransferParametresi) {
      case 15:
        rect7 = const Rect.fromLTWH(475, 454, 0, 0);
        break;
      case 10:
        rect7 = const Rect.fromLTWH(475, 472, 0, 0);
        break;
      case 5:
        rect7 = const Rect.fromLTWH(475, 498, 0, 0);
        break;
      case 0:
        rect7 = const Rect.fromLTWH(475, 520, 0, 0);
        break;
      default:
        rect7 = const Rect.fromLTWH(475, 472, 0, 0);
    }

    graphics1.drawString(_tick, _fontArialNormal,
        brush: pdfSolidBrush, bounds: rect7);

    // ------------------ Mobilite Yan Yazısı
    graphics1.rotateTransform(-90);

    graphics1.drawString("Mobilite", _fontArialBold,
        bounds: const Rect.fromLTWH(-625, 12, 150, 20));

    graphics1.rotateTransform(90);

    //-------------- Mobilite : Düzgün Yüzeyde Yürüme bölümü

    graphics1.drawString('Düzgün Yüzeyde \n Yürüme', _fontArialBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(30, 565, 0, 0));

    graphics1.drawString(
        'Hasta yardımsız olarak 45 metre yürüyebilir.' +
            'Birey, \n baston, koltuk değneği, yürüteç kullanabilir. \n' +
            '(Birey kullanıyorsa kilitleyip açabilmeli, oturup \n kalkabilmeli,' +
            ' mekanik destekleri yardımsız \n kullanabilmelidir.)',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 534, 0, 0));

    graphics1.drawString('15', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(402, 550, 0, 0));

    // graphics1.drawString('X', _fontArialNormal,  brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 550, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 585), const Offset(570, 585));

//------------------

    graphics1.drawString(
        'Hasta bir kişinin sözel veya fiziksel yardımıyla 45 metre \n yürüyebilir.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 587, 0, 0));

    graphics1.drawString('10', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(402, 591, 0, 0));

    //  graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 591, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(25, 611), const Offset(570, 611));

    //-------------- Mobilite : Tekerlekli Sandalyeyi Kullanabilme (Uygunsa) bölümü

    graphics1.drawString(
        'Tekerlekli \n Sandalyeyi \n Kullanabilme \n (Uygunsa)', _fontArialBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(30, 618, 0, 0));

    graphics1.drawString(
        'Hasta yürüyemez ama tekerlekli sandalyeyi \n kullanabilir.' +
            'Hasta köşeleri dönebilir. Yatağa, tuvalete \n yanaşabilir.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 613, 0, 0));

    graphics1.drawString('5', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(402, 622, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 622, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 647), const Offset(570, 647));

    //------------------

    graphics1.drawString(
        'Tekerlekli sandalyede oturabilir ancak kullanamaz.', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(155, 649, 0, 0));

    graphics1.drawString('0', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 649, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 649, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(5, 661), const Offset(570, 661));

    //------------------- indeks değerlendirme kısmı

    Rect? rect8;
    switch (activityIndex.mobiliteParametresi) {
      case 15:
        rect8 = const Rect.fromLTWH(475, 550, 0, 0);
        break;
      case 10:
        rect8 = const Rect.fromLTWH(475, 591, 0, 0);
        break;
      case 5:
        rect8 = const Rect.fromLTWH(475, 622, 0, 0);
        break;
      case 0:
        rect8 = const Rect.fromLTWH(475, 649, 0, 0);
        break;
      default:
        rect8 = const Rect.fromLTWH(475, 550, 0, 0);
    }

    graphics1.drawString(_tick, _fontArialNormal,
        brush: pdfSolidBrush, bounds: rect8);

    //-------------- Merdiven İnip Çıkma bölümü

    graphics1.drawString('Merdiven İnip Çıkma', _fontArialBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(25, 685, 0, 0));

    graphics1.drawString(
        'Bağımsız inip çıkabilir, ancak destek kullanabilir \n (tırabzan, baston, koltuk değneği…)',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 663, 0, 0));

    graphics1.drawString('10', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(402, 667, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 667, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 687), const Offset(570, 687));

    //------------------

    graphics1.drawString(
        'Hasta yukardaki işleri yapmak için yardıma veya \n gözetime ihtiyaç duyar.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(155, 689, 0, 0));

    graphics1.drawString('5', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 693, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 693, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(155, 713), const Offset(570, 713));

    //------------------

    graphics1.drawString('Yapamaz.', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(155, 715, 0, 0));

    graphics1.drawString('0', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(404, 715, 0, 0));

    // graphics1.drawString('X', _fontArialNormal, brush: pdfSolidBrush, bounds: const Rect.fromLTWH(475, 715, 0, 0));

    graphics1.drawLine(pdfPen, const Offset(5, 727), const Offset(570, 727));

    //------------------- indeks değerlendirme kısmı

    Rect? rect9;
    switch (activityIndex.merdivenInipCikmaParametresi) {
      case 10:
        rect9 = const Rect.fromLTWH(475, 667, 0, 0);
        break;
      case 5:
        rect9 = const Rect.fromLTWH(475, 693, 0, 0);
        break;
      case 0:
        rect9 = const Rect.fromLTWH(475, 715, 0, 0);
        break;
      default:
        rect9 = const Rect.fromLTWH(475, 667, 0, 0);
    }

    graphics1.drawString(_tick, _fontArialNormal,
        brush: pdfSolidBrush, bounds: rect9);

    // --- Sayfa 2

    PdfPage page2 = document.pages.add();

    PdfGraphics graphics2 = page2.graphics;

    //------ başlık bölümü
    graphics2.drawString(
        'Barthel Günlük Yasam Aktiviteleri Indeksi', _fontTimesBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(160, 5, 0, 0));

    // --- Hasta Adı Soyadı Bölümü

    graphics2.drawString(
        'Hastanın Adı Soyadı : ${activityIndex.hastaAdi.toUpperCase()}  ${activityIndex.hastaSoyadi.toUpperCase()}',
        _fontArialBold,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(2, 80, 0, 0));

    // ---- tarih saat bölümü
    graphics2.drawString(
        'Tarih/Saat : ${activityIndex.islemTarih} - / -  ${activityIndex.islemSaati}',
        _fontArialBold,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(2, 100, 0, 0));

    // ---- hasta yakını adı soyadı  bölümü
    graphics2.drawString(
        'Bilgi Alınan Kişi Adı-Soyadı : ${activityIndex.hastaYakiniAdi.toUpperCase()}  ${activityIndex.hastaYakiniSoyadi.toUpperCase()}',
        _fontArialBold,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(2, 120, 0, 0));

    // ---- hasta yakını yakınlık derecesi  bölümü
    graphics2.drawString(
        'Bilgi Alınan Kişinin Yakınlığı : ${activityIndex.hastaYakinlikDerecesi.toUpperCase()}',
        _fontArialBold,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(2, 140, 0, 0));

    // ---- hasta indeks puanı toplamı bölümü
    graphics2.drawString(
        'Hastanın Toplam Puanı (0-100) * : ${activityIndex.indexToplamPuanHesapla()} \n',
        _fontArialBold,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(2, 160, 0, 0));

    //-------------
    graphics2.drawString(
        '* Hastanın toplam puanı yazılmalıdır.', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(2, 170, 0, 0));

    // tablo kısmı
    final PdfGrid grid = PdfGrid();
    grid.style.font = _fontArialNormal;
    String tikIsareti = ' \t \t \t         $_tick';
// Specify the grid column count.
    grid.columns.add(count: 2);
// Add a grid header row.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Hastanın Puan Aralığı';
    headerRow.cells[1].value = 'Durum Değerlendirmesi**';
// Set header font.
// Add rows to the grid.
    PdfGridRow row1 = grid.rows.add();
    row1.cells[0].value = '  0-20: Tam Bağımlı';
    // row1.cells[1].value = tikIsareti;
// Add next row.
    PdfGridRow row2 = grid.rows.add();
    row2.cells[0].value = '  21-61: İleri Derecede Bağımlı';
    // row2.cells[1].value = tikIsareti;
// Add next row.
    PdfGridRow row3 = grid.rows.add();
    row3.cells[0].value = '  62-90: Orta Derecede Bağımlı';
    // row3.cells[1].value = tikIsareti;
    // Add next row.
    PdfGridRow row4 = grid.rows.add();
    row4.cells[0].value = '  91-99: Hafif Derecede Bağımlı';
    // row4.cells[1].value = tikIsareti;
    // Add next row.
    PdfGridRow row5 = grid.rows.add();
    row5.cells[0].value = '  100: Tam Bağımsız';
    // row5.cells[1].value = tikIsareti;

    // tablo değerlendirme seçim kısmı

    int puan = activityIndex.indexToplamPuanHesapla();
    if (puan < 21) {
      row1.cells[1].value = tikIsareti;
    } else if (puan < 62 && puan > 21) {
      row2.cells[1].value = tikIsareti;
    } else if (puan < 91 && puan > 61) {
      row3.cells[1].value = tikIsareti;
    } else if (puan < 100 && puan > 91) {
      row4.cells[1].value = tikIsareti;
    } else if (puan == 100) {
      row5.cells[1].value = tikIsareti;
    }

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
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(5, 320, 0, 0));

    // ---- açıklama bölümü
    graphics2.drawString('Açıklama :', _fontArialBold,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(2, 400, 0, 0));

    //-------------
    graphics2.drawString(
        'Bir bireyin fonksiyonel bağımsızlığını gösteren, günlük yaşam aktivitelerindeki bağımlı veya bağımsız',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(50, 400, 0, 0));

    graphics2.drawString(
        'olma durumlarını sınıflandırmak amacıyla kullanılmaktadır. Günlük yaşam aktiviteleri indeksi bir hastanın neler \n' +
            'yapabileceğideğil, neleryaptığının kaydedilmesidir. Hasta veya hastanın bakımını üstelenen bireylerden bilgi \n' +
            'alınarak düzenlenebilir. Genellikle hastanın son 24-48 saat içindeki performansı esas alınır.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(2, 410, 0, 0));

    //------ Kaynaklar bölümü
    graphics2.drawString('Kaynaklar :', _fontArialNormal,
        brush: pdfSolidBrush, bounds: const Rect.fromLTWH(2, 480, 0, 0));

    graphics2.drawString(
        '1.	Collin, C., Wade, D. T., Davies, S., &Horne, V. (1988). TheBarthel ADL Index: a reliabilitystudy. International \n' +
            '       disabilitystudies, 10(2), 61–63. https://doi.org/10.3109/09638288809164103',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(12, 495, 0, 0));

    graphics2.drawString(
        '2.	Küçükdeveci, A. A., Yavuzer, G., Tennant, A., Süldür, N., Sonel, B., &Arasil, T. (2000). Adaptation of \n' +
            '       themodifiedBarthel Index foruse in physicalmedicineandrehabilitation in Turkey. Scandinavianjournal of  \n' +
            '       rehabilitationmedicine, 32(2), 87–92.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(12, 520, 0, 0));

    graphics2.drawString(
        '3.	Mahoney, F. I., &Barthel, D. W. (1965). FunctıonalEvaluatıon: TheBarthel Index. Maryland statemedicaljournal, 14,  \n' +
            '       61–65.',
        _fontArialNormal,
        brush: pdfSolidBrush,
        bounds: const Rect.fromLTWH(12, 550, 0, 0));

    //  document.dispose();
    return document;
  }

  Future<void> saveAllPdf(
      {required String folderName,
      required List<EshActivityIndex> allActivtyIndex,
      Function(int progress)? onProgress}) async {
    String folder = "";
    await getExternalStorageDirectory()
        .then((value) => folder = '${value!.path}/$folderName');

    Directory directory = Directory(folder);

    if (!await directory.exists()) {
      await directory.create();
    }

    PdfDocument document;
    List<int> bytes;
    File file;
    int b = 1;
    int length = allActivtyIndex.length;
    EshActivityIndex element;
    for (int i = 0; i < length; i++) {
      element = allActivtyIndex.elementAt(i);
      file = File(
          '$folder/${element.hastaAdi}_${element.hastaSoyadi}_${element.hastaTcKimlikNo}.pdf');
      document = getPdfDocumentByEshActivityIndex(element);
      bytes = await document.save();
      //  document.dispose();
      await file.writeAsBytes(bytes, flush: true);
      if (onProgress != null) {
        onProgress.call(((b * 100) / length).round());
        b++;
      }
    }
  }

  List<File> _getFilesFromEshActivities(
      {required List<EshActivityIndex> allActivities,
      required String folderName}) {
    List<File> allFiles = [];
    for (var element in allActivities) {
      allFiles.add(
          File('$folderName/${element.hastaAdi} ${element.hastaSoyadi}.pdf'));
 
    }

    return allFiles;
  }

}
