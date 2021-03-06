import 'package:ferma/models/user_model.dart';
import 'package:ferma/screens/auth_screen.dart';
import 'package:ferma/utils/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:ferma/services/user_services.dart';
import 'package:ferma/utils/const.dart';
import 'package:ferma/utils/custom_bot_toast.dart';

class ProfileController extends GetxController {
  final Rx<User> user = User().obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    fetchUserData();
    super.onInit();
  }

  void fetchUserData() async {
    try {
      await UserService.getUser().then((res) {
        if (res is String &&
            res.toString().toLowerCase().contains('unauthorized')) {
          Get.offAll(() => AuthScreen());
          SharedPrefs.logOut();
        }

        if (res is User) {
          updateUser(res);
        } else {
          customBotToastText(res);
        }
      });
    } catch (e) {
      customBotToastText(ErrorMessage.general);
    } finally {
      if (isLoading.value) isLoading.toggle();
    }
  }

  void updateUser(User? newUser) {
    user.update((val) {
      if (val != null) {
        val.name = newUser?.name;
        val.email = newUser?.email;
        val.id = newUser?.id;
        val.location = newUser?.location;
        val.profilePicture = newUser?.profilePicture;
        val.username = newUser?.username;
      }
    });
  }
}
