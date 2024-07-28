import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/screens/home/home_view.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// Bottom Tabs
const Map<int, List> homeTabs = {
  1: ['home', FeatherIcons.home],
  2: ['search', FeatherIcons.search],
  3: ['my-courses', FeatherIcons.book],
  4: ['profile', FeatherIcons.user],
};
                     
final navBarIndexProvider = StateProvider<int>((ref) => 0);

class NavBar extends ConsumerWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navBarIndexProvider);
    return SalomonBottomBar(
      
      backgroundColor: Color.fromRGBO(27, 27, 27, 1),
      curve: Curves.easeIn,
      currentIndex: currentIndex,
      selectedColorOpacity: 1,
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.all(12),
      unselectedItemColor: Colors.white,
      onTap: (int index) {
        ref.read(navBarIndexProvider.notifier).state = index;
        if (_shouldAnimate(currentIndex, index)) {
          ref
              .read(homeTabControllerProvider.notifier)
              .state
              .animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
        } else {
          ref.read(homeTabControllerProvider.notifier).state.jumpToPage(index);
        }
      },
      items: homeTabs.entries.map((e) {
        return SalomonBottomBarItem(
          activeIcon: Icon(e.value[1], color: Colors.black,),
          selectedColor: Colors.white,
          icon: Icon(e.value[1],),
          title: Text(
            e.value[0],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black),
          ).tr(),
        );
      }).toList(),
    );
  }

  bool _shouldAnimate(int currentIndex, int newIndex) {
    int dif = currentIndex - newIndex;
    if (dif > 1 || dif < -1) {
      return false;
    } else {
      return true;
    }
  }
}
