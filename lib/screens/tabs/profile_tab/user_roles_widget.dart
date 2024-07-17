import 'package:easy_localization/easy_localization.dart';
import 'package:feather_icons/feather_icons.dart' show FeatherIcons;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_app/models/user_model.dart';

class UserRolesWidget extends StatelessWidget {  
  const UserRolesWidget({super.key, required this.user, required this.ref});

  final UserModel user;
  final WidgetRef ref;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.secondaryContainer,

      ),
      child: Column(
                children: [
                  Row(children: [
                    if (user.role!.contains('admin'))
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    //padding: const EdgeInsets.symmetric(horizontal: 100,vertical: 2.5),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [  
                            Text("admin_pin".tr(), style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize, color: Colors.white, fontWeight: FontWeight.w600), ),
                            SizedBox(width: 7.5,),
                            Icon(FeatherIcons.shield, color: Colors.white,)
                          ],
                        ),
                      ),
                    ),
                  ),
                
                if (user.role!.contains('author'))
                  Padding(
                  padding: EdgeInsets.all(8.0),
                    //padding: const EdgeInsets.symmetric(horizontal: 115.0, vertical: 2.5),
                    child: Container(
                      
                      decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [  
                            Text("author_pin".tr(), style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize, color: Colors.white, fontWeight: FontWeight.w600), ),
                            SizedBox(width: 7.5,),
                            Icon(FeatherIcons.book, color: Colors.white,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  ],),
                  Row(
                    children: [
                      if (!user.role!.contains('author'))
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        //padding: const EdgeInsets.symmetric(horizontal: 115.0,vertical: 2.5),
                        child: Container(      
                          decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [  
                                Text("student_pin".tr(), style: TextStyle(fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize, color: Colors.white, fontWeight: FontWeight.w600), ),
                                SizedBox(width: 7.5,),
                                Icon(FeatherIcons.book, color: Colors.white,)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              
        
      ),
    );
  }
}
