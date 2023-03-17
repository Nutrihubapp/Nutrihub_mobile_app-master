import 'package:checkout_app/models/parent_categories.dart';
import 'package:checkout_app/providers/fetch_data.dart';
import 'package:checkout_app/providers/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../constants.dart';
import 'filter_widget_details.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  dynamic rangeLow;
  dynamic rangeHigh;
  dynamic activeCurrency;

  String _selectedCategory = '0';

  String dropDownValue = "All", catID = '0', offID = '0';

  final List<String> _offerType = <String>['All', 'Offer'];

  @override
  void initState() {
    super.initState();
    fetchPrice();
    _resetForm();
  }

  fetchPrice() async {
    var productResponse = await ProductRepository().getRange();
    rangeLow = 1.00;
    rangeHigh = 500.00;
    activeCurrency = productResponse.activeCurrency;
    setState(() {});
  }

  SfRangeValues _values = const SfRangeValues(1.00, 500.00);

  _resetForm() {
    if (rangeLow != null && rangeHigh != null) {
      setState(() {
        _selectedCategory = '0';
        dropDownValue = _offerType[0];
        _values = SfRangeValues(rangeLow, rangeHigh);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final catData = Provider.of<FetchData>(context, listen: false).items;
    catData.insert(
        0,
        ParentCategories(
            categoryId: "0",
            title: 'All',
            thumbnail: null,
            top: null,
            categoryType: null,
            parentId: null,
            status: null));
    // dropDownValue = _offerType[0];
    // rangeLow != null
    //     ? _values = SfRangeValues(rangeLow, rangeHigh)
    //     : Center(child: CircularProgressIndicator());
    // _values = SfRangeValues(rangeLow, rangeHigh);
    return Scaffold(
        body: Column(
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Filter Products',
            style: TextStyle(
              fontSize: 16,
              color: kTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(
            color: kSecondaryColor, //change your color here
          ),
          backgroundColor: kBackgroundColor,
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.cancel,
                  color: kSecondaryColor,
                ),
                onPressed: () => Navigator.of(context).pop()),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Expanded(
                        flex: 9,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text("Category",
                              style: TextStyle(color: Colors.black54)),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: DropdownButton(
                          value: _selectedCategory,
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value.toString();
                            });
                          },
                          isExpanded: true,
                          items: catData.map((cd) {
                            var unescape = HtmlUnescape();
                            var title = unescape.convert(cd.title.toString());
                            return DropdownMenuItem(
                              value: cd.categoryId == "0" ? '0' : cd.categoryId,
                              child: Text(title),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Expanded(
                        flex: 9,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text("Offer",
                              style: TextStyle(color: Colors.black54)),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: DropdownButton(
                          value: dropDownValue,
                          onChanged: (newVal) {
                            if (newVal == "All") {
                              setState(() {
                                offID = '0';
                              });
                            } else if (newVal == "Offer") {
                              setState(() {
                                offID = '1';
                              });
                            }
                            setState(() {
                              // print(offID);
                            });
                            dropDownValue = newVal.toString();
                            setState(() {});
                          },
                          isExpanded: true,
                          items: _offerType.map((val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          "Price",
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 250,
                        child: rangeLow != null
                            ? SfRangeSlider(
                                min: rangeLow,
                                max: rangeHigh,
                                values: _values,
                                // interval: 50,
                                showTicks: true,
                                // showLabels: true,
                                activeColor: kGreenColor,
                                enableTooltip: true,
                                minorTicksPerInterval: 1,
                                onChanged: (SfRangeValues values) {
                                  setState(() {
                                    // print((_values.start).toStringAsFixed(2));
                                    _values = values;
                                  });
                                },
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: activeCurrency != null
                              ? Text(
                                  activeCurrency +
                                      (_values.start).toStringAsFixed(2),
                                  style: const TextStyle(fontSize: 16),
                                )
                              : Text(
                                  (_values.start).toStringAsFixed(2),
                                  style: const TextStyle(fontSize: 16),
                                ),
                          // child: Text(_lowValue.floorToDouble().toString(), style: TextStyle(fontSize: 16),),
                        ),
                        flex: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: activeCurrency != null
                            ? Text(
                                activeCurrency +
                                    (_values.end).toStringAsFixed(2),
                                style: const TextStyle(fontSize: 16),
                              )
                            : Text(
                                (_values.end).toStringAsFixed(2),
                                style: const TextStyle(fontSize: 16),
                              ),
                        // child: Text(_highValue.floorToDouble().toString(), style: TextStyle(fontSize: 16),),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: MaterialButton(
                          onPressed: _resetForm,
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          color: kDarkButtonBg,
                          textColor: Colors.white,
                          splashColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            side: const BorderSide(color: kDarkButtonBg),
                          ),
                        ),
                      ),
                      Expanded(flex: 2, child: Container()),
                      Expanded(
                        flex: 5,
                        child: MaterialButton(
                          onPressed: () {
                            // print("First: "+ (_values.start).toStringAsFixed(2) + '\n' + "End: "+ (_values.end).toStringAsFixed(2) + '\n' + "cat:: "+ _selectedCategory + '\n' + "off:: "+ offID);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FilterDetails(
                                      (_values.start).toStringAsFixed(2),
                                      (_values.end).toStringAsFixed(2),
                                      _selectedCategory,
                                      offID)),
                            );
                          },
                          child: const Text(
                            'Filter',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          color: kGreenColor,
                          textColor: Colors.white,
                          splashColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                            side: const BorderSide(color: kGreenColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
