import 'package:get/get.dart';
import 'package:qr_app/controllers/events_controller.dart';

class EventsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EventsController());
  }
}