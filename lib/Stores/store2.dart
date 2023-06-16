import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Store2 extends ChangeNotifier {
  // 오늘의 공부 리스트 + 버튼을 누르면 생성되는 리스트
  List<String> toList = [];
  // 공부 완료 리스트에 저장되는 리스트
  List<String> comList = [];
  // 오늘의 공부 끝?! 을 누르면 생성되는 리스트
  List<String> convertComList = [];

  Future saveData() async {
    var storage = await SharedPreferences.getInstance();
    storage.setStringList('todoList', toList);
    storage.setStringList('comList', comList);
    storage.setStringList('convertComList', convertComList);
    notifyListeners();
  }

  Future loadData() async {
    var storage = await SharedPreferences.getInstance();
    toList = storage.getStringList('todoList') ?? [];
    comList = storage.getStringList('comList') ?? [];
    convertComList = storage.getStringList('convertComList') ?? [];
    notifyListeners();
  }

// 오늘 공부 끝 확인버튼 누르면 데이터 삭제
  Future deleteComList() async {
    comList.clear();
    notifyListeners();
  }

// convertComList 데이터 전부 삭제
  Future clearConvertComList() async {
    convertComList.clear();
    notifyListeners();
  }

// 저장소의 convertComList 삭제하는 함수
  Future deleteConvertComList(a) async {
    var storage = await SharedPreferences.getInstance();
    String aa = a.toString();
    storage.remove(aa);
    notifyListeners();
  }

// toList에서 원하는 리스트 아이템 제거하는 함수
  Future deleteData(a) async {
    var storage = await SharedPreferences.getInstance();
    String aa = a.toString();
    storage.remove(aa);
    notifyListeners();
  }

//toList에 리스트 아이템 추가하는 함수
  addToList(String item) {
    toList.add(item);
    saveData();
    notifyListeners();
  }
}
