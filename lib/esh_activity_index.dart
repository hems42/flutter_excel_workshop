class EshActivityIndex {
  EshActivityIndex() {
    _eshEkipIl = "KONYA";
    _eshEkipBirimAdi = "KARAPINAR EVDE SAĞLIK HİZMETLERİ BİRİMİ";
  }

  //-- esh bilgileri

  late String _eshEkipIl;
  late String _eshEkipBirimAdi;

  //---- hasta biligleri
  late String _hastaAdi;
  late String _hastaSoyadi;
  late String _hastaTcKimlikNo;
  late String _hastaCinsiyet;
  late String _hastaYakiniAdi;
  late String _hastaYakiniSoyadi;
  late String _hastaYakinlikDerecesi;
  late String _islemTarih;
  late String _islemSaati;

  //-- adres bilgileri

  late String _hastaAdresIl;
  late String _hastaAdresIlce;
  late String _hastaAdresMahalle;
  late String _hastaAdresSokakCadde;
  late String _hastaAdresKapiNo;
  late String _hastaAdresAciklama;
  late String _hastaTelNo;

  //-- bartel parametreleri
  late int _beslenmeParametresi;
  late int _yikanmaParametresi;
  late int _kendineBakimParametresi;
  late int _giyipSoyunmaParametresi;
  late int _bagirsakBakimiParametresi;
  late int _mesaneBakimiParametresi;
  late int _tuvaletKullanimiParametresi;
  late int _tekerlekliSandalyedenTransferParametresi;
  late int _mobiliteParametresi;
  late int _merdivenInipCikmaParametresi;

  // -- getter setter

  String get eshEkipIl => _eshEkipIl;
  set eshEkipIl(String eshEkipIl) => _eshEkipBirimAdi = eshEkipIl;

  String get hastaAdi => _hastaAdi;
  set hastaAdi(String hastaAdi) => _hastaAdi = hastaAdi;

  String get hastaSoyadi => _hastaSoyadi;
  set hastaSoyadi(String hastaSoyadi) => _hastaSoyadi = hastaSoyadi;

  String get hastaCinsiyet => _hastaCinsiyet;
  set hastaCinsiyet(String hastaCinsiyet) =>
      _hastaCinsiyet = hastaCinsiyet;

  String get hastaTcKimlikNo => _hastaTcKimlikNo;
  set hastaTcKimlikNo(String hastaTcKimlikNo) =>
      _hastaTcKimlikNo = hastaTcKimlikNo;

  String get hastaYakiniAdi => _hastaYakiniAdi;
  set hastaYakiniAdi(String hastaYakiniAdi) => _hastaYakiniAdi = hastaYakiniAdi;

  String get hastaYakiniSoyadi => _hastaYakiniSoyadi;
  set hastaYakiniSoyadi(String hastaYakiniSoyadi) =>
      _hastaYakiniSoyadi = hastaYakiniSoyadi;

  String get hastaYakinlikDerecesi => _hastaYakinlikDerecesi;
  set hastaYakinlikDerecesi(String hastaYakinlikDerecesi) =>
      _hastaYakinlikDerecesi = hastaYakinlikDerecesi;

  String get islemTarih => _islemTarih;
  set islemTarih(String islemTarih) => _islemTarih = islemTarih;

  String get islemSaati => _islemSaati;
  set islemSaati(String islemSaati) => _islemSaati = islemSaati;

  String get hastaAdresIl => _hastaAdresIl;
  set hastaAdresIl(String hastaAdresIl) => _hastaAdresIl = hastaAdresIl;

  String get hastaAdresIlce => _hastaAdresIlce;
  set hastaAdresIlce(String hastaAdresIlce) => _hastaAdresIlce = hastaAdresIlce;

  String get hastaAdresMahalle => _hastaAdresMahalle;
  set hastaAdresMahalle(String hastaAdresMahalle) =>
      _hastaAdresMahalle = hastaAdresMahalle;

  String get hastaAdresSokakCadde => _hastaAdresSokakCadde;
  set hastaAdresSokakCadde(String hastaAdresSokakCadde) =>
      _hastaAdresSokakCadde = hastaAdresSokakCadde;

  String get hastaAdresKapiNo => _hastaAdresKapiNo;
  set hastaAdresKapiNo(String hastaAdresKapiNo) =>
      _hastaAdresKapiNo = hastaAdresKapiNo;

  String get hastaAdresAciklama => _hastaAdresAciklama;
  set hastaAdresAciklama(String hastaAdresAciklama) =>
      _hastaAdresAciklama = hastaAdresAciklama;

  String get hastaTelNo => _hastaTelNo;
  set hastaTelNo(String hastaTelNo) => _hastaTelNo = hastaTelNo;

  int get beslenmeParametresi => _beslenmeParametresi;
  set beslenmeParametresi(int beslenmeParametresi) =>
      _beslenmeParametresi = beslenmeParametresi;

  int get yikanmaParametresi => _yikanmaParametresi;
  set yikanmaParametresi(int yikanmaParametresi) =>
      _yikanmaParametresi = yikanmaParametresi;

  int get kendineBakimParametresi => _kendineBakimParametresi;
  set kendineBakimParametresi(int kendineBakimParametresi) =>
      _kendineBakimParametresi = kendineBakimParametresi;

  int get giyipSoyunmaParametresi => _giyipSoyunmaParametresi;
  set giyipSoyunmaParametresi(int giyipSoyunmaParametresi) =>
      _giyipSoyunmaParametresi = giyipSoyunmaParametresi;

  int get bagirsakBakimiParametresi => _bagirsakBakimiParametresi;
  set bagirsakBakimiParametresi(int bagirsakBakimiParametresi) =>
      _bagirsakBakimiParametresi = bagirsakBakimiParametresi;

  int get mesaneBakimiParametresi => _mesaneBakimiParametresi;
  set mesaneBakimiParametresi(int mesaneBakimiParametresi) =>
      _mesaneBakimiParametresi = mesaneBakimiParametresi;

  int get tuvaletKullanimiParametresi => _tuvaletKullanimiParametresi;
  set tuvaletKullanimiParametresi(int tuvaletKullanimiParametresi) =>
      _tuvaletKullanimiParametresi = tuvaletKullanimiParametresi;

  int get tekerlekliSandalyedenTransferParametresi =>
      _tekerlekliSandalyedenTransferParametresi;
  set tekerlekliSandalyedenTransferParametresi(
          int tekerlekliSandalyedenTransferParametresi) =>
      _tekerlekliSandalyedenTransferParametresi =
          tekerlekliSandalyedenTransferParametresi;

  int get mobiliteParametresi => _mobiliteParametresi;
  set mobiliteParametresi(int mobiliteParametresi) =>
      _mobiliteParametresi = mobiliteParametresi;

  int get merdivenInipCikmaParametresi => _merdivenInipCikmaParametresi;
  set merdivenInipCikmaParametresi(int merdivenInipCikmaParametresi) =>
      _merdivenInipCikmaParametresi = merdivenInipCikmaParametresi;

  //-- hesaplamalar

  int indexToplamPuanHesapla() {
    int toplam = _beslenmeParametresi +
        _yikanmaParametresi +
        _kendineBakimParametresi +
        _giyipSoyunmaParametresi +
        _bagirsakBakimiParametresi +
        _mesaneBakimiParametresi +
        _tuvaletKullanimiParametresi +
        _tekerlekliSandalyedenTransferParametresi +
        _mobiliteParametresi +
        _merdivenInipCikmaParametresi;
    return toplam;
  }

  String indexDurumDegerlendir() {
    String sonuc = "";
    int puan = indexToplamPuanHesapla();
    if (puan < 21) {
      sonuc = "TAM BAĞIMLI";
    } else if (puan < 62 && puan > 21) {
      sonuc = "İLERİ DERECEDE BAĞIMLI";
    } else if (puan < 91 && puan > 61) {
      sonuc = "ORTA DERECEDE BAĞIMLI";
    } else if (puan < 100 && puan > 91) {
      sonuc = "HAFİF DERECEDE BAĞIMLI";
    } else if (puan == 100) {
      sonuc = "TAM BAĞIMSIZ";
    }
    return sonuc;
  }

  String hastaAdresiDerle() {
    String adres = '$hastaAdresMahalle mah.  $hastaAdresSokakCadde  sok/cad.   no : $hastaAdresKapiNo \n'
        '$hastaAdresIl / $hastaAdresIlce ';
    return adres;
  }
}
