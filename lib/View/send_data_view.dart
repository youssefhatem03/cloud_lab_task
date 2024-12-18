import 'package:cloud_lab_task/View/fetch_data_view.dart';
import 'package:cloud_lab_task/View/notis_view.dart';
import 'package:cloud_lab_task/ViewModel/group_data_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendDataScreen extends StatefulWidget {
  const SendDataScreen({super.key});

  @override
  State<SendDataScreen> createState() => _SendDataScreenState();
}

class _SendDataScreenState extends State<SendDataScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        toolbarHeight: 140,
        automaticallyImplyLeading: false,
        title: const Center(
            child: Text(
          "Send data to firestore",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        )),
      ),
      body: Consumer<GroupDataViewModel>(
        builder: (context, groupData, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: GroupDataViewModel.groupNameController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter Group Name",
                      hintStyle: const TextStyle(fontSize: 24),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: GroupDataViewModel.groupTypeController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter Group Type",
                      hintStyle: const TextStyle(fontSize: 24),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 100),
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () async {
                      if (GroupDataViewModel.groupNameController.text.isEmpty ||
                          GroupDataViewModel.groupTypeController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Both fields are required!",
                              style: TextStyle(fontSize: 18),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      groupData.postGroupData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Data sent to Firestore successfully!",
                            style: TextStyle(fontSize: 18),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    child: const Text(
                      "Send to firestore",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                ),


                const SizedBox(height: 50,),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 100),
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const FetchDataView()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.blue),
                    ),
                    child: const Text(
                      "Get all Groups",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),


                SizedBox(height: 30),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 100),
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStateProperty.all<Color>(Colors.blue),
                    ),
                    child: const Text(
                      "See Notifications",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
