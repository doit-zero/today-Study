import 'package:flutter/material.dart';
import 'package:mark0/widgets/timer.dart';
import 'package:provider/provider.dart';
import '../widgets/customdialog.dart';
import '../widgets/enddialog.dart';
import 'package:mark0/Stores/store2.dart';
import 'package:mark0/Stores/store1.dart';

class TodayList extends StatefulWidget {
  const TodayList({
    super.key,
  });

  @override
  State<TodayList> createState() => _TodayListState();
}

class _TodayListState extends State<TodayList> {
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<Store2>().loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Timers(),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(40)),
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(now.toString().split(" ").first),
                const Text(
                  '오늘의 공부 리스트',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const CustomDialog();
                      },
                    );
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: context.watch<Store2>().toList.length,
              itemBuilder: (context, index) {
                return Draggable<String>(
                  data: context.watch<Store2>().toList[index],
                  feedback: Material(
                    child: Container(
                      color: Colors.grey,
                      child: Text(context.watch<Store2>().toList[index]),
                    ),
                  ),
                  childWhenDragging: Container(
                    height: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(context.watch<Store2>().toList[index])),
                      IconButton(
                        onPressed: () {
                          final store2 = context.read<Store2>();
                          store2.toList.removeAt(index);
                          store2.deleteData(index);
                          store2.saveData();
                        },
                        icon: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            '공부 완료 리스트',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: DragTarget<String>(
              builder: (context, List<String?> candidateData, rejectedData) {
                return ListView.builder(
                  itemCount: context.watch<Store2>().comList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              context.watch<Store2>().comList[index],
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                final store2 = context.read<Store2>();
                                store2.comList.removeAt(index);
                                store2.deleteData(index);
                                store2.saveData();
                              },
                              icon: const Icon(Icons.remove))
                        ],
                      ),
                    );
                  },
                );
              },
              onWillAccept: (data) {
                return true;
              },
              onAccept: (data) {
                final store2 = context.read<Store2>();
                store2.comList.add(data);
                store2.toList.remove(data);
                store2.saveData();
              },
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 240, 117, 108),
                fixedSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              onPressed: () {
                context.read<Store1>().onPuasePressed();
                showDialog(
                  context: context,
                  builder: (context) {
                    return const EndDialog();
                  },
                );
              },
              child: const Text('오늘의 공부 끝?'))
        ],
      ),
    );
  }
}
