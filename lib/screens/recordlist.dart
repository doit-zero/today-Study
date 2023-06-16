import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';

import '../Stores/store2.dart';

class RecordList extends StatefulWidget {
  const RecordList({super.key});

  @override
  State<RecordList> createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  var todayFilteredList = [];
  List<Map<String, dynamic>> parsedList = [];
  List<String> studytime = [];
  List<dynamic> studylist = [];

  // 현재 달
  DateTime currentMonth = DateTime.now();
  // Duration parseDuration 정의
  Duration parseDuration(String durationString) {
    List<String> parts = durationString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  @override
  void initState() {
    super.initState();
    context.read<Store2>().loadData();
  }

  @override
  Widget build(BuildContext context) {
    var store2 = context.read<Store2>();
    List<String> convertComList = store2.convertComList;

    // 총 공부 시간
    Duration totalStudyTime = const Duration();

    //모든 데이터 중 내가 원하는 월 불러오기 = 화면에 보여진 달임
    List<String> filteredList = convertComList.where((data) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      DateTime date = DateTime.parse(jsonData['날짜']);
      return date.month == currentMonth.month;
    }).toList();

    // 이번달 공부시간 모두 더하기
    for (String data in filteredList) {
      Map<String, dynamic> jsonData = jsonDecode(data);
      Duration studyTime = parseDuration(jsonData['공부시간']);
      totalStudyTime += studyTime;
    }

    // 하루 평균 공부 시간
    String averageStudyTime = filteredList.isNotEmpty
        ? '${(totalStudyTime.inHours % 24).toString().padLeft(1, '0')}:${(totalStudyTime.inMinutes % 60).toString().padLeft(2, '0')}:${(totalStudyTime.inSeconds % 60).toString().padLeft(2, '0')}'
        : '0:00:00';

    updatelist(var a) {
      setState(() {
        // 저장소에서 클릭된 날짜와 같은 데이터를 가져오는 필터 적용한 리스트 출력
        todayFilteredList =
            convertComList.where((item) => item.contains(a)).toList();

        // 필터가 적용 된 리스트를 다시 jsonDecode 해줌
        parsedList = todayFilteredList.map((jsonString) {
          Map<String, dynamic> parsedMap = jsonDecode(jsonString);
          return parsedMap;
        }).toList();

        // jsonDecode된 데이터에서 원하는 데이터를 리스트로 만들어 줌
        studylist = parsedList.map((map) => map['완료 목록']).toList();
        studytime = parsedList.map((map) => map['공부시간'] as String).toList();
      });
    }

    // studyTime 리셋!
    studyTimeReset() {
      studytime = ['0:00:00'];
      String jsonString = todayFilteredList[0];
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      jsonData['공부시간'] = studytime[0];
      String updatedJsonString = jsonEncode(jsonData);
      // 클릭한 날짜에 해당하는 데이터를 convertComList에서 찾아서 공부시간 업데이트
      int index = store2.convertComList.indexOf(jsonString);
      if (index != -1) {
        convertComList[index] = updatedJsonString;
        store2.saveData();
      }
    }

    //studylist 지우기 studylist[0].remove(item);
    studyListDelete(item) {
      studylist[0].remove(item);
      String jsonString = todayFilteredList[0];
      Map<String, dynamic> jsonData = jsonDecode(jsonString);
      jsonData['완료 목록'] = studylist[0];
      String updatedJsonString = jsonEncode(jsonData);
      //클릭한 날짜에 해당하는 데이터를 convertComList에서 찾아서 완료 목록 업데이트
      int index = store2.convertComList.indexOf(jsonString);
      if (index != -1) {
        convertComList[index] = updatedJsonString;
        store2.saveData();
      }
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
        child: ListView(children: [
          Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '이번달 공부 시간',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(totalStudyTime.toString().split('.').first,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w800))
                        ],
                      ),
                    ),
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(40)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            '하루 평균 공부 시간',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            averageStudyTime.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w800),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TableCalendar(
                locale: 'ko_KR',
                // 지금 보는 날짜 어딘지 설정해주는 것
                focusedDay: currentMonth,
                firstDay: DateTime.utc(1992, 8, 17),
                lastDay: DateTime.utc(2030, 8, 17),
                // 달력 페이지 전환시 바뀐 달력 데이터를 currentMonth에 전송
                onPageChanged: (focusedMonth) {
                  setState(() {
                    currentMonth = focusedMonth;
                  });
                },

                // 달력 헤더 부분
                headerStyle: HeaderStyle(
                  headerMargin: const EdgeInsets.symmetric(vertical: 20),
                  headerPadding: const EdgeInsets.symmetric(vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: const TextStyle(color: Colors.black),
                ),

                // 달력 안부분
                calendarStyle: const CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: false,
                  todayDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 240, 117, 108),
                      shape: BoxShape.circle),
                  weekendTextStyle:
                      TextStyle(color: Color.fromARGB(255, 243, 38, 24)),
                  holidayTextStyle:
                      TextStyle(color: Color.fromARGB(255, 243, 38, 24)),
                ),

                // 날짜가 선택 되어있을 때 실행되는 것들
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                  setState(() {
                    var search = selectedDay.toString().split(" ").first;
                    updatelist(search);
                    //선택한 날짜 업데이트
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 146),
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(40)),
                          child: const Text(
                            '공부 시간',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              studytime.join(", ").toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
                            ),
                            if (studylist.isNotEmpty && studylist[0] != null)
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    studyTimeReset();
                                  });
                                },
                                icon: const Icon(Icons.refresh_outlined),
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 146),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(40)),
                    child: const Text(
                      '완료 목록',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    //완료 목록 보여줌
                    children: [
                      if (studylist.isNotEmpty && studylist[0] != null)
                        for (var item in studylist[0])
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  item.toString(),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    studyListDelete(item);
                                  });
                                },
                                icon: const Icon(Icons.remove),
                              )
                            ],
                          ),
                    ],
                  )
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }
}
