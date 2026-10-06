import 'package:spendapp/widgets/common_dropdown/model/popup_menu_model.dart';
import 'package:flutter/material.dart';

class CommonDropdown<T> extends StatefulWidget {
  const CommonDropdown({super.key, this.listMenu});
  final List<PopupMenuModel<T>>? listMenu;

  @override
  State<CommonDropdown> createState() => _CommonDropdownState();
}

class _CommonDropdownState extends State<CommonDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container();
    // return PopupMenuButton(
    //   itemBuilder: (context) {
    //     return (widget.listMenu ?? []).map((e) {
    //       return PopupMenuItem(child: Text(),);
    //     }).toList();
    //   },
    // );
  }
}
