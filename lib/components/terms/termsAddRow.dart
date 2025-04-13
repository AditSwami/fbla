import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsAddRow extends StatefulWidget {
  TermsAddRow({
    super.key, 
    required this.unit, 
    required this.index
  }) {
    // Initialize controllers in the constructor
    termController = TextEditingController();
    definitionController = TextEditingController();
  }

  final UnitData unit;
  final int index;
  
  // Expose controllers as public fields
  late final TextEditingController termController;
  late final TextEditingController definitionController;
  
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
    if (widget.unit.terms.containsKey(widget.termController.text)) {
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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppUi.grey.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppUi.grey.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Term number header
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Term ${widget.index + 1}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppUi.primary,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Term label above the text field
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4, left: 4),
                      child: Text(
                        'Term',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppUi.grey,
                        ),
                      ),
                    ),
                    // Term field
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
                          controller: widget.termController,
                          placeholder: 'Enter term',
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: null,
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
                    // Error message below the text field
                    if (termError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 4),
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
                flex: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Definition label above the text field
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4, left: 4),
                      child: Text(
                        'Definition',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppUi.grey,
                        ),
                      ),
                    ),
                    // Definition field
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
                          controller: widget.definitionController,
                          placeholder: 'Enter definition',
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: null,
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
                    // Error message below the text field
                    if (definitionError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 4),
                        child: Text(
                          definitionError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}