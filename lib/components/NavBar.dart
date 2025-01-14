import 'package:fbla_2025/app_ui.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  NavBar({super.key, required this.selectedIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    List<IconData> navIcon = [Icons.home, Icons.class_outlined, Icons.settings];
    return Container(
      height: 65,
      margin: const EdgeInsets.only(
        top: 55,
        right: 24,
        left: 24,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppUi.grey.withOpacity(0.1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: navIcon.map((icon) {
          int index = navIcon.indexOf(icon);
          bool isSelect = selectedIndex == index;

          return GestureDetector(
            onTap: () => onItemSelected(index), // Trigger the callback
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 35,
                    right: 35,
                  ),
                  child: isSelect
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          height: 45,
                          width: 35,
                          decoration: BoxDecoration(
                            color: AppUi.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            icon,
                            color: Colors.black,
                          ),
                        )
                      : Container(
                          height: 45,
                          width: 35,
                          color: Colors.transparent,
                          child: Icon(
                            icon,
                            color: AppUi.offWhite,
                          ),
                        ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
