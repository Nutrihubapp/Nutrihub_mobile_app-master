import 'package:checkout_app/constants.dart';
import 'package:checkout_app/providers/auth.dart';
import 'package:checkout_app/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'add_address_screen.dart';

class AddressScreen extends StatefulWidget {
  AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
  }

  String mobile = "";
  String name = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        elevation: 0.0,
        title: 'Select delivery address',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: Provider.of<Auth>(context, listen: false).getUserAddress(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return   Shimmer.fromColors(
              //period:Duration(seconds:5),
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              child:Column(
                            children: [
                              Expanded(
                                child: ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return const Divider(height: 10);
                                    },
                                    shrinkWrap: true,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      // print(
                                      //   auth.storedUsersAddress.length,
                                      // );
                                      return GestureDetector(
                                        onLongPress: () {
                                         
                                        },
                                        onTap: () {
                                         
                                        },
                                        child: Container(
                                          height: 130,
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            children: [
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Text(  "",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        SizedBox(width: 60),
                                                        IconButton(
                                                          onPressed:(){},
                                                            icon: Icon(
                                                                Icons.edit),)
                                                             
                                                             
                                                           
                                                      ],
                                                    ),
                                                    const Gap(5),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.phone,
                                                            size: 12),
                                                        Text(mobile)
                                                      ],
                                                    ),
                                                    const Gap(5),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.location_on,
                                                            size: 12),
                                                        Text(
                                                        "",
                                                        )
                                                      ],
                                                    )
                                                  ]),
                                              const Spacer(),
                                             
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              Gap(70),
                            ],
                          ));
              } else {
                if (snapshot.error != null) {
                  //error
                  return const Center(
                    child: Text('Error Occured'),
                  );
                } else {
                  return Consumer<Auth>(builder: (context, auth, widget) {
                    name = auth.user.name ?? auth.userName;
                    mobile = auth.user.phone ?? auth.userMobile;
                    return auth.storedUsersAddress.isEmpty
                        ? SizedBox()
                        : Column(
                            children: [
                              Expanded(
                                child: ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return const Divider(height: 10);
                                    },
                                    shrinkWrap: true,
                                    itemCount: auth.storedUsersAddress.length,
                                    itemBuilder: (context, index) {
                                      // print(
                                      //   auth.storedUsersAddress.length,
                                      // );
                                      return GestureDetector(
                                        onLongPress: () {
                                          auth.updateDefault(index);
                                        },
                                        onTap: () {
                                          auth.updateDefault(index);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 130,
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            children: [
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Text( 
                                                                               auth.storedUsersAddress[index]['fullname'],
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        SizedBox(width: 60),
                                                        IconButton(
                                                            icon: Icon(
                                                                Icons.edit),
                                                            onPressed: () {
                                                              
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>auth
                                                                  .storedUsersAddress.asMap().containsKey(index) == false
                                                                        ? Scaffold(
                                                                            body:
                                                                                Shimmer.fromColors(
              //period:Duration(seconds:5),
              baseColor: Colors.white,
              highlightColor: Colors.grey,
              child:Column(
                            children: [
                              Expanded(
                                child: ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return const Divider(height: 10);
                                    },
                                    shrinkWrap: true,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      // print(
                                      //   auth.storedUsersAddress.length,
                                      // );
                                      return GestureDetector(
                                        onLongPress: () {
                                         
                                        },
                                        onTap: () {
                                         
                                        },
                                        child: Container(
                                          height: 130,
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            children: [
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Text(  "",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                        SizedBox(width: 60),
                                                        IconButton(
                                                          onPressed:(){},
                                                            icon: Icon(
                                                                Icons.edit),)
                                                             
                                                             
                                                           
                                                      ],
                                                    ),
                                                    const Gap(5),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.phone,
                                                            size: 12),
                                                        Text(mobile)
                                                      ],
                                                    ),
                                                    const Gap(5),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.location_on,
                                                            size: 12),
                                                        Text(
                                                        "",
                                                        )
                                                      ],
                                                    )
                                                  ]),
                                              const Spacer(),
                                             
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              Gap(70),
                            ],
                          )))
                                                                        : AddAddressScreen(
                                                                            name:
                                                                               auth.storedUsersAddress[index]['fullname'],
                                                                            defaultValue:
                                                                                auth.storedUsersAddress[index]['default'],
                                                                            index:
                                                                                index,
                                                                            remark:
                                                                                auth.storedUsersAddress[index]['remark'],
                                                                            // postcode:
                                                                            //     auth.storedUsersAddress[index]['postcode'],
                                                                            building:
                                                                                auth.storedUsersAddress[index]['building'],
                                                                            floor:
                                                                                auth.storedUsersAddress[index]['floor'],
                                                                            street:
                                                                                auth.storedUsersAddress[index]['street'],
                                                                            id: auth.storedUsersAddress[index]['id'],
                                                                          )),
                                                              );
                                                            }),
                                                      ],
                                                    ),
                                                    const Gap(5),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.phone,
                                                            size: 12),
                                                        Text(mobile)
                                                      ],
                                                    ),
                                                    const Gap(5),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.location_on,
                                                            size: 12),
                                                        Text(
                                                          auth.storedUsersAddress[
                                                              index]['street'],
                                                        )
                                                      ],
                                                    )
                                                  ]),
                                              const Spacer(),
                                              Visibility(
                                                visible:
                                                    auth.storedUsersAddress[
                                                        index]['default'],
                                                child: Column(children: const [
                                                  Text(
                                                    'Default',
                                                  ),
                                                  Icon(Icons.check),
                                                ]),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              Gap(70),
                            ],
                          );
                  });
                }
              }
            }),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddAddressScreen();
          }));
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Container(
            height: 60,
            width: 150,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: kGreenColor, borderRadius: BorderRadius.circular(20)),
            child: const Center(
                child: Text('Add new address',
                    style: TextStyle(color: Colors.white))),
          ),
        ),
      ),
    );
  }
}
