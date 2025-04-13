import 'dart:math';
import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/Services/Firebase/firestore/db.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:fbla_2025/components/Buttons/button.dart';
import 'package:fbla_2025/components/terms/termsAddRow.dart';
import 'package:flutter/material.dart';

class AddTermsPage extends StatefulWidget {
  const AddTermsPage({super.key, required this.unit, required this.clas});

  final UnitData unit;
  final ClassData clas;

  @override
  State<AddTermsPage> createState() => _AddTermsPageState();
}

class _AddTermsPageState extends State<AddTermsPage> {
  List<TermsAddRow> termRows = [];
  
  // In the _AddTermsPageState class
  
  @override
  void initState() {
    super.initState();
    // Start with one row
    termRows.add(TermsAddRow(unit: widget.unit, index: 0));
  }
  
  void _addNewRow() {
    setState(() {
      termRows.add(TermsAddRow(unit: widget.unit, index: termRows.length));
    });
  }

  void _submitTerms() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      // Collect valid terms and definitions
      Map<String, dynamic> newTerms = {};
      List<String> invalidRows = [];
      
      for (int i = 0; i < termRows.length; i++) {
        final row = termRows[i];
        final termText = row.termController.text.trim();
        final definitionText = row.definitionController.text.trim();
        
        // Skip empty rows
        if (termText.isEmpty && definitionText.isEmpty) continue;
        
        // Check for incomplete rows
        if (termText.isEmpty || definitionText.isEmpty) {
          invalidRows.add("Row ${i + 1}");
          continue;
        }
        
        // Check for duplicate terms
        if (newTerms.containsKey(termText) || widget.unit.terms.containsKey(termText)) {
          invalidRows.add("Row ${i + 1} (duplicate term: '$termText')");
          continue;
        }
        
        // Add valid term
        newTerms[termText] = definitionText;
      }
      
      // Close loading dialog
      Navigator.pop(context);
      
      // Handle invalid rows if any
      if (invalidRows.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Invalid Entries'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Please fix the following:'),
                const SizedBox(height: 8),
                ...invalidRows.map((row) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $row', style: TextStyle(color: AppUi.error)),
                )),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }
      
      // If no valid terms, show message
      if (newTerms.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Please add at least one term with definition',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: AppUi.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }
      
      // Save terms to Firebase
      await Firestore.addTerm(newTerms, widget.unit, widget.clas);
      
      // Update local unit terms
      setState(() {
        widget.unit.terms.addAll(newTerms);
      });
      
      // Show success message and return to previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Success!',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Added ${newTerms.length} ${newTerms.length == 1 ? 'term' : 'terms'} to ${widget.unit.name}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context, true);
      
    } catch (e) {
      // Close loading dialog if still showing
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      print('Error adding terms: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Error Adding Terms',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      e.toString().length > 50 
                          ? '${e.toString().substring(0, 50)}...' 
                          : e.toString(),
                      style: const TextStyle(fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: AppUi.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(12),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(
          'Add Terms',
          style: Theme.of(context).textTheme.titleLarge,
          overflow: TextOverflow.visible, // Prevent truncation
        ),
        titleSpacing: 0, // Reduce spacing to give more room for title
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Button(
              onTap: _addNewRow,
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.add,
                  color: AppUi.offWhite,
                  size: 24,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24.0), // Reduced right padding
            child: Button(
              height: 40,
              width: 80,
              onTap: _submitTerms,
              child: Center(
                child: Text(
                  'Done',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: termRows.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: termRows[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
