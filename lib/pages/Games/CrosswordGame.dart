import 'package:flutter/material.dart';
import 'package:fbla_2025/app_ui.dart';

class CrosswordGame extends StatefulWidget {
  const CrosswordGame({super.key, required this.terms});

  final Map<String, dynamic> terms;

  @override
  State<CrosswordGame> createState() => _CrosswordGameState();
}

class _CrosswordGameState extends State<CrosswordGame> {
  late List<String> words;
  late List<String> clues;
  late List<List<String>> grid;
  late List<List<TextEditingController>> controllers;
  late List<List<bool>> isEnabled;
  int gridSize = 15;
  int score = 0;

  @override
  void initState() {
    super.initState();
    words = widget.terms.keys.toList();
    clues = widget.terms.values.map((e) => e.toString()).toList();
    
    // Initialize empty grid
    grid = List.generate(
      gridSize,
      (_) => List.generate(gridSize, (_) => ''),
    );
    
    // Initialize controllers and enabled cells
    controllers = List.generate(
      gridSize,
      (_) => List.generate(
        gridSize,
        (_) => TextEditingController(),
      ),
    );
    
    isEnabled = List.generate(
      gridSize,
      (_) => List.generate(gridSize, (_) => false),
    );

    _generateCrossword();
  }

  void _generateCrossword() {
    // Place first word horizontally in the middle
    int startRow = gridSize ~/ 2;
    int startCol = (gridSize - words[0].length) ~/ 2;
    
    for (int i = 0; i < words[0].length; i++) {
      grid[startRow][startCol + i] = words[0][i];
      isEnabled[startRow][startCol + i] = true;
    }

    // Try to place other words
    for (int i = 1; i < words.length && i < 5; i++) {
      _placeWord(words[i]);
    }
  }

  bool _placeWord(String word) {
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        for (var letter in word.split('')) {
          if (grid[row][col] == letter) {
            // Try placing vertically
            if (_canPlaceVertically(word, row, col)) {
              _placeVertically(word, row, col);
              return true;
            }
            // Try placing horizontally
            if (_canPlaceHorizontally(word, row, col)) {
              _placeHorizontally(word, row, col);
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  void _placeVertically(String word, int row, int col) {
    int startRow = row - word.indexOf(grid[row][col]);
    for (int i = 0; i < word.length; i++) {
      if (grid[startRow + i][col] == '') {  // Only place if cell is empty
        grid[startRow + i][col] = word[i];
        isEnabled[startRow + i][col] = true;
      }
    }
  }

  void _placeHorizontally(String word, int row, int col) {
    int startCol = col - word.indexOf(grid[row][col]);
    for (int i = 0; i < word.length; i++) {
      if (grid[row][startCol + i] == '') {  // Only place if cell is empty
        grid[row][startCol + i] = word[i];
        isEnabled[row][startCol + i] = true;
      }
    }
  }

  bool _canPlaceVertically(String word, int row, int col) {
    if (row - word.indexOf(grid[row][col]) < 0 ||
        row + (word.length - word.indexOf(grid[row][col])) > gridSize) {
      return false;
    }
    
    // Check if placement would overlap other words incorrectly
    int startRow = row - word.indexOf(grid[row][col]);
    for (int i = 0; i < word.length; i++) {
      if (grid[startRow + i][col] != '' && 
          grid[startRow + i][col] != word[i]) {
        return false;
      }
    }
    return true;
  }

  bool _canPlaceHorizontally(String word, int row, int col) {
    if (col - word.indexOf(grid[row][col]) < 0 ||
        col + (word.length - word.indexOf(grid[row][col])) > gridSize) {
      return false;
    }
    
    // Check if placement would overlap other words incorrectly
    int startCol = col - word.indexOf(grid[row][col]);
    for (int i = 0; i < word.length; i++) {
      if (grid[row][startCol + i] != '' && 
          grid[row][startCol + i] != word[i]) {
        return false;
      }
    }
    return true;
  }

  void _checkAnswers() {
    int correct = 0;
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (isEnabled[i][j]) {
          if (controllers[i][j].text.toUpperCase() == grid[i][j].toUpperCase()) {
            correct++;
          }
        }
      }
    }
    setState(() {
      score = (correct * 100) ~/ words.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppUi.backgroundDark,
        title: Text('Crossword', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Score: $score',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // Crossword grid
          Expanded(
            flex: 2,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemCount: gridSize * gridSize,
              itemBuilder: (context, index) {
                final row = index ~/ gridSize;
                final col = index % gridSize;
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppUi.grey.withOpacity(0.3)),
                    color: isEnabled[row][col]
                        ? AppUi.grey.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: isEnabled[row][col]
                      ? TextField(
                          controller: controllers[row][col],
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                          ),
                        )
                      : null,
                );
              },
            ),
          ),
          // Clues
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: clues.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '${index + 1}. ${clues[index]}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkAnswers,
        child: const Icon(Icons.check),
      ),
    );
  }

  @override
  void dispose() {
    for (var row in controllers) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }
}