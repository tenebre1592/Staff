import 'package:Staffield/constants/app_gradients.dart';
import 'package:Staffield/constants/app_text_styles.dart';
import 'package:Staffield/views/entries/view_entries_vmodel.dart';
import 'package:Staffield/views/entries/views/view_screen_entries_item.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:provider/provider.dart';

class ViewScreenEntriesBody extends StatefulWidget {
  @override
  _ViewScreenEntriesBodyState createState() => _ViewScreenEntriesBodyState();
}

class _ViewScreenEntriesBodyState extends State<ViewScreenEntriesBody> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: GetBuilder<VModelViewEntries>(
              builder: (vmodel) {
                if (vmodel.cache.length == 0)
                  return vmodel.endOfData
                      ? Center(
                          child: Text('Нет записей',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: Colors.white)),
                        )
                      : Center(child: CircularProgressIndicator());
                else
                  return NotificationListener<ScrollNotification>(
                    onNotification: (notif) {
                      if (notif.metrics.extentAfter < 200)
                        Provider.of<VModelViewEntries>(context, listen: false).fetchNextChunk();
                      return true;
                    },
                    child: Scrollbar(
                      child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: vmodel.cache.length,
                          itemBuilder: (context, index) => vmodel.cache[index].isDateLabel
                              ? Container(
                                  padding: EdgeInsets.only(left: 8.0),
                                  margin: EdgeInsets.only(top: 14.0, bottom: 14.0),
                                  alignment: Alignment.centerLeft,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    gradient: AppGradients.mirage,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        spreadRadius: 0,
                                        blurRadius: 2,
                                        offset: Offset(0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Text(vmodel.cache[index].date,
                                      style: AppTextStyles.dateLabel),
                                )
                              : ViewEntriesItem(vmodel.cache[index])),
                    ),
                  );
              },
            ),
          ),
        ],
      );
}
