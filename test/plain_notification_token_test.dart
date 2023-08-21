import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plain_notification_token/plain_notification_token.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('plain_notification_token');
  final String apnsToken = "89369abc76a0e86fa60c75d64a52b696629d766f070ba6";

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    channel,
    (message) {
      switch (message.method) {
        case "getToken":
          return Future.value(apnsToken);
        default:
          return Future.value(null);
      }
    },
  );

  group("PlainNotificationToken", () {
    group("In iOS", () {
      test("can get token", () async {
        final pnt = PlainNotificationToken();
        final actual = await pnt.getToken();
        expect(actual, apnsToken);
      });
    });
  });

  group("IosNotificationSettings", () {
    test("can serialize to map", () {
      final from =
          IosNotificationSettings(alert: true, badge: true, sound: false);
      expect(from.toMap(), {
        "alert": true,
        "badge": true,
        "sound": false,
      });
    });
  });
}
