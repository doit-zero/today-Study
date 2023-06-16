import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:mark0/Stores/store2.dart';
import 'package:mark0/Stores/store1.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EndDialog extends StatefulWidget {
  const EndDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<EndDialog> createState() => _EndDialogState();
}

//오늘 날짜
String today = DateTime.now().toString().split(" ").first;

// 두 시간 값을 합산하는 메서드
String addTimes(String time1, String time2) {
  final time1Parts = time1.split(':');
  final time2Parts = time2.split(':');

  final hours = int.parse(time1Parts[0]) + int.parse(time2Parts[0]);
  final minutes = int.parse(time1Parts[1]) + int.parse(time2Parts[1]);
  final seconds = int.parse(time1Parts[2]) + int.parse(time2Parts[2]);

  final newMinutes = minutes + (seconds ~/ 60);
  final newSeconds = seconds % 60;
  final newHours = hours + (newMinutes ~/ 60);
  final finalMinutes = newMinutes % 60;

  return '$newHours:${finalMinutes.toString().padLeft(2, '0')}:${newSeconds.toString().padLeft(2, '0')}';
}

class _EndDialogState extends State<EndDialog> {
  @override
  @SemanticsHintOverrides()
  Widget build(BuildContext context) {
    var store2 = context.read<Store2>();
    var store1 = context.read<Store1>();
    int studytime = store1.totalSeconds;
    final storeTime = store1.format(studytime);
    var comList = store2.comList;
    List<String> todayConvertComList = [];

    //convertComList에 오늘 날짜의 데이터가 없을 경우에 실행되는 함수
    newComlist() {
      setState(() {
        Map<String, dynamic> newComList = {
          '날짜': DateTime.now().toString().split(" ").first,
          '공부시간': storeTime,
          '완료 목록': comList,
        };
        // 그래서 newComList를 jsonEncoder 해줘야함
        String jsonNewComList = jsonEncode(newComList);
        store2.convertComList.add(jsonNewComList);
        // 스토리지에 오늘 날짜의 convertComList 추가 해줌
        store2.saveData();
      });
    }

    //convertComList에 오늘 날짜의 데이터가 있을 경우 실행 할 함수
    upadteNewComList() {
      // covertComlist는 제이슨 인코더로 스트링화 되어있음 그래서 처음에 제이슨 디코드 실행
      List<Map<String, dynamic>> decodedList = store2.convertComList.map(
        (e) {
          return jsonDecode(e) as Map<String, dynamic>;
        },
      ).toList();
      // decodeList에서 오늘 날짜에 해당하는 리스트를 todayData로 가져오기
      Map<String, dynamic>? todayData;
      for (var data in decodedList) {
        if (data['날짜'] == today) {
          todayData = data;
          break;
        }
      }

      // todayData의 완료 목록에 새로운 리스트 추가하기
      // todayData[0]['공부 목록']. 완료 목록에 아이템이 없을 경우도 대비해서 != 인경우를 추가해줌

      if (todayData != null) {
        // 공부 시간을 업데이트
        final previousStudyTime = todayData['공부시간'] as String? ?? '0:00:00';
        final updatedStudyTime = addTimes(previousStudyTime, storeTime);
        todayData['공부시간'] = updatedStudyTime;
        // 완료 목록을 업데이트
        (todayData['완료 목록'] as List<dynamic>).addAll(comList ?? []);
      }

      // 스토리지에 저장하기 위해 List<String> 화를 거침
      List<String> updateConvertComList = decodedList.map(
        (data) {
          return jsonEncode(data);
        },
      ).toList();

      setState(() {
        // store2에 있는 convertComList를 updateConvertComList로 바꾸고
        store2.convertComList = updateConvertComList;
        //그 데이터를 저장소에 저장
        store2.saveData();
      });
    }

    return AlertDialog(
      title: const Text('오늘의 공부시간'),
      content: Text(storeTime),
      actions: [
        TextButton(
          onPressed: () {
            // any()를 통해서  true or false 값을 알 수 있음
            // json타입의 경우 contains에서 원하는 데이터 검색시 따옴표를 잘줘야함
            if (store2.convertComList
                .any((data) => data.contains('"날짜":"$today"'))) {
              // convertComList에 공부 시간은 더해주고, 완료 목록 리스트에 아이템 추가해주기
              upadteNewComList();
              store2.deleteComList();
              store1.reset();
            } else {
              // converComList에 오늘 날짜 해당하는 리스트 생성
              newComlist();
              store2.deleteComList();
              store1.reset();
            }
            Navigator.of(context).pop();
          },
          child: const Text('확인'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('취소'),
        ),
      ],
    );
  }
}
