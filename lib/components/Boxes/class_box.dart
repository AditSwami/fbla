import 'package:fbla_2025/Services/Firebase/firestore/classes.dart';
import 'package:fbla_2025/data/Provider.dart';
import 'package:fbla_2025/pages/Units/class_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fbla_2025/app_ui.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

// ignore: must_be_immutable
class ClassBox extends StatefulWidget {
  ClassBox({super.key, required this.clas});

  ClassData clas;

  @override
  State<ClassBox> createState() => _ClassBoxState();
}

class _ClassBoxState extends State<ClassBox> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppUi.backgroundDark,
          builder: (context) => Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.delete, color: AppUi.offWhite),
                  title: Text('Delete Class', 
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppUi.offWhite
                    )
                  ),
                  onTap: () async {
                    // Show confirmation dialog
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppUi.backgroundDark,
                        title: Text('Delete Class?', 
                          style: Theme.of(context).textTheme.titleLarge
                        ),
                        content: Text('This action cannot be undone.', 
                          style: Theme.of(context).textTheme.bodyMedium
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Cancel', 
                              style: TextStyle(color: AppUi.offWhite)
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Delete', 
                              style: TextStyle(color: AppUi.error)
                            ),
                          ),
                        ],
                      ),
                    );
                    
                    if (confirm == true) {
                      context.read<UserProvider>().removeClass(widget.clas);
                      Navigator.pop(context); // Close bottom sheet
                    }
                  },
                ),
                // Replace the existing share ListTile with this:
                  ListTile(
                    leading: Icon(Icons.share, color: AppUi.offWhite),
                    title: Text('Share Class', 
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppUi.offWhite
                      )
                    ),
                    onTap: () async {
                      final classCode = widget.clas.id;
                      final className = widget.clas.name;
                      Navigator.pop(context);
                      
                      await Share.share(
                        'Join my class "${className}" on Study Buddy!\n\nClass Code: $classCode',
                        subject: 'Join my Study Buddy class'
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
      child: Container(
        height: 121,
        width: 371,
        decoration: BoxDecoration(
          color: AppUi.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppUi.grey.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 13, left: 18),
                  child: Text(
                    widget.clas.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 17.0),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: 300, maxHeight: 60),
                    child: Text(
                      widget.clas.description,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0, bottom: 65),
              child: Icon(
                Icons.chevron_right_rounded,
                color: AppUi.grey,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClassPage(clas: widget.clas)),
      ),
    );
  }
}
