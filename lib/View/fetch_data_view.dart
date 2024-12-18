import 'package:cloud_lab_task/View/send_data_view.dart';
import 'package:cloud_lab_task/ViewModel/group_data_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FetchDataView extends StatefulWidget {
  const FetchDataView({super.key});

  @override
  State<FetchDataView> createState() => _FetchDataViewState();
}

class _FetchDataViewState extends State<FetchDataView> {
  @override
  void initState() {
    super.initState();
    Provider.of<GroupDataViewModel>(context, listen: false).groups.clear();
    Provider.of<GroupDataViewModel>(context, listen: false).fetchGroupData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
        toolbarHeight: 140,
        title: const Center(
          child: Text(
            "Get data from Firestore",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: Consumer<GroupDataViewModel>(
        builder: (context, groupData, child) {
          return groupData.isLoadingGroups
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                )
              : SingleChildScrollView(
                child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          columnSpacing: 20,
                          columns: const [
                            DataColumn(label: Text('Group Name', style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),)),
                            DataColumn(label: Text('Group Type', style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),)),
                          ],
                          rows: groupData.getAllGroups().map((group) {
                            return DataRow(
                              cells: [
                                DataCell(Text(group.groupName ?? '', style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),)),
                                DataCell(Text(group.groupType ?? '', style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                
                
                      const SizedBox(height: 40,),
                
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 100),
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                          onPressed: () async {
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const SendDataScreen()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.blue),
                          ),
                          child: const Text(
                            "Send Data to Firestore",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
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
