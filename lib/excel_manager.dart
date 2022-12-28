import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'esh_activity_index.dart';

class ExcelManager {
  final fileName = '';
  final sheetName = 'indeks_veri_tüm_listesi';

  Future<Excel?> selectExcelFile() async {
    await FilePicker.platform.clearTemporaryFiles();
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);

    Excel? excel;
    if (result != null) {
      PlatformFile file = result.files.first;

      var bytess = await File(file.path ?? '').readAsBytes();
      excel = Excel.decodeBytes((bytess.buffer.asInt8List()));
    }
    return excel;
  }

  Future<List<EshActivityIndex>?> getEshActivityIndexListFromExcelFile(
      {Function(int progress)? onProgress,
      Function(bool isStarted)? isStarted}) async {
    var excel = await selectExcelFile();

    if (excel != null) {
      List<EshActivityIndex> allIndexlist = [];
      EshActivityIndex eshActivityIndex;
      int index = 0;
      int length = excel.tables[sheetName]!.rows.length;

      if (isStarted != null) {
        isStarted.call(true);
      }

      for (var element in excel.tables[sheetName]!.rows) {
        if (index > 0) {
          eshActivityIndex = EshActivityIndex();
          if (element.elementAt(2) == null) {
            break;
          }

          eshActivityIndex.hastaAdi = element.elementAt(2)!.value.toString();
          eshActivityIndex.hastaSoyadi = element.elementAt(3)!.value.toString();
          eshActivityIndex.hastaTcKimlikNo =
              element.elementAt(1)!.value.toString();
          eshActivityIndex.hastaCinsiyet =
              (element.elementAt(6)!.value) == 'E' ? 'ERKEK' : 'KADIN';
          eshActivityIndex.islemTarih = element.elementAt(8)!.value.toString();
          eshActivityIndex.islemSaati = element.elementAt(9)!.value.toString();
          eshActivityIndex.hastaAdresAciklama =
              element.elementAt(10)!.value.toString();
          eshActivityIndex.hastaAdresIl =
              element.elementAt(11)!.value.toString();
          eshActivityIndex.hastaAdresIlce =
              element.elementAt(12)!.value.toString();
          eshActivityIndex.hastaAdresMahalle =
              element.elementAt(13)!.value.toString();
          eshActivityIndex.hastaAdresSokakCadde =
              element.elementAt(14)!.value.toString();
          eshActivityIndex.hastaAdresKapiNo =
              element.elementAt(16)!.value.toString();
          eshActivityIndex.hastaYakiniAdi =
              element.elementAt(20)!.value.toString();
          eshActivityIndex.hastaYakiniSoyadi =
              element.elementAt(21)!.value.toString();
          eshActivityIndex.hastaYakinlikDerecesi =
              element.elementAt(22)!.value.toString();
          eshActivityIndex.beslenmeParametresi = element.elementAt(23)!.value;
          eshActivityIndex.yikanmaParametresi = element.elementAt(24)!.value;
          eshActivityIndex.kendineBakimParametresi =
              element.elementAt(25)!.value;
          eshActivityIndex.giyipSoyunmaParametresi =
              element.elementAt(26)!.value;
          eshActivityIndex.bagirsakBakimiParametresi =
              element.elementAt(27)!.value;
          eshActivityIndex.mesaneBakimiParametresi =
              element.elementAt(28)!.value;
          eshActivityIndex.tuvaletKullanimiParametresi =
              element.elementAt(29)!.value;
          eshActivityIndex.tekerlekliSandalyedenTransferParametresi =
              element.elementAt(30)!.value;
          eshActivityIndex.mobiliteParametresi = element.elementAt(31)!.value;
          eshActivityIndex.merdivenInipCikmaParametresi =
              element.elementAt(32)!.value;

          allIndexlist.add(eshActivityIndex);

          //---------------
          if (onProgress != null) {
            int _progres = (((index + 1) * 100) / length).ceil();
            onProgress.call(_progres);

            //-------------
          }
          //-------------

        }
        index++;
      }

      return allIndexlist;
    } else {
      return null;
    }
  }

  void _baslikEkle(Sheet sheet) {
    int row = 0;

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .value = 'IL';

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
        .value = 'SAĞLIK TESİSİ BİRİM ADI';

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
        .value = 'HASTANIN ADI SOYADI';

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
        .value = 'HASTA KİMLİK NO';

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
        .value = 'HASTA ADRESİ';

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
        .value = 'GÜNLÜK YAŞAM AKTİVİTE TOPLAM PUANI';

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row))
        .value = 'BAĞIMLILIK DURUMU';
  }

  void _satirEkle(Sheet sheet, int row, EshActivityIndex activityIndex) {
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
        .value = activityIndex.eshEkipIl;

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
        .value = activityIndex.eshEkipBirimAdi;

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
        .value = activityIndex.hastaAdiSoyadi;

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
        .value = activityIndex.hastaTcKimlikNo;

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
        .value = activityIndex.hastaAdresiDerle();

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
        .value = activityIndex.indexToplamPuanHesapla();

    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row))
        .value = activityIndex.indexDurumDegerlendir();
  }

  Future<void> exportToExcelList(List<EshActivityIndex> allEshIndeks,
      {Function(int progress)? onProgress,
      Function(String createdFilePath)? createdFolderPath,
      Function(bool isStared)? isStarted}) async {
    final excel = Excel.createExcel();
    final Sheet sheet = excel[excel.getDefaultSheet()!];

    int length = allEshIndeks.length;

    _baslikEkle(sheet);

    if (isStarted != null) {
      isStarted.call(true);
    }

    for (var row = 0; row < allEshIndeks.length; row++) {
      EshActivityIndex aktifIndeks = allEshIndeks.elementAt(row);
      _satirEkle(sheet, row + 1, aktifIndeks);
      if (onProgress != null) {
        onProgress.call(((row * 100) / length).round());
      }
    }

    final List<int> bytes = excel.save() ?? [];

    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download',
            'Bartel_Yaşam_Aktiviteleri_İndeksleri_Özet_Listesi.xlsx')
        ..click();
    } else {
      final String path = (await getExternalStorageDirectory())!.path;
      final String fileName = Platform.isWindows
          ? '$path\\Bartel_Yaşam_Aktiviteleri_İndeksleri_Özet_Listesi.xlsx'
          : '$path/Bartel_Yaşam_Aktiviteleri_İndeksleri_Özet_Listesi.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      if (createdFolderPath != null) {
        createdFolderPath.call(path);
      }
      //  OpenFile.open(fileName);
    }
  }
}
