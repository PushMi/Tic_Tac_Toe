import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String player_X = "X";
  static const String player_Y = "O";

  late String currentPLayer;
  late bool gameEnd;
  late List<String> occupied;

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame(){
    currentPLayer = player_X;
    gameEnd = false;
    occupied = ["", "", "", "", "", "", "", "", ""]; //9 empty places
  }

  changeTurn() {
    if (currentPLayer == player_X) {
      currentPLayer = player_Y;
    }else{
      currentPLayer = player_X;
    }
  }

  checkForWinner() {
    List<List<int>> winningList = [
      //row
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      //column
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      //diagonal
      [0, 4, 8],
      [2, 4, 6],
    ];

    for(var winningPos in winningList) {
      String playerPosition0 = occupied[winningPos[0]];
      String playerPosition1 = occupied[winningPos[1]];
      String playerPosition2 = occupied[winningPos[2]];

      if(playerPosition0.isNotEmpty){
        if(playerPosition0 == playerPosition1 && playerPosition0 == playerPosition2){
          //all equal means player won
          showGameOverMessage("Player '$playerPosition0' won");
          gameEnd = true;
          return;
        }
      }
    }
  }

  showGameOverMessage(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.cyan.withOpacity(0.5),
          content: Text(
            "Game Over \n $message",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
      ),
    );
  }

  checkForDraw(){
    if(gameEnd){
      return;
    }
    bool draw = true;
    for (var occupiedPlayer in occupied){
      if(occupiedPlayer.isEmpty){
        //at least one is empty not all are filled
        draw = false;
      }
    }
    if(draw){
      showGameOverMessage('Tie, Play Again!');
      gameEnd = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tic Tac Toe'),
        backgroundColor: Colors.cyan[800],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.pink, Colors.teal], begin: Alignment.topLeft, end: Alignment.topRight),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "'$currentPLayer' make a move!",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 6.0,
                    mainAxisSpacing: 9.0),
                  itemCount: 9,
                  itemBuilder: (context, int index) => SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: (){
                            if(gameEnd || occupied[index].isNotEmpty){
                              return;
                            }
                            setState(() {
                              occupied[index] = currentPLayer;
                              changeTurn();
                              checkForWinner();
                              checkForDraw();
                            });
                          },
                        style: ElevatedButton.styleFrom(
                          elevation: 7,
                          backgroundColor: occupied[index].isEmpty
                              ? Colors.grey
                              : occupied[index]==player_X
                              ? Colors.cyan[800]
                              : Colors.pink[400],
                        ),
                          child: Text(
                            occupied[index],
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                            ),
                          ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 35.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.pink.withOpacity(0.7),
                ),
                onPressed: (){
                  setState(() {
                    initializeGame();
                  });
                },
                child: const Text("Reset Game"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
