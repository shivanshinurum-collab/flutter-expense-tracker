import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_app/repositories/repositories.dart';

class BudgetCubit extends Cubit<double> {
  final UserPreferencesRepository _repository;

  BudgetCubit({required UserPreferencesRepository repository})
      : _repository = repository,
        super(repository.getMonthlyBudget());

  void updateBudget(double newBudget) {
    _repository.setMonthlyBudget(newBudget);
    emit(newBudget);
  }
}
