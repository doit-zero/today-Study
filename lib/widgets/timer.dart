import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mark0/Stores/store1.dart';

class Timers extends StatefulWidget {
  const Timers({super.key});

  @override
  State<Timers> createState() => _TimersState();
}

class _TimersState extends State<Timers> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(40)),
            height: 60,
            child: Text(
              context
                  .read<Store1>()
                  .format(context.read<Store1>().totalSeconds),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        Expanded(
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(40),
            ),
            child: TextButton(
              onPressed: () {
                context.read<Store1>().clicked();
              },
              child: Text(
                context.watch<Store1>().buttonName,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Text(context.watch<Store1>().buttonName)
