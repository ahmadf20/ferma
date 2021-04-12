import 'package:ferma/models/user_model.dart';
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
      await getUser().then((res) {
        if (res is User) {
          updateUser(res);
        } else {
          customBotToastText(res);
        }
      });
    } catch (e) {
      customBotToastText(ErrorMessage.general);
    } finally {
      isLoading.toggle();
    }
  }

  void updateUser(User? newUser) {
    user.update((val) {
      val?.name = newUser?.name;
      val?.email = newUser?.email;
      val?.id = newUser?.id;
      val?.location = newUser?.location;
      val?.profilePicture = newUser?.profilePicture;
      val?.username = newUser?.username;
    });
  }
}
