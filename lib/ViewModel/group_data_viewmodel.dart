import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_lab_task/Model/group_model.dart';
import 'package:flutter/cupertino.dart';

class GroupDataViewModel extends ChangeNotifier {
  List<GroupModel> groups = [];
  bool isLoadingGroups = true;

  static TextEditingController groupNameController = TextEditingController();
  static TextEditingController groupTypeController = TextEditingController();

  static final GroupDataViewModel _instance = GroupDataViewModel._internal();

  GroupDataViewModel._internal();

  factory GroupDataViewModel() {
    return _instance;
  }

  fetchGroupData() async {
    isLoadingGroups = true;

    final querySnapshot =
        await FirebaseFirestore.instance.collection('groups').get();

    for (var doc in querySnapshot.docs) {
      var data = doc.data();
      GroupModel group = GroupModel()
        ..groupType = data['group-type']
        ..groupName = data['group-name'];

      groups.add(group);
    }
    isLoadingGroups = false;
    notifyListeners();
  }

  List<GroupModel> getAllGroups() {
    return groups;
  }

  postGroupData() async {
    await FirebaseFirestore.instance.collection('groups').doc().set(
      {
        "group-name": groupNameController.text,
        "group-type": groupTypeController.text,
      },
      SetOptions(merge: true),
    );
    groupTypeController.clear();
    groupNameController.clear();
  }
}
