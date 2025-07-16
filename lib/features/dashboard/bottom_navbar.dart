import 'package:flutter/material.dart';

const kCard = Color(0xFF1E1E1E);
const kAccent = Color(0xFF9E4DFF);

class HomeBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const HomeBottomNav({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        currentIndex: index,
        onTap: onTap,
        backgroundColor: kCard,
        selectedItemColor: kAccent,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.checklist_rtl), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.view_list), label: ''),
        ],
      );
}
