import 'package:get/get.dart';
import 'package:expense_app/models/models.dart';
import 'package:expense_app/repositories/repositories.dart';

enum SearchStatus { initial, searching, loaded, error }

class SearchController extends GetxController {


  final RxList<Transaction> transactions = <Transaction>[].obs;
  final Rx<SearchStatus> status = SearchStatus.initial.obs;
  final RxString error = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  void loadAll() async {
    status.value = SearchStatus.searching;
    try {
      status.value = SearchStatus.loaded;
    } catch (e) {
      error.value = e.toString();
      status.value = SearchStatus.error;
    }
  }

  void search(String keyword) async {
    if (keyword.isEmpty) {
      loadAll();
      return;
    }

    status.value = SearchStatus.searching;
    try {
      status.value = SearchStatus.loaded;
    } catch (e) {
      error.value = e.toString();
      status.value = SearchStatus.error;
    }
  }
}
