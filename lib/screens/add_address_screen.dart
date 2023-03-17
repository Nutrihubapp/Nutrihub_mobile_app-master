import 'package:checkout_app/constants.dart';
import 'package:checkout_app/models/common_functions.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class AddAddressScreen extends StatefulWidget {
  final String? remark, postcode, floor, name,building, street, id;
  final int? index;
  bool? defaultValue;
  AddAddressScreen(
      {Key? key,
      this.index,
      this.defaultValue,
      this.remark,this.name,
      this.postcode,
      this.floor,
      this.id,
      this.building,
      this.street})
      : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  late TextEditingController remarkController;

  late TextEditingController postcodeController;

  late TextEditingController houseController;

  late TextEditingController cityController;
 late TextEditingController nameController;

  late TextEditingController streetController;
  bool selected = false;

  @override
  void initState() {
    super.initState();
    remarkController = TextEditingController(text: widget.remark);
     nameController = TextEditingController(text: widget.name);
    postcodeController = TextEditingController(text: widget.postcode);

    houseController = TextEditingController(text: widget.floor);

    cityController = TextEditingController(text: widget.building);

    streetController = TextEditingController(text: widget.street);
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration getInputDecoration(
      String hintext,
    ) {
      return InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.white, width: 0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: Colors.white, width: 0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
            //   borderRadius: BorderRadius.all(Radius.circular(15.0)),
            //  borderSide: BorderSide(color: Color(0xFFF65054)),
            ),
        errorBorder: const OutlineInputBorder(
            //borderRadius: BorderRadius.all(Radius.circular(15.0)),
            //  borderSide: BorderSide(color: Color(0xFFF65054)),
            ),
        // filled: true,
        hintStyle: const TextStyle(color: Color(0xFFc7c8ca)),
        hintText: hintext,
        // fillColor: const Color(0xFFF7F7F7),
        // suffixIcon: iconData2,
        // prefixIcon: iconData,
        contentPadding: const EdgeInsets.symmetric(vertical: 5),
      );
    }

    return Scaffold(
        appBar: CustomAppBar(
          title: 'Add new address',
        ),
        body: ListView(
          children: [
            Container(
              //  height: 300,
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              width: double.infinity,
              child: Column(children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      const Text('Name '),
                      const Gap(10),
                      Expanded(
                          child: Center(
                        child: TextField(
                          controller: nameController,
                          decoration: getInputDecoration(
                            "                 Name",
                          ),
                        ),
                      )),
                    ],
                  ),
                ),const Divider(
                  height: 30,
                  color: Color(0xffFAFAFA),
                  thickness: 10,
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      const Text('Street'),
                      const Gap(10),
                      Expanded(
                          child: Center(
                        child: TextField(
                          controller: streetController,
                          decoration: getInputDecoration(
                            "             Street",
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                const Divider(
                  height: 30,
                  color: Color(0xffFAFAFA),
                  thickness: 10,
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      const Text('City '),
                      const Gap(10),
                      Expanded(
                          child: Center(
                        child: TextField(
                          controller: cityController,
                          decoration: getInputDecoration(
                            "                 City",
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                const Divider(
                  height: 30,
                  color: Color(0xffFAFAFA),
                  thickness: 10,
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      const Text('House Nb'),
                      const Gap(10),
                      Expanded(
                          child: Center(
                        child: TextField(
                          controller: houseController,
                          decoration: getInputDecoration(
                            "           House Nb",
                          ),
                        ),
                      )),
                    ],
                  ),
                ),

                // SizedBox(
                //   height: 40,
                //   child: Row(
                //     children: [
                //       Text('Remark'),
                //       Gap(10),
                //       Expanded(
                //           child: Center(
                //         child: TextField(
                //           controller: remarkController,
                //           decoration: getInputDecoration(
                //             "           Remark",
                //           ),
                //         ),
                //       )),
                //     ],
                //   ),
                // ),
                // Divider(
                //   height: 30,
                //   color: Color(0xffFAFAFA),
                //   thickness: 10,
                // ),
                // SizedBox(
                //   height: 40,
                //   child: Row(
                //     children: [
                //       const Text('Postcode'),
                //       const Gap(10),
                //       Expanded(
                //           child: Center(
                //         child: TextField(
                //           controller: postcodeController,
                //           decoration: getInputDecoration(
                //             "         Postcode",
                //           ),
                //         ),
                //       )),
                //     ],
                //   ),
                // ),
                // const Divider(
                //   height: 30,
                //   color: Color(0xffFAFAFA),
                //   thickness: 10,
                // ),
                Visibility(
                  visible: false,
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        const Text('Set as Default'),
                        const Spacer(),
                        CupertinoSwitch(
                            value: widget.defaultValue ?? selected,
                            onChanged: (value) {
                              setState(() {
                                selected = value;
                                widget.defaultValue = value;
                              });
                            })
                      ],
                    ),
                  ),
                ),
              ]),
            ),
            const Gap(40),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Consumer<Auth>(builder: (context, auth, authWidget) {
                auth.getAuthToken();
                return MaterialButton(
                  height: 40,
                  onPressed: () async {
                    if (selected == true) {}
                    if (streetController.text.isNotEmpty &&
                        cityController.text.isNotEmpty &&
                        houseController.text.isNotEmpty) {
                      if (widget.building != null &&  nameController.text.isNotEmpty) {
                    

                        await auth
                            .updateUserAddress(
                          userid: auth.user.userId.toString(),
                          street: streetController.text.trim(),
                          building: cityController.text.trim(),
                          remark: 'remark',
                          postcode: postcodeController.text.trim(),
                          floor: houseController.text.trim(),
                          id: widget.id,
                          name:nameController.text.trim(),
                          index: widget.index!.toInt(),
                          defaultValue: widget.defaultValue,
                        )
                            .then((value) {
                          auth.getUserAddress();
                          CommonFunctions.showSuccessToast(
                              auth.successfulMessage);
                             Navigator.pop(context);
                        });
                      } else {
                        await auth
                            .addUserAddress(
                              name: nameController.text,
                          userid: auth.user.userId.toString(),
                          street: streetController.text.trim(),
                          building: cityController.text.trim(),
                          postcode: "",
                          remark: 'remark',
                          floor: houseController.text.trim(),
                        )
                            .then((value) {
                          CommonFunctions.showSuccessToast(
                              auth.successfulMessage);
                           Navigator.pop(context);
                             auth.getUserAddress();
                          
                        });
                      }
                    } else {
                      CommonFunctions.showSuccessToast('complete all fields');
                    }
                  },
                  child: auth.load
                      ? const Center(child: CircularProgressIndicator(color: Colors.white,))
                      : Text(
                          widget.remark != null ? "update" : "Add",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                  color: kGreenColor,
                  shape: const StadiumBorder(),
                );
              }),
            ),
            const Gap(20),
          ],
        ));
  }
}
