import 'package:url_launcher/url_launcher.dart';

void sendWhatsAppMessage(int phoneNumber, String message) async {
  print(phoneNumber);
  var url = "https://wa.me/$phoneNumber?text=$message";
  await launch(url);
}


void launchPhone(String phoneNumber) async {
  final phoneUrl = 'tel:$phoneNumber';
  if (await canLaunch(phoneUrl)) {
    await launch(phoneUrl);
  }
}
