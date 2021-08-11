import 'dart:async';

import 'package:budget_tracker_notion/src/models/item_model.dart';
import 'package:budget_tracker_notion/src/models/list_database.dart';
import 'package:rxdart/rxdart.dart';
import '../repositories/budget_repository.dart';

class BudgetBloc {
  final _repository = BudgetRepository();
  final _itemsOutput = BehaviorSubject<List<ItemModel>>();
  final _dataOutput = BehaviorSubject<List<DataResult>>();

  // Streams getters
  Stream<List<ItemModel>> get items => _itemsOutput.stream;

  // Streams getters
  Stream<List<DataResult>> get dataList => _dataOutput.stream;

  fetchItems() async {
    _itemsOutput.add(await _repository.getItems());
  }

  fetchDatabase() async {
    _dataOutput.add(await _repository.getDatabase());
  }

  addItem(Map<String, dynamic> data) async {
    return await _repository.addItems(data);
  }
  editItem(Map<String, dynamic> data) async {
    return await _repository.editItems(data);
  }

  deletePage(String pageId) async {
    return await _repository.deletePage(pageId);
  }

  dispose() {
    _itemsOutput.close();
  }
}
