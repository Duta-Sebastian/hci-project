import 'package:flutter/material.dart';

class NutrientProgressBar extends StatelessWidget {
  final String title;
  final int current;
  final int target;
  final String unit;
  final double progress;

  const NutrientProgressBar({
    super.key,
    required this.title,
    required this.current,
    required this.target,
    required this.unit,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOverflow = current > target;
    final bool isComplete = current >= target && !isOverflow;
    
    // Calculate display values
    final displayProgress = isOverflow ? 1.0 : progress;
    
    return Container(
      width: 110,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        // Add subtle border for overflow
        border: isOverflow 
            ? Border.all(color: Colors.orange.shade200, width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title with overflow indicator
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isOverflow ? Colors.orange.shade700 : Colors.black,
                ),
              ),
              if (isOverflow) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.trending_up_rounded,
                  size: 14,
                  color: Colors.orange.shade600,
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          
          // Values with overflow styling
          Text(
            '$current/$target$unit',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isOverflow 
                  ? Colors.orange.shade700
                  : isComplete 
                      ? Colors.green.shade600
                      : Colors.grey.shade600,
              fontWeight: isOverflow || isComplete ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          
          if (isOverflow) ...[
            const SizedBox(height: 2),
            Text(
              '+${current - target}$unit over',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.orange.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          
          const SizedBox(height: 10),
          
          // Enhanced progress bar
          Stack(
            children: [
              // Base progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: displayProgress,
                  backgroundColor: Colors.grey.shade200,
                  color: isOverflow 
                      ? Colors.orange.shade400
                      : isComplete 
                          ? Colors.green.shade400
                          : const Color.fromRGBO(181, 241, 77, 1),
                  minHeight: 8,
                ),
              ),
              
              // Overflow indicator
              if (isOverflow)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade300.withOpacity(0.8),
                            Colors.red.shade300.withOpacity(0.6),
                          ],
                          stops: [0.8, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                
              // Completion sparkle effect
              if (isComplete && !isOverflow)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade300.withOpacity(0.6),
                            Colors.green.shade400.withOpacity(0.8),
                            Colors.green.shade300.withOpacity(0.6),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          // Status indicator
          if (isComplete || isOverflow) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isOverflow 
                    ? Colors.orange.shade50
                    : Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isOverflow 
                      ? Colors.orange.shade200
                      : Colors.green.shade200,
                  width: 1,
                ),
              ),
              child: Text(
                isOverflow ? 'Over' : 'Complete',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isOverflow 
                      ? Colors.orange.shade700
                      : Colors.green.shade700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}