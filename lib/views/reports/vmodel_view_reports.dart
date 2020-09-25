import 'dart:async';

import 'package:Staffield/core/employees_repository.dart';
import 'package:Staffield/core/entities/employee.dart';
import 'package:Staffield/core/reports_repository.dart';
import 'package:Staffield/views/reports/report_type.dart';
import 'package:Staffield/views/reports/views/all_amployees/area_fl_charts.dart';
import 'package:Staffield/views/reports/views/all_amployees/chart_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class VModelViewReports extends GetxController {
  VModelViewReports() {
    _employee = employeesList.first;
    _employees.addAll(employeesList);
    fetchReportData();
  }
  final _reportsRepo = ReportsRepository();
  final _employeesRepo = Get.find<EmployeesRepository>();
  DateTime _endDate = DateTime(2020, 2, 1);
  int chartLessThan;

  DateTime _startDate = currentDay;

  ReportType _reportType = ReportType.fl_charts;
  Units period = Units.MONTH;
  Widget view = Center(child: CircularProgressIndicator());
  var _dummy = Employee(name: 'Нет сотрудников', uid: '111');

  //-----------------------------------------
  List<Employee> get employeesList =>
      _employeesRepo.repo.isNotEmpty ? _employeesRepo.repo : [_dummy];

  //-----------------------------------------
  Employee _employee;
  Employee get employee => _employee;
  set employee(Employee employee) {
    _employee = employee;
    fetchReportData();
  }

  //-----------------------------------------
  List<Employee> _employees = [];
  List<Employee> get employees => employees;
  // set employees() => employees;
  List<int> selectedItems = [];
  List<DropdownMenuItem> get items => employeesList
      .map((employee) => DropdownMenuItem(value: employee, child: Text(employee.name)))
      .toList();

  //-----------------------------------------
  ReportType get reportType => _reportType;
  set reportType(ReportType type) {
    _reportType = type;
    fetchReportData();
  }

  //-----------------------------------------
  static DateTime get currentDay {
    var now = DateTime.now();
    // return DateTime(now.year, now.month, now.day);
    return now;
  }

  //-----------------------------------------
  String get endDate => Jiffy(_endDate).MMMMd;

  //-----------------------------------------
  String get startDate => Jiffy(_startDate).MMMMd;

  //-----------------------------------------
  Future<void> pickEndDate(BuildContext context) async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: _endDate,
    );
    if (date != null) {
      _endDate = date;
      fetchReportData();
    }
  }

  //-----------------------------------------
  Future<void> pickStartDate(BuildContext context) async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: _startDate,
    );
    if (date != null) {
      _startDate = date;
      update();
    }
  }

  //-----------------------------------------
  Future<void> fetchReportData() async {
    view = Center(child: CircularProgressIndicator());
    update();

    switch (_reportType) {
      case ReportType.fl_charts:
        {
          var reports = _reportsRepo.fetch(
            periodsAmount: 6,
            period: period,
          );
          // var reports = _reportsRepo.fetchSingleEmployeeOverPeriod(
          //   greaterThan: _endDate,
          //   lessThan: _startDate,
          //   employeeUid: [_employee.uid],
          //   period: period,
          // );
          reports.then((reports) {
            ChartData.build(reports).then((data) {
              view = AreaFlCharts(data);
              update();
            });
          });
        }
      // case ReportType.listEmployees:
      //   {
      //     var entryReports = await _reportsRepo.fetchEntriesList(
      //         greaterThan: _endDate, lessThan: _startDate, employeeUid: null);
      //     var result =
      //         entryReports.map((entryReport) => ReportUiAdapted.from(entryReport)).toList();
      //     view = ListEmployees(result);
      //   }
      //   break;
      // case ReportType.allEmployees:
      //   {
      //     var reports = await _reportsRepo.fetchAllEmployees(
      //       period: period,
      //       periodsAmount: 1,
      //       lessThan: chartLessThan,
      //     );
      //     var tableData = await Future<TableData>.value(TableData(reports));
      //     view = TableEmployees(tableData);
      //     chartLessThan = reports.last.periodTimestamp - 1;
      //   }
      //   break;
      // case ReportType.singleEmployeeOverPeriod:
      //   {
      //     var reports = await _reportsRepo.fetchSingleEmployeeOverPeriod(
      //       greaterThan: _endDate,
      //       lessThan: _startDate,
      //       employeeUid: _employee.uid,
      //       period: period,
      //     );
      //     var result = reports.map((report) => PeriodReportUiAdapted(report)).toList();

      //     view = TableSingleEmployee(result);
      //   }
      //   break;
      // case ReportType.tableEntries:
      //   {
      //     var entryReports = await _reportsRepo.fetchEntriesList(
      //         greaterThan: _endDate, lessThan: _startDate, employeeUid: null);
      //     var result =
      //         entryReports.map((entryReport) => ReportUiAdapted.from(entryReport)).toList();
      //     view = TableEntries(result);
      //   }
      //   break;
    }
  }
}
