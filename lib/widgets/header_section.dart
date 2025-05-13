import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String userName;

  const HeaderSection({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile section with avatar and message
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                //backgroundImage: const NetworkImage('https://via.placeholder.com/40'),
                // In a real app, use the user's actual avatar
              ),
              const SizedBox(width: 10),
              Text(
                'Keep going, $userName!',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          // Notification icons
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  // Navigate to favorites/bookmarks
                },
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {
                      // Navigate to notifications
                    },
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}