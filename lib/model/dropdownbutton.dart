import 'package:flutter/material.dart';
// import 'package:tapai_app/resource/colors.dart';
import 'package:test/page/article_edit.dart';



Widget dropdownButtonItem(String title, List data, Map selectedItem, int selectedId, Function handleChange,) {
  List<Widget> widgets = [
    Text(title),
    DropdownButtonHideUnderline(
//  DropdownButton默认有一条下划线（如上图），此widget去除下划线
      child: DropdownButton(
        items: data.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item['name'],),
        )).toList(),
        hint: Text('请选择'),
        onChanged: handleChange(),
        value: selectedItem,
      ),
    ),
  ];
  return optionItemDecorator(widgets);
}

Widget optionItemDecorator(List<Widget> widgets) {
  return Container(

  );
}

