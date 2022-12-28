import 'package:flutter/material.dart';

mixin ProgressCompanentMixin {
  //----------
  final String durumHenuzDosyaSecilmedi = 'Henüz Dosya Seçilmedi!!';
  final String durumDosyaSecildi = 'Dosya Seçildi...';
  final String durumSecilenDosyaOkundu = 'Dosya Okundu...';
  final String durumPdfDosyalarOlusturuldu = 'Pdf Dosyaları Oluşturuldu...';
  final String durumExcelOzetListesiOlusturuldu =
      'Excel Özet Listesi Oluşturuldu...';
  final String yapilanIslemSecilenDosyaOkunuyor = 'Dosya Okunuyor...';
  final String yapilanIslemPdfDosyalarolusturuluyor =
      'Pdf Dosyalar Oluşturuluyor...';
  final String yapilanIslemExcelOzetListesiOlusturuluyor =
      'Excel Özet Listesi Oluşturuluyor...';
  final String sonucHata = 'Beklenmeyen Bir Hata Oluştu!!!';
  final String sonucBasarili = 'Süreç Başarıyla Tamamlandı!!!';
  final String sonucDosyaSEcmeIptalEdildi = 'Dosya Seçme İptal Edildi!!!';

  //--------------
  int ilerlemeYuzdesi = 0;
  String ilerlemeDurumu = '';
  String durum = 'Henüz Dosya Seçilmedi!!';
  String yapilanIslem = '';
  String sonuc = '';

  void temizle() {
    durum = '';
    yapilanIslem = '';
    ilerlemeYuzdesi = 0;
    ilerlemeDurumu = '';
    sonuc = '';
  }

  yudeSifirla() {
    ilerlemeYuzdesi = 0;
    ilerlemeDurumu = '';
  }

  void ilerlemeDurumuGuncelle(int i) {
    String ilerleme = '';
    String icon = '#';
    switch (i % 100) {
      case 10:
        ilerleme = '$icon';
        break;

      case 20:
        ilerleme = '$icon $icon';
        break;

      case 30:
        ilerleme = '$icon $icon $icon';
        break;

      case 40:
        ilerleme = '$icon $icon $icon $icon';
        break;

      case 50:
        ilerleme = '$icon $icon $icon $icon $icon';
        break;

      case 60:
        ilerleme = '$icon $icon $icon $icon $icon $icon';
        break;

      case 70:
        ilerleme = '$icon $icon $icon $icon $icon $icon $icon';
        break;

      case 80:
        ilerleme = '$icon $icon $icon $icon $icon $icon $icon $icon';
        break;

      case 90:
        ilerleme = '$icon $icon $icon $icon $icon $icon $icon $icon $icon';
        break;

      case 0:
        ilerleme =
            '$icon $icon $icon $icon $icon $icon $icon $icon $icon $icon';
        break;

      default:
        ilerleme = ilerlemeDurumu;
    }

    ilerlemeDurumu = ilerleme;
  }

  Container ozetTablosu() {
    return Container(
      width: 370,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          border: Border.all(
            width: 2,
            color: Colors.yellow,
          )),
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            ' DURUM : $durum',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          SizedBox(height: 15),
          Text(
            ' YAPILAN İŞLEM : $yapilanIslem',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          SizedBox(height: 15),
          Text(
            ' İLERLEME YÜZDESİ :  %$ilerlemeYuzdesi',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          SizedBox(height: 15),
          Text(
            ' İLERLEME DURUMU : $ilerlemeDurumu',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          SizedBox(height: 15),
          Text(
            ' SONUÇ : $sonuc',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
