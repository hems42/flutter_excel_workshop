import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import 'esh_activity_index.dart';

class ExcelManager {
  final fileName = '';
  final sheetName = 'indeks_veri_tüm_listesi';

  Future<Excel?> selectExcelFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    Excel? excel;
    if (result != null) {
      PlatformFile file = result.files.first;
      var bytess = file.bytes;
      excel = Excel.decodeBytes(bytess!.buffer.asInt8List());
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
      int length = excel.tables[sheetName]!.maxRows;

      for (var element in excel.tables[sheetName]!.rows) {
        if (index > 0) {
          eshActivityIndex = EshActivityIndex();

          eshActivityIndex.hastaAdi = element.elementAt(2)!.value.toString();
          eshActivityIndex.hastaSoyadi = element.elementAt(3)!.value.toString();
          eshActivityIndex.hastaTcKimlikNo =
              element.elementAt(1)!.value.toString();
          eshActivityIndex.hastaCinsiyet =
              (element.elementAt(6)!.value) == 'E' ? 'ERKEK' : 'KADIN';
          eshActivityIndex.hastaAdresAciklama =
              element.elementAt(8)!.value.toString();
          eshActivityIndex.hastaAdresIl =
              element.elementAt(9)!.value.toString();
          eshActivityIndex.hastaAdresIlce =
              element.elementAt(10)!.value.toString();
          eshActivityIndex.hastaAdresMahalle =
              element.elementAt(11)!.value.toString();
          eshActivityIndex.hastaAdresSokakCadde =
              element.elementAt(12)!.value.toString();
          eshActivityIndex.hastaAdresKapiNo =
              element.elementAt(16)!.value.toString();
          eshActivityIndex.hastaYakiniAdi =
              element.elementAt(18)!.value.toString();
          eshActivityIndex.hastaYakiniSoyadi =
              element.elementAt(19)!.value.toString();
          eshActivityIndex.hastaYakinlikDerecesi =
              element.elementAt(20)!.value.toString();
          eshActivityIndex.beslenmeParametresi = element.elementAt(21)!.value;
          eshActivityIndex.yikanmaParametresi = element.elementAt(22)!.value;
          eshActivityIndex.kendineBakimParametresi =
              element.elementAt(23)!.value;
          eshActivityIndex.giyipSoyunmaParametresi =
              element.elementAt(24)!.value;
          eshActivityIndex.bagirsakBakimiParametresi =
              element.elementAt(25)!.value;
          eshActivityIndex.mesaneBakimiParametresi =
              element.elementAt(26)!.value;
          eshActivityIndex.tuvaletKullanimiParametresi =
              element.elementAt(27)!.value;
          eshActivityIndex.tekerlekliSandalyedenTransferParametresi =
              element.elementAt(28)!.value;
          eshActivityIndex.mobiliteParametresi = element.elementAt(29)!.value;
          eshActivityIndex.merdivenInipCikmaParametresi =
              element.elementAt(30)!.value;

          allIndexlist.add(eshActivityIndex);

          //---------------
          if (onProgress != null) {
            onProgress.call(((index * 100) / length).round());
          

            //-------------
          }
          //-------------
          
        }index++;
      }

      return allIndexlist;
    } else {
      return null;
    }
  }
}
