import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Juego del Gato',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego del Gato'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tablero del juego
              Container(
                width: size.width * 0.8, // 80% del ancho de la pantalla
                height: size.width * 0.8, // Mantenerlo cuadrado
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: GridView.builder(
                  physics:
                      const NeverScrollableScrollPhysics(), // Desactiva scroll interno
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        gameState.playMove(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            gameState.board[index],
                            style: TextStyle(
                              fontSize: size.width * 0.08,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Mensaje de ganador o empate
              if (gameState.winner != null)
                Text(
                  'Ganador: ${gameState.winner}',
                  style: const TextStyle(fontSize: 24, color: Colors.green),
                ),
              if (gameState.isDraw && gameState.winner == null)
                const Text(
                  'Empate',
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
              const SizedBox(height: 20),
              // Botón para reiniciar
              ElevatedButton(
                onPressed: gameState.resetGame,
                child: const Text('Reiniciar Juego'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameState extends ChangeNotifier {
  List<String> _board = List.generate(9, (_) => '');
  String _currentPlayer = 'X';
  String? _winner;
  bool _isDraw = false;

  List<String> get board => _board;
  String get currentPlayer => _currentPlayer;
  String? get winner => _winner;
  bool get isDraw => _isDraw;

  void playMove(int index) {
    if (_board[index] == '' && _winner == null) {
      _board[index] = _currentPlayer;
      if (_checkWinner()) {
        _winner = _currentPlayer;
      } else if (!_board.contains('')) {
        _isDraw = true;
      } else {
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
      }
      notifyListeners();
    }
  }

  bool _checkWinner() {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Filas
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columnas
      [0, 4, 8], [2, 4, 6], // Diagonales
    ];

    for (var pattern in winPatterns) {
      if (_board[pattern[0]] == _currentPlayer &&
          _board[pattern[1]] == _currentPlayer &&
          _board[pattern[2]] == _currentPlayer) {
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    _board = List.generate(9, (_) => '');
    _currentPlayer = 'X';
    _winner = null;
    _isDraw = false;
    notifyListeners();
  }
}
