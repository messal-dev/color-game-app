import 'dart:math';

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final rnd = Random.secure();

  Color currentColor;
  int currentBox;
  double currentOpacity = 0.1;
  int currentScore = 0;
  int topScore = 0;

  String status = 'START';
  String btnTitle = 'START';

  bool isPlay = false;

  int get randomBox {
    return rnd.nextInt(9);
  }

  int get randomColorCode {
    return rnd.nextInt(255);
  }

  Color get randomColor {
    return Color.fromRGBO(randomColorCode, randomColorCode, randomColorCode, 1);
  }

  void updateBox() {
    currentColor = randomColor;
    currentBox = randomBox;
  }

  void boxListener(int indexBox) {
    setState(() {
      if (indexBox == currentBox) {
        // Update Opacity
        if (currentOpacity < 1.0) {
          currentOpacity = double.parse(
            (currentOpacity + 0.1).toStringAsFixed(1),
          );
        }

        // Update scores
        currentScore++;
        if (currentScore > topScore) {
          topScore++;
        }

        updateBox();
      } else {
        currentScore = 0;
        status = 'GAME OVER';
        isPlay = false;
      }
    });
  }

  void startListener() {
    setState(() {
      currentScore = 0;
      currentOpacity = 0.1;
      isPlay = true;
      status = 'PLAYING';
      btnTitle = 'RESTART';
      updateBox();
    });
  }

  @override
  void initState() {
    updateBox();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text('Color Game')),
      body: Container(
        child: Column(
          children: [
            Container(
              height: size.height * 0.6,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (ctx, index) => boxBuilder(
                  currentBox == index
                      ? currentColor.withOpacity(currentOpacity)
                      : currentColor,
                  index,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              status,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  height: 2,
                  color: status == 'GAME OVER' ? Colors.red : Colors.black),
            ),
            Text(
              'Top scores: $topScore',
              style: TextStyle(height: 2),
            ),
            Text(
              'Your scores: $currentScore',
              style: TextStyle(height: 2),
            ),
            FlatButton(
              onPressed: startListener,
              child: Text(btnTitle, style: TextStyle(color: Colors.white)),
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }

  Widget boxBuilder(Color color, int indexBox) {
    return InkWell(
      onTap: isPlay ? () => boxListener(indexBox) : null,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.white),
        ),
      ),
    );
  }
}
