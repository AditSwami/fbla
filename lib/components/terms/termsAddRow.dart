import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsAddRow extends StatefulWidget {  // Change to StatefulWidget
  TermsAddRow({super.key, required this.unit});

  final UnitData unit;
  final TextEditingController term = TextEditingController();
  final TextEditingController definition = TextEditingController();

  @override
  State<TermsAddRow> createState() => _TermsAddRowState();
}

class _TermsAddRowState extends State<TermsAddRow> {
  String? termError;
  String? definitionError;

  // Syntactical validation
  String? validateTerm(String? value) {
    if (value == null || value.isEmpty) {
      return 'Term required';
    }
    if (value.length < 2) {
      return 'Min 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9\s-]+$').hasMatch(value)) {
      return 'Only letters, numbers, spaces';
    }
    return null;
  }

  // Semantic validation
  String? validateDefinition(String? value) {
    if (value == null || value.isEmpty) {
      return 'Definition required';
    }
    if (value.length < 2) {
      return 'Too short';
    }
    if (widget.unit.terms.containsKey(widget.term.text)) {
      return 'Term already exists';
    }
    // Check if definition is educational
    if (!value.contains(RegExp(r'(means|is|refers to|describes|represents)', caseSensitive: false))) {
      return 'Use educational language';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppUi.grey.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppUi.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Term',
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppUi.grey.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 40,
                          maxHeight: 200,
                        ),
                        child: CupertinoTextField(
                          controller: widget.term,
                          placeholder: 'Term',
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: null, // Allows infinite lines
                          keyboardType: TextInputType.multiline,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: termError != null 
                                ? Colors.red.withOpacity(0.3) 
                                : AppUi.grey.withOpacity(0.2),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onChanged: (value) => setState(() {
                            termError = validateTerm(value);
                          }),
                        ),
                      ),
                    ),
                    if (termError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          termError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Definition',
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppUi.grey.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 40,
                          maxHeight: 200,
                        ),
                        child: CupertinoTextField(
                          controller: widget.definition,
                          placeholder: 'Definition',
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: null, // Allows infinite lines
                          keyboardType: TextInputType.multiline,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: definitionError != null 
                                ? Colors.red.withOpacity(0.3) 
                                : AppUi.grey.withOpacity(0.2),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onChanged: (value) => setState(() {
                            definitionError = validateDefinition(value);
                          }),
                        ),
                      ),
                    ),
                    if (definitionError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          definitionError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}