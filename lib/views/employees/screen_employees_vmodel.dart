import 'dart:async';

import 'package:Staffield/core/employees_repository.dart';
import 'package:Staffield/core/entities/employee.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenEmployeesVModel with ChangeNotifier {
  ScreenEmployeesVModel() {
    updateList();
    _subsc = _repo.updates.listen((data) {
      updateList();
    });
  }

  StreamSubscription _subsc;
  var list = <Employee>[];
  int recordsPerScreen = 10;
  final _repo = Get.find<EmployeesRepository>();
  bool showHidedEmployees = false;

  //-----------------------------------------
  bool get mode => showHidedEmployees;
  void switchMode() {
    showHidedEmployees = !showHidedEmployees;
    updateList();
  }

  //-----------------------------------------
  void updateList() {
    list = _repo.repoWhereHidden(showHidedEmployees);
    notifyListeners();
  }

  String get modeButtonLabel => showHidedEmployees ? 'АРХИВ' : 'АКТИВНЫЕ';

  //-----------------------------------------
  @override
  void dispose() {
    _subsc.cancel();
    super.dispose();
  }
}
