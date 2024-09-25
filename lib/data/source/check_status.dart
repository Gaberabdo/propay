import 'package:gamers_arena/routes/routes_name.dart';
import 'package:gamers_arena/utils/services/localstorage/hive.dart';
import 'package:gamers_arena/utils/services/localstorage/keys.dart';
import 'package:get/get.dart';
import '../../utils/services/helpers.dart';
import '../../views/screens/profile/profile_setting_screen.dart';
import '../../views/screens/verification_check/verfication_check_screen.dart';

class ApiStatus {
  static checkStatus(String status, message) async {
    if (status == 'success') {
      Helpers.showSnackBar(msg: '$message', title: status.toCapital());
    } else {
      if (message is List) {
        List messages = message;
        Helpers.showSnackBar(
            msg: messages.join('\n'), title: status.toCapital());
      } else if (message is String) {
        Helpers.showSnackBar(msg: message, title: status.toCapital());
        if (message == "Email Verification Required") {
          Get.offAll(() => VerficiationCheckScreen(verficationType: "Email"));
        } else if (message == "Mobile Verification Required") {
          Get.offAll(() => VerficiationCheckScreen(verficationType: "Sms"));
        } else if (message == "Two FA Verification Required") {
          Get.offAll(() => VerficiationCheckScreen(verficationType: "2FA"));
        } else if (message == "Your account has been suspend") {
          HiveHelp.remove(Keys.token);
          Get.offAllNamed(RoutesName.loginScreen);
        } else if (message == "Identity Verification Required") {
          Get.offAll(() => ProfileSettingScreen(isIdentityVerification: true));
        } else if (message == "Address Verification Required") {
          Get.offAll(() => ProfileSettingScreen(isAddressVerification: true));
        }
      }
    }
  }
}
