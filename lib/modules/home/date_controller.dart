import 'package:get/get.dart';

class DateController extends GetxController {
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  void setDate(DateTime date) => selectedDate.value = date;
}
