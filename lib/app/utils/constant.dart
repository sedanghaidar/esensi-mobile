import 'package:absensi_kegiatan/app/utils/colors.dart';
import 'package:magic_view/factory.dart';
import 'package:magic_view/style/MagicTextFieldBorder.dart';

///ORIENTATION
const WEB_LANDSCAPE =
    1; //Jika aplikasi dibuka di browser dan lebar platform > tinggi platform
const WEB_PORTRAIT =
    2; //Jika aplikasi dibuka di browser dan lebar platform < tinggi platform
const MOBILE =
    3; //Jika aplikasi dibuka di perangkat mobile android / IOS dan tidak melalui website
const DESKTOP_LANDSCAPE =
    4; //Jika aplikasi dibuka di perangkat dekstop seperti windows, linux atau macOS dan tidak dibuka melalui website
const DESKTOP_PORTRAIT =
    5; //Jika aplikasi dibuka di perangkat dekstop seperti windows, linux atau macOS dan tidak dibuka melalui website

///HIVE UNIQUE ID
const HIVE_USER_ID = 0; //Unique Hive ID untuk User Model

const maxWidth = 720.0;

MagicTextFieldBorder underlineBorder = MagicTextFieldBorder(
    border: MagicTextFieldBorderProperty(
        type: MagicTextFieldBorderType.UNDERLINE,
        sideColor: basicPrimary,
    ),
    enableBorder: MagicTextFieldBorderProperty(
        type: MagicTextFieldBorderType.UNDERLINE,
        sideColor: basicPrimary,
    ),
    disableBorder: MagicTextFieldBorderProperty(
        type: MagicTextFieldBorderType.UNDERLINE,
        sideColor: basicGrey2,
    ),
    focusedBorder: MagicTextFieldBorderProperty(
        type: MagicTextFieldBorderType.UNDERLINE,
        sideColor: basicPrimary,
    ),
    errorBorder: MagicTextFieldBorderProperty(
        type: MagicTextFieldBorderType.UNDERLINE,
        sideColor: MagicFactory.colorError,
    ),
    focusedErrorBorder: MagicTextFieldBorderProperty(
        type: MagicTextFieldBorderType.UNDERLINE,
        sideColor: MagicFactory.colorError,
    ),
);
