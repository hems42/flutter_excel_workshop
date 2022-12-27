import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'esh_activity_index.dart';

class ExcelManager {
  final fileName = '';
  final sheetName = 'indeks_veri_tüm_listesi';
  late BuildContext _context;

  ExcelManager(BuildContext context) {
    _context = context;
  }

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
      {Function(int progress)? onProgress}) async {
    var excel = await selectExcelFile();

    if (excel != null) {
      List<EshActivityIndex> allIndexlist = [];
      EshActivityIndex eshActivityIndex;
      int index = 0;
      int length = excel.tables[sheetName]!.rows.length;

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
          print("anlık index $index");
          //---------------
          if (onProgress != null) {
            int _progres = (((index + 1) * 100) / length).ceil();
            var nn = ((index * 100) / length);
          //  print("index $index uzunluk $length $_progres sonuc $nn");

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
}
