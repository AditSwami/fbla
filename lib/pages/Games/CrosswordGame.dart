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
  int gridSize = 13;
  int score = 0;

  // Add these properties to track word directions and numbers
  late List<List<int>> wordNumbers;
  late Map<int, String> wordDirections;

  @override
  void initState() {
    super.initState();
    words = widget.terms.keys.toList();
    clues = widget.terms.values.map((e) => e.toString()).toList();
    
    wordNumbers = List.generate(
      gridSize,
      (_) => List.generate(gridSize, (_) => 0),
    );
    wordDirections = {};
    
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

  // Modify _placeWord to track word numbers and directions
  // Add this class variable
  int currentWordNumber = 1;

  // Modify _placeWord method
  bool _placeWord(String word, bool isFirstWord) {
    if (isFirstWord) {
      int startRow = gridSize ~/ 2;
      int startCol = (gridSize - word.length) ~/ 2;
      
      wordNumbers[startRow][startCol] = currentWordNumber;
      wordDirections[currentWordNumber] = 'across';
      
      for (int i = 0; i < word.length; i++) {
        grid[startRow][startCol + i] = word[i];
        isEnabled[startRow][startCol + i] = true;
      }
      currentWordNumber++;
      return true;
    }
    int wordCount = 1;
    
    if (isFirstWord) {
      int startRow = gridSize ~/ 2;
      int startCol = (gridSize - word.length) ~/ 2;
      
      wordNumbers[startRow][startCol] = wordCount;
      wordDirections[wordCount] = 'across';
      
      for (int i = 0; i < word.length; i++) {
        grid[startRow][startCol + i] = word[i];
        isEnabled[startRow][startCol + i] = true;
      }
      wordCount++;
      return true;
    }

    bool placed = false;
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        if (grid[row][col].isNotEmpty) {
          int letterIndex = word.indexOf(grid[row][col]);
          if (letterIndex != -1) {
            if (_canPlaceVertically(word, row, col)) {
              _placeVertically(word, row, col);
              placed = true;
              break;
            }
            if (_canPlaceHorizontally(word, row, col)) {
              _placeHorizontally(word, row, col);
              placed = true;
              break;
            }
          }
        }
      }
      if (placed) break;
    }
    return placed;
  }

  void _generateCrossword() {
    // Place first word
    _placeWord(words[0], true);

    // Try to place other words
    for (int i = 1; i < words.length; i++) {
      _placeWord(words[i], false);
    }

    // Debug print to see the grid
    for (var row in grid) {
      print(row.join(' '));
    }
  }

  void _placeVertically(String word, int row, int col) {
    int startRow = row - word.indexOf(grid[row][col]);
    wordNumbers[startRow][col] = currentWordNumber;
    wordDirections[currentWordNumber] = 'down';
    currentWordNumber++;
    
    for (int i = 0; i < word.length; i++) {
      if (grid[startRow + i][col] == '') {
        grid[startRow + i][col] = word[i];
        isEnabled[startRow + i][col] = true;
      }
    }
  }

  void _placeHorizontally(String word, int row, int col) {
    int startCol = col - word.indexOf(grid[row][col]);
    wordNumbers[row][startCol] = currentWordNumber;
    wordDirections[currentWordNumber] = 'across';
    currentWordNumber++;
    
    for (int i = 0; i < word.length; i++) {
      if (grid[row][startCol + i] == '') {
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
        centerTitle: false,
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
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Hints section with Across and Down
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Across:', style: Theme.of(context).textTheme.titleMedium),
                      Expanded(
                        child: ListView.builder(
                          itemCount: wordDirections.entries
                              .where((e) => e.value == 'across')
                              .length,
                          itemBuilder: (context, index) {
                            var entry = wordDirections.entries
                                .where((e) => e.value == 'across')
                                .elementAt(index);
                            return Text(
                              '${entry.key}. ${clues[entry.key - 1]}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Down:', style: Theme.of(context).textTheme.titleMedium),
                      Expanded(
                        child: ListView.builder(
                          itemCount: wordDirections.entries
                              .where((e) => e.value == 'down')
                              .length,
                          itemBuilder: (context, index) {
                            var entry = wordDirections.entries
                                .where((e) => e.value == 'down')
                                .elementAt(index);
                            return Text('${entry.key}. ${clues[entry.key - 1]}');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Crossword grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: 1.0, // Keep cells square
              ),
              itemCount: gridSize * gridSize,
              itemBuilder: (context, index) {
                final row = index ~/ gridSize;
                final col = index % gridSize;
                return Container(
                  width: 45,  // Increased from 40
                  height: 45, // Increased from 40
                  decoration: BoxDecoration(
                    border: Border.all(color: AppUi.grey.withOpacity(0.3)),
                    color: isEnabled[row][col]
                        ? AppUi.grey.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: Stack(
                    children: [
                      if (wordNumbers[row][col] > 0)
                        Positioned(
                          top: 2,
                          left: 2,
                          child: Text(
                            '${wordNumbers[row][col]}',
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      if (isEnabled[row][col])
                        Center(
                          child: SizedBox(
                            width: 35,  // Added fixed width for TextField
                            height: 35, // Added fixed height for TextField
                            child: TextField(
                              controller: controllers[row][col],
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(fontSize: 16),
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                              ),
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                        ),
                    ],
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