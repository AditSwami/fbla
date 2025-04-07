import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/progress_service.dart';
import 'package:fbla_2025/components/Buttons/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fbla_2025/app_ui.dart';
import 'dart:math' as math;

class WordSearch extends StatefulWidget {
  const WordSearch({
    super.key, 
    required this.terms,
    required this.unit,
    required this.clas,
  });

  final Map<String, dynamic> terms;
  final UnitData unit;
  final ClassData clas;

  @override
  State<WordSearch> createState() => _WordSearchState();
}

class _WordSearchState extends State<WordSearch> {
  late List<List<String>> grid;
  late List<String> words;
  late List<bool> foundWords;
  int gridSize = 10;
  int score = 0;
  String? selectedWord;
  List<List<bool>> selectedCells = [];
  DateTime startTime = DateTime.now();

  // Add this new variable to store word positions
  List<List<List<int>>> wordPositions = [];

  @override
  void initState() {
    super.initState();
    // Take first 5 terms and their definitions
    words = widget.terms.keys.take(5).toList();
    foundWords = List.generate(words.length, (_) => false);
    selectedCells = List.generate(
      gridSize, 
      (_) => List.generate(gridSize, (_) => false)
    );
    wordPositions = List.generate(words.length, (_) => []);
    _generateGrid();
  }

  bool _tryPlaceWord(String word, int row, int col, int direction) {
    int dr = 0, dc = 0;
    switch (direction) {
      case 0: dc = 1; break;
      case 1: dr = 1; break;
      case 2: dr = dc = 1; break;
    }

    if (!_canPlaceWord(word, row, col, dr, dc)) return false;

    // Store positions for this word
    List<List<int>> positions = [];
    for (int i = 0; i < word.length; i++) {
      grid[row + i * dr][col + i * dc] = word[i];
      positions.add([row + i * dr, col + i * dc]);
    }
    
    print("Placed word: $word at positions: $positions"); // Debug print
    
    // Find word index and store positions
    int wordIndex = words.indexWhere((w) => w.toUpperCase() == word);
    if (wordIndex != -1) {
      wordPositions[wordIndex] = positions;
    }
    
    return true;
  }

  void _generateGrid() {
    grid = List.generate(
      gridSize, 
      (_) => List.generate(gridSize, (_) => '')
    );
    
    // Place words first
    for (String word in words) {
      bool placed = false;
      int attempts = 0;
      while (!placed && attempts < 100) {
        int direction = math.Random().nextInt(3);
        int row = math.Random().nextInt(gridSize);
        int col = math.Random().nextInt(gridSize);
        
        placed = _tryPlaceWord(word.toUpperCase(), row, col, direction);
        attempts++;
      }
      if (!placed) {
        print("Failed to place word: $word"); // Debug print
      }
    }
    
    // Fill remaining spaces with random letters
    final random = math.Random();
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (grid[i][j] == '') {
          grid[i][j] = String.fromCharCode(random.nextInt(26) + 65);
        }
      }
    }
  }

  bool _canPlaceWord(String word, int row, int col, int dr, int dc) {
    if (row + (word.length - 1) * dr >= gridSize || 
        col + (word.length - 1) * dc >= gridSize) return false;

    for (int i = 0; i < word.length; i++) {
      if (grid[row + i * dr][col + i * dc] != '' && 
          grid[row + i * dr][col + i * dc] != word[i]) {
        return false;
      }
    }
    return true;
  }

  void _checkSelection(int row, int col) {
    setState(() {
      selectedCells[row][col] = !selectedCells[row][col];
      
      // Get selected word
      String selected = '';
      for (int i = 0; i < gridSize; i++) {
        for (int j = 0; j < gridSize; j++) {
          if (selectedCells[i][j]) {
            selected += grid[i][j];
          }
        }
      }

      // Check if word is found
      for (int i = 0; i < words.length; i++) {
        if (selected == words[i].toUpperCase() && !foundWords[i]) {
          foundWords[i] = true;
          score += 10;
          
          // Clear selection
          selectedCells = List.generate(
            gridSize, 
            (_) => List.generate(gridSize, (_) => false)
          );

          // Check if game is complete
          if (foundWords.every((found) => found)) {
            _showCompletionDialog();
          }
          break;
        }
      }
    });
  }

  void _showCompletionDialog() {
    final duration = DateTime.now().difference(startTime);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    // Calculate final score based on time
    if (duration.inSeconds < 180) {  // Under 3 minutes
      score += 20;
    } else if (duration.inSeconds < 300) {  // Under 5 minutes
      score += 10;
    }

    // Save score
    ProgressService.saveScore(widget.unit.id, 'wordsearch', score);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppUi.backgroundDark,
        title: Text('Congratulations!', 
          style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Time: ${minutes}m ${seconds}s'),
            const SizedBox(height: 8),
            Text('Score: $score'),
            if (duration.inSeconds < 180) ...[
              const SizedBox(height: 8),
              Text('🏆 Speed Demon! +20 points',
                style: TextStyle(color: AppUi.primary)),
            ] else if (duration.inSeconds < 300) ...[
              const SizedBox(height: 8),
              Text('⚡ Quick Finder! +10 points',
                style: TextStyle(color: AppUi.primary)),
            ],
          ],
        ),
        actions: [
          Button(
            height: 40,
            width: 80,
            color: AppUi.primary,
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Center(
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppUi.offWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppUi.backgroundDark,
        centerTitle: false,
        title: Text('Word Search', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb_outline, color: AppUi.offWhite),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppUi.backgroundDark,
                  title: Text('Word Locations', 
                    style: Theme.of(context).textTheme.titleLarge),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: words.map((word) {
                        // Find word position in grid
                        String position = 'Not found';
                        for (int i = 0; i < gridSize; i++) {
                          for (int j = 0; j < gridSize; j++) {
                            // Check horizontal
                            if (j + word.length <= gridSize) {
                              String horizontal = '';
                              for (int k = 0; k < word.length; k++) {
                                horizontal += grid[i][j + k];
                              }
                              if (horizontal == word.toUpperCase()) {
                                position = 'Row ${i + 1}, Column ${j + 1} (→)';
                              }
                            }
                            // Check vertical
                            if (i + word.length <= gridSize) {
                              String vertical = '';
                              for (int k = 0; k < word.length; k++) {
                                vertical += grid[i + k][j];
                              }
                              if (vertical == word.toUpperCase()) {
                                position = 'Row ${i + 1}, Column ${j + 1} (↓)';
                              }
                            }
                            // Check diagonal
                            if (i + word.length <= gridSize && j + word.length <= gridSize) {
                              String diagonal = '';
                              for (int k = 0; k < word.length; k++) {
                                diagonal += grid[i + k][j + k];
                              }
                              if (diagonal == word.toUpperCase()) {
                                position = 'Row ${i + 1}, Column ${j + 1} (↘)';
                              }
                            }
                          }
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(word,
                                style: Theme.of(context).textTheme.bodyMedium),
                              Text(position,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppUi.primary
                                )),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  actions: [
                    Button(
                      height: 40,
                      width: 80,
                      color: AppUi.primary,
                      onTap: () => Navigator.pop(context),
                      child: Center(
                        child: Text(
                          'OK',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppUi.offWhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
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
          // Word Bank with definitions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                words.length,
                (index) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: foundWords[index]
                        ? AppUi.primary.withOpacity(0.15)
                        : AppUi.backgroundDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: foundWords[index]
                          ? AppUi.primary.withOpacity(0.3)
                          : AppUi.grey.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    widget.terms[words[index]],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: foundWords[index]
                          ? AppUi.primary
                          : AppUi.offWhite,
                      decoration: foundWords[index]
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: gridSize * gridSize,
              itemBuilder: (context, index) {
                final row = index ~/ gridSize;
                final col = index % gridSize;
                return GestureDetector(
                  onTap: () => _checkSelection(row, col),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedCells[row][col]
                          ? AppUi.primary.withOpacity(0.3)
                          : AppUi.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: selectedCells[row][col]
                            ? AppUi.primary
                            : AppUi.grey.withOpacity(0.2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        grid[row][col],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: selectedCells[row][col]
                              ? AppUi.primary
                              : AppUi.offWhite,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}