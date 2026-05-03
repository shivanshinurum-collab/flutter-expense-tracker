import 'package:expense_app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expense_app/models/models.dart';
import 'package:expense_app/widgets/widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final RxList<Transaction> _filteredTransactions = <Transaction>[].obs;
  final RxBool _hasSearched = false.obs;

  void _onSearchChanged(String query, List<Transaction> allTransactions) {
    _hasSearched.value = query.isNotEmpty;
    if (query.isEmpty) {
      _filteredTransactions.clear();
    } else {
      _filteredTransactions.assignAll(allTransactions.where((t) {
        return t.title.toLowerCase().contains(query.toLowerCase()) ||
            t.category.toLowerCase().contains(query.toLowerCase()) ||
            t.account.toLowerCase().contains(query.toLowerCase());
      }).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final transController = Get.find<TransactionsController>();

    return Scaffold(
      backgroundColor: const Color(0xFF3D3935),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: primaryColor.withOpacity(0.5), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) {
                    setState(() {}); // For suffix icon visibility
                    _onSearchChanged(val, transController.transactionsList);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search for records...',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.grey, size: 20),
                      onPressed: () => Get.back(),
                    ),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
                            onPressed: () {
                              _controller.clear();
                              setState(() {});
                              _onSearchChanged("", transController.transactionsList);
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'RECORDS',
                    style: GoogleFonts.outfit(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Divider(color: Colors.white10),
            // Results or Empty State
            Expanded(
              child: Obx(() => !_hasSearched.value
                  ? _buildEmptyState()
                  : _filteredTransactions.isEmpty
                      ? _buildNoResultsState()
                      : ListView.builder(
                          itemCount: _filteredTransactions.length,
                          itemBuilder: (context, index) {
                            return TransactionItem(
                              transaction: _filteredTransactions[index],
                              deleteTransaction: (id) {
                                transController.removeTransaction(id);
                                _onSearchChanged(_controller.text, transController.transactionsList);
                              },
                            );
                          },
                        )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.text_snippet_outlined,
          size: 100,
          color: Colors.grey.withOpacity(0.3),
        ),
        const SizedBox(height: 16),
        Text(
          'Search records by notes, category name or\naccount name',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Text(
        'No records found for "${_controller.text}"',
        style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16),
      ),
    );
  }
}
