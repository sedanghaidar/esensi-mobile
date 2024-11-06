import 'package:absensi_kegiatan/app/data/model/UserModel.dart';
import 'package:absensi_kegiatan/app/data/repository/ApiProvider.dart';
import 'package:absensi_kegiatan/app/data/repository/HiveHelper.dart';
import 'package:absensi_kegiatan/app/data/repository/HiveUserAdapter.dart';
import 'package:absensi_kegiatan/app/modules/login/controllers/login_controller.dart';
import 'package:absensi_kegiatan/app/modules/login/views/login_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:magic_view/main.dart';
import 'package:magic_view/widget/button/MagicButton.dart';
import 'package:magic_view/widget/textfield/MagicTextField.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Test', () {
    late LoginController controller;

    setUp(() async {
      // await setUpTestHive();
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter<UserModel>(HiveUserAdapter());
      }
      await Hive.openBox<dynamic>(HiveHelper.HIVE_APPNAME);

      Get.put(ApiProvider());
      controller = Get.put(LoginController());
    });

    tearDown(() {
      Get.delete<LoginController>();
    });

    test('Memastikan nilai awal kosong', () {
      expect(controller.controllerEmail.text.isEmpty, true);
      expect(controller.controllerPassword.text.isEmpty, true);
    });

    testWidgets(
        'Memastikan bahwa terdapat 2 Widget untuk input teks dan 1 Widget berupa tombol',
        (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(
        home: LoginView(),
      ));
      final email = find.byWidgetPredicate((widget) =>
          widget is MagicTextField && widget.hint == "Masukkan email");
      final password = find.byWidgetPredicate((widget) =>
          widget is MagicTextField && widget.hint == "Masukkan Kata Sandi");
      final button = find.byWidgetPredicate(
          (widget) => widget is MagicButton && widget.text == "Masuk");

      expect(email, findsOne);
      expect(password, findsOne);
      expect(button, findsOne);

      await tester.tap(button);

      await tester.pumpAndSettle();
      await tester.pump(Duration(seconds: 5000));
    });
  });
}
