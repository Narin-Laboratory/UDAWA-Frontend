import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale("en", localeData.EN),
  MapLocale("id", localeData.ID),
];

mixin localeData {
  static const String title = 'title';
  static const String changeLanguage = 'changeLanguage';
  static const String connectButton = 'connectButton';
  static const String scanButton = 'scanButton';
  static const String authLocalOnProcessSending = 'authLocalOnProcessSending';

  static const Map<String, dynamic> ID = {
    title: 'UDAWA Smart System',
    changeLanguage: 'Pilih Bahasa',
    connectButton: 'Konek',
    scanButton: 'Pindai',
    authLocalOnProcessSending: "Mengirim permintaan otentikasi...",
  };

  static const Map<String, dynamic> EN = {
    title: 'UDAWA Smart System',
    changeLanguage: 'Change Language',
    connectButton: 'Connect',
    scanButton: 'Scan',
    authLocalOnProcessSending: "Sending an authentication request...",
  };
}
