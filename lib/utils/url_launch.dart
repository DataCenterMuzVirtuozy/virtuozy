
 import 'package:url_launcher/url_launcher.dart';

class UrlLaunch{


  static  Future<void> url(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

 static Future<void> tel({required String tel}) async {
    final Uri url = Uri(
        scheme:'tel',
        path: tel);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }


 }