// lib/screens/account_screen.dart
import 'package:flutter/material.dart';
import '../widgets/profile_tabs.dart';
import '../widgets/profile_info_tile.dart';
import '../models/user_model.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                    // Profile image section now directly here
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
                            ),
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
                        // Use dynamic name and email from UserModel
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
                    // Display user data from UserModel
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
                    // Empty tiles with arrows for additional sections
                    const EmptyProfileTile(),
                    const EmptyProfileTile(),
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

class EmptyProfileTile extends StatelessWidget {
  const EmptyProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 40, height: 40),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}