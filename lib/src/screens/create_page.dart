import 'dart:convert';

import 'package:budget_tracker_notion/src/blocs/budget_provider.dart';
import 'package:budget_tracker_notion/src/errors/failure.dart';
import 'package:budget_tracker_notion/src/models/item_model.dart';
import 'package:budget_tracker_notion/src/models/list_database.dart'
    as database;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreatePage extends StatefulWidget {
  final ItemModel? itemData;
  final bool isEdit;

  const CreatePage({this.itemData, this.isEdit = false});

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  var nameController = TextEditingController();
  var priceController = TextEditingController();
  var currentSelectedValue;
  String selectedDate = "";
  String saveDate = "";
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (widget.isEdit) {
      nameController.text = widget.itemData!.name;
      priceController.text = widget.itemData!.price.toString();
      currentSelectedValue = widget.itemData!.category;
      selectedDate = DateFormat('MMMM dd, yyyy').format(widget.itemData!.date);
      saveDate = DateFormat('yyyy-MM-dd').format(widget.itemData!.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BudgetProvider.of(context);
    bloc.fetchDatabase();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Expenses'),
        ),
        body: createForm(bloc),
      ),
    );
  }

  Widget createForm(BudgetBloc bloc) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: [
          textForm(nameController, "Name"),
          SizedBox(
            height: 20.0,
          ),
          categoryAndDate(true, bloc),
          SizedBox(
            height: 20.0,
          ),
          textForm(priceController, "Price"),
          SizedBox(
            height: 20.0,
          ),
          categoryAndDate(false, bloc),
          SizedBox(
            height: 40.0,
          ),
          loading
              ? CircularProgressIndicator(
                  color: Colors.red[400],
                )
              : GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    validateAndCreatePage(bloc);
                  },
                  child: Container(
                    width: 300.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Center(
                        child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    )),
                  ),
                )
        ],
      ),
    );
  }

  validateAndCreatePage(BudgetBloc bloc) async {
    if (nameController.text == "") {
      showSnackBar("Name is required");
      return;
    }
    if (currentSelectedValue == null) {
      showSnackBar("Category is required");
      return;
    }
    if (priceController.text == "") {
      showSnackBar("Price is required");
      return;
    }

    setState(() {
      loading = true;
    });
    var response;
    String message;
    if (widget.isEdit) {
      var data = {
        "name": nameController.text,
        "price": priceController.text,
        "category": currentSelectedValue,
        "date": saveDate,
        "pageId": widget.itemData!.pageId,
      };
      message = "Data updated successfully";
      response = await bloc.editItem(data);
    } else {
      var data = {
        "name": nameController.text,
        "price": priceController.text,
        "category": currentSelectedValue,
        "date": saveDate,
      };
      message = "Data added successfully";
      response = await bloc.addItem(data);
    }
    if (mounted)
      setState(() {
        loading = false;
      });
    final int statusCode = response.statusCode;
    if (statusCode == 200) {
      bloc.fetchItems();
      showSnackBar(message);
      Navigator.of(context).pop();
    } else {
      final data = jsonDecode(response.body);
      throw Failure(message: data['message']);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 3700)),
        lastDate: DateTime.now().add(Duration(days: 730)));
    if (picked != null)
      setState(() {
        selectedDate = DateFormat('MMMM dd, yyyy').format(picked);
        saveDate = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  Widget textForm(TextEditingController controller, String hint) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: hint,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.circular(25.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(25.0),
          )),
    );
  }

  Widget categoryAndDate(bool isCategory, BudgetBloc bloc) {
    return Container(
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(25.0))),
            child: isCategory ? typeFieldWidget(bloc) : datePickerWidget(),
          );
        },
      ),
    );
  }

  Widget datePickerWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _selectDate(context);
      },
      child: Text(
        selectedDate == "" ? "Select Date" : selectedDate,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  Widget typeFieldWidget(BudgetBloc bloc) {
    return StreamBuilder(
        stream: bloc.dataList,
        builder: (context, AsyncSnapshot<List<database.DataResult>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            final failure = snapshot.error as Failure;
            return Center(
              child: Text(failure.message),
            );
          } else {
            final data = snapshot.data!;
            return DropdownButtonHideUnderline(
              child: DropdownButton(
                hint: Text("Select Category"),
                value: currentSelectedValue,
                isDense: true,
                onChanged: (newValue) {
                  setState(() {
                    currentSelectedValue = newValue;
                  });
                },
                items:
                    data[0].properties?.category?.select?.options?.map((value) {
                  return DropdownMenuItem(
                    child: Text(value.name!),
                    value: value.name,
                  );
                }).toList(),
              ),
            );
          }
        });
  }

  void showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
