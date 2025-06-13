import 'package:flutter/material.dart';
import 'package:project/models/user_model.dart';
import 'package:project/widgets/account_screen/profile_info_tile.dart';
import 'package:project/widgets/account_screen/profile_tabs.dart';
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Account settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey[100],
            child: Center(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.green[100],
                                child: const Icon(
                                  Icons.edit,
                                  size: 12,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          UserModel.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          UserModel.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const ProfileTabs(),
                    const SizedBox(height: 20),
                    ProfileInfoTile(
                      iconData: Icons.flag_outlined,
                      label: 'Goal',
                      value: UserModel.goal,
                      color: const Color(0xFFE9C6F9),
                    ),
                    ProfileInfoTile(
                      iconData: Icons.calendar_today_outlined,
                      label: 'Age',
                      value: UserModel.age.toString(),
                      color: const Color(0xFFDBD1F8),
                    ),
                    ProfileInfoTile(
                      iconData: Icons.person_outline,
                      label: 'Gender',
                      value: UserModel.gender,
                      color: const Color(0xFFE9C6F9),
                    ),
                    ProfileInfoTile(
                      iconData: Icons.height,
                      label: 'Height',
                      value: '${UserModel.height} cm',
                      color: const Color(0xFFDBD1F8),
                    ),
                    ProfileInfoTile(
                      iconData: Icons.fitness_center_outlined,
                      label: 'Weight',
                      value: '${UserModel.weight} kg',
                      color: const Color(0xFFE9C6F9),
                    ),
                    ProfileInfoTile(
                      iconData: Icons.directions_run,
                      label: 'Activity Level',
                      value: UserModel.activityLevel,
                      color: const Color(0xFFDBD1F8),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}