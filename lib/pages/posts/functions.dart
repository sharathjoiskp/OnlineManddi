import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/utils.dart';
import 'models/model.dart';

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

category(BuildContext context, PostDetailsModel post) {
  for (var element in post.userActions) {
    if (element.uid == uid) {
      switch (element.category) {
        case 0:
          return ['Intersted', Theme.of(context).colorScheme.primaryContainer];
        case 1:
          return [
            'Follow Up',
            Theme.of(context).colorScheme.secondaryContainer
          ];
        case 2:
          return ['Completed', Theme.of(context).colorScheme.tertiaryContainer];
        case 3:
          return [
            'Not Intersted',
            Theme.of(context).colorScheme.errorContainer
          ];
      }
    }
  }
  return ['', Colors.transparent];
}
