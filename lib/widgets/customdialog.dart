import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mark0/Stores/store2.dart';

// 오늘의 공부 리스트 + 버튼을 눌렀을때 나오는 다이얼로그
class CustomDialog extends StatelessWidget {
  const CustomDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String data = '';

    return AlertDialog(
      title: const Text('오늘도 화이팅!! '),
      content: TextField(
        onChanged: (value) {
          data = value;
        },
        decoration: const InputDecoration(
          hintText: '텍스트를 입력하세요',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (data != '') {
              context.read<Store2>().addToList(data);
            }
            Navigator.of(context).pop();
          },
          child: const Text('저장'),
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
