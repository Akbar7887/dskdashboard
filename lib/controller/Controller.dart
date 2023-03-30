import 'package:get/get.dart';
import 'ApiConnector.dart';

class Controller extends GetxController {
  final api = ApiConnector();


  @override
  onInit() {


    super.onInit();

  }


}

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Controller>(() => Controller());
  }
}
