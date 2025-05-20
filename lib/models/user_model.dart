// lib/models/user_model.dart
class UserModel {
  static String name = "Maria Di Martino";
  static String email = "mariamartino17@gmail.com";
  static String gender = "Female";
  static int age = 25;
  static int height = 165;
  static int weight = 75;
  static int weightGoal = 65; // Add this for weight goal
  static String activityLevel = "Lightly active";
  static String goal = "Lose weight"; // Main goal
  static String pace = "0.5"; // Add this for weight loss/gain pace
  
  static void updateUser(String newName, String newEmail) {
    name = newName;
    email = newEmail;
  }
  
  static void updateUserDetails(String newGender, int newAge, int newHeight, 
      int newWeight, String newActivityLevel) {
    gender = newGender;
    age = newAge;
    height = newHeight;
    weight = newWeight;
    activityLevel = newActivityLevel;
  }
  
  static void setGoal(String newGoal) {
    goal = newGoal;
  }
  
  static void setWeightGoal(int newWeightGoal) {
    weightGoal = newWeightGoal;
  }
  
  static void setPace(String newPace) {
    pace = newPace;
  }
}