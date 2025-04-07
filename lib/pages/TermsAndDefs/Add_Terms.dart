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
  
  @override
  void initState() {
    super.initState();
    // Start with one row
    termRows.add(TermsAddRow(unit: widget.unit));
  }

  void _addNewRow() {
    setState(() {
      termRows.add(TermsAddRow(unit: widget.unit));
    });
  }

  void _submitTerms() async {
    Map<String, dynamic> newTerms = {};
    
    for (var row in termRows) {
      if (row.term.text.isNotEmpty && row.definition.text.isNotEmpty) {
        // Store as simple String key-value pairs
        newTerms[row.term.text] = row.definition.text;
      }
    }

    if (newTerms.isNotEmpty) {
      try {
        // Update in Firebase with the raw Map
        await Firestore.addTerm(newTerms, widget.unit, widget.clas);
        
        // Update local unit terms
        widget.unit.terms.addAll(newTerms);
        
        Navigator.pop(context, true);
      } catch (e) {
        print('Debug error: $e'); // Add this to see detailed error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding terms: $e')),
        );
      }
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
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Button(
              onTap: _addNewRow,
              height: 35,
              width: 35,
              child: Center(
                child: Icon(
                  Icons.add,
                  color: AppUi.offWhite,
                  size: 24,
                ),
              ),
            ),
          ),
          Button(
            height: 35,
            width: 70,
            onTap: _submitTerms,
            child: Center(
              child: Text(
                'Submit',
                style: Theme.of(context).textTheme.bodyMedium
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
                  padding: const EdgeInsets.all(8.0),
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
