import 'package:bot_toast/bot_toast.dart';
import 'package:ferma/utils/formatting.dart';
import 'package:ferma/utils/logger.dart';
import 'package:ferma/utils/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString address = ''.obs;
  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;

  RxBool isLoading = true.obs;

  RxInt carouselIndex = 0.obs;

  void updateCarouselIndex(int val) {
    carouselIndex.value = val;
  }

  void updateLocation() async {
    BotToast.showLoading();
    Position position = await Geolocator.getCurrentPosition();
    SharedPrefs.setPosition(position.latitude, position.longitude);
    updateLatLong(position.latitude, position.longitude);
    address.value = await GeneralFormat.printLocation(
        position.latitude, position.longitude);

    logger.v(position);
    BotToast.closeAllLoading();
  }

  void initLocation() async {
    Map? positions = await (SharedPrefs.getPosition());
    logger.i(positions);
    if (positions != null &&
        positions['latitude'] != null &&
        positions['longitude'] != null) {
      address.value = await GeneralFormat.printLocation(
          positions['latitude'], positions['longitude']);
      updateLatLong(positions['latitude'], positions['longitude']);
      address.refresh();
    } else {
      updateLocation();
    }
  }

  void updateLatLong(double latitude, double longitude) {
    lat.value = latitude;
    long.value = longitude;
  }

  // void updateFinishTask(String? id, int count) {
  //   MyPlant temp = myPlants[myPlants.indexWhere((v) => v.id == id)]
  //     ..finishTask = count;
  //   myPlants[myPlants.indexWhere((v) => v.id == id)] = temp;
  // }

  // void updatePlantData(String? id, MyPlant data) {
  //   myPlants[myPlants.indexWhere((v) => v.id == id)] = data;
  // }

  @override
  void onInit() {
    initLocation();
    super.onInit();
  }
}
