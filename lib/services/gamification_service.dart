/// Gamification Service - Handles XP, Levels, Streaks, and Achievements
/// This service implements psychological engagement features to increase user retention

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// User statistics model
class UserStats {
  int totalEdits;
  int currentStreak;
  int longestStreak;
  int totalXP;
  int level;
  DateTime? lastEditDate;
  List<String> unlockedAchievements;
  
  UserStats({
    this.totalEdits = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalXP = 0,
    this.level = 1,
    this.lastEditDate,
    List<String>? unlockedAchievements,
  }) : unlockedAchievements = unlockedAchievements ?? [];
  
  Map<String, dynamic> toJson() => {
    'totalEdits': totalEdits,
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'totalXP': totalXP,
    'level': level,
    'lastEditDate': lastEditDate?.toIso8601String(),
    'unlockedAchievements': unlockedAchievements,
  };
  
  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
    totalEdits: json['totalEdits'] ?? 0,
    currentStreak: json['currentStreak'] ?? 0,
    longestStreak: json['longestStreak'] ?? 0,
    totalXP: json['totalXP'] ?? 0,
    level: json['level'] ?? 1,
    lastEditDate: json['lastEditDate'] != null 
        ? DateTime.parse(json['lastEditDate'])
        : null,
    unlockedAchievements: List<String>.from(json['unlockedAchievements'] ?? []),
  );
}

/// Achievement definition
class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int requiredValue;
  final AchievementType type;
  
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requiredValue,
    required this.type,
  });
}

enum AchievementType {
  edits,
  streak,
  xp,
  level,
}

/// Gamification Service
class GamificationService {
  static const String _storageKey = 'user_stats';
  UserStats _stats = UserStats();
  
  // XP thresholds for levels
  static const List<int> levelThresholds = [
    0,      // Level 1
    100,    // Level 2
    250,    // Level 3
    500,    // Level 4
    1000,   // Level 5
    2000,   // Level 6
    3500,   // Level 7
    5500,   // Level 8
    8000,   // Level 9
    12000,  // Level 10
  ];
  
  // XP rewards for actions
  static const int xpPerEdit = 10;
  static const int xpPerStreak = 25;
  static const int xpPerAchievement = 100;
  
  // Achievements
  static const List<Achievement> achievements = [
    Achievement(
      id: 'first_edit',
      title: 'First Steps',
      description: 'Complete your first edit',
      icon: '🎨',
      requiredValue: 1,
      type: AchievementType.edits,
    ),
    Achievement(
      id: 'edit_10',
      title: 'Getting Started',
      description: 'Complete 10 edits',
      icon: '🖼️',
      requiredValue: 10,
      type: AchievementType.edits,
    ),
    Achievement(
      id: 'edit_50',
      title: 'Photo Enthusiast',
      description: 'Complete 50 edits',
      icon: '📸',
      requiredValue: 50,
      type: AchievementType.edits,
    ),
    Achievement(
      id: 'edit_100',
      title: 'Master Editor',
      description: 'Complete 100 edits',
      icon: '👑',
      requiredValue: 100,
      type: AchievementType.edits,
    ),
    Achievement(
      id: 'streak_3',
      title: 'On Fire',
      description: '3-day editing streak',
      icon: '🔥',
      requiredValue: 3,
      type: AchievementType.streak,
    ),
    Achievement(
      id: 'streak_7',
      title: 'Week Warrior',
      description: '7-day editing streak',
      icon: '⚡',
      requiredValue: 7,
      type: AchievementType.streak,
    ),
    Achievement(
      id: 'streak_30',
      title: 'Unstoppable',
      description: '30-day editing streak',
      icon: '💎',
      requiredValue: 30,
      type: AchievementType.streak,
    ),
    Achievement(
      id: 'level_5',
      title: 'Rising Star',
      description: 'Reach level 5',
      icon: '⭐',
      requiredValue: 5,
      type: AchievementType.level,
    ),
    Achievement(
      id: 'level_10',
      title: 'Photo Legend',
      description: 'Reach level 10',
      icon: '🏆',
      requiredValue: 10,
      type: AchievementType.level,
    ),
  ];
  
  /// Initialize and load user stats
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final statsJson = prefs.getString(_storageKey);
    
    if (statsJson != null) {
      _stats = UserStats.fromJson(json.decode(statsJson));
    }
    
    // Check and update streak
    await _updateStreak();
  }
  
  /// Save user stats
  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, json.encode(_stats.toJson()));
  }
  
  /// Update streak based on last edit date
  Future<void> _updateStreak() async {
    if (_stats.lastEditDate == null) return;
    
    final now = DateTime.now();
    final lastEdit = _stats.lastEditDate!;
    final daysDiff = now.difference(lastEdit).inDays;
    
    if (daysDiff == 1) {
      // Continue streak
      _stats.currentStreak++;
      if (_stats.currentStreak > _stats.longestStreak) {
        _stats.longestStreak = _stats.currentStreak;
      }
      await _saveStats();
    } else if (daysDiff > 1) {
      // Streak broken
      _stats.currentStreak = 0;
      await _saveStats();
    }
  }
  
  /// Record an edit action
  Future<List<Achievement>> recordEdit() async {
    _stats.totalEdits++;
    _stats.lastEditDate = DateTime.now();
    
    // Award XP
    _stats.totalXP += xpPerEdit;
    
    // Check for level up
    _checkLevelUp();
    
    // Check for streak
    final isNewDay = _isNewDay();
    if (isNewDay) {
      _stats.currentStreak++;
      _stats.totalXP += xpPerStreak;
      
      if (_stats.currentStreak > _stats.longestStreak) {
        _stats.longestStreak = _stats.currentStreak;
      }
    }
    
    await _saveStats();
    
    // Check for achievements
    return _checkAchievements();
  }
  
  /// Check if it's a new day
  bool _isNewDay() {
    if (_stats.lastEditDate == null) return true;
    
    final now = DateTime.now();
    final lastEdit = _stats.lastEditDate!;
    
    return now.year != lastEdit.year ||
           now.month != lastEdit.month ||
           now.day != lastEdit.day;
  }
  
  /// Check and update level
  void _checkLevelUp() {
    for (int i = levelThresholds.length - 1; i >= 0; i--) {
      if (_stats.totalXP >= levelThresholds[i]) {
        _stats.level = i + 1;
        break;
      }
    }
  }
  
  /// Check for newly unlocked achievements
  List<Achievement> _checkAchievements() {
    final newAchievements = <Achievement>[];
    
    for (final achievement in achievements) {
      if (_stats.unlockedAchievements.contains(achievement.id)) continue;
      
      bool unlocked = false;
      
      switch (achievement.type) {
        case AchievementType.edits:
          unlocked = _stats.totalEdits >= achievement.requiredValue;
          break;
        case AchievementType.streak:
          unlocked = _stats.currentStreak >= achievement.requiredValue;
          break;
        case AchievementType.level:
          unlocked = _stats.level >= achievement.requiredValue;
          break;
        case AchievementType.xp:
          unlocked = _stats.totalXP >= achievement.requiredValue;
          break;
      }
      
      if (unlocked) {
        _stats.unlockedAchievements.add(achievement.id);
        _stats.totalXP += xpPerAchievement;
        newAchievements.add(achievement);
      }
    }
    
    return newAchievements;
  }
  
  /// Get current user stats
  UserStats get stats => _stats;
  
  /// Get XP required for next level
  int getXPForNextLevel() {
    if (_stats.level >= levelThresholds.length) {
      return 0; // Max level
    }
    return levelThresholds[_stats.level] - _stats.totalXP;
  }
  
  /// Get progress to next level (0.0 to 1.0)
  double getLevelProgress() {
    if (_stats.level >= levelThresholds.length) {
      return 1.0; // Max level
    }
    
    final currentLevelXP = levelThresholds[_stats.level - 1];
    final nextLevelXP = levelThresholds[_stats.level];
    final progressXP = _stats.totalXP - currentLevelXP;
    final requiredXP = nextLevelXP - currentLevelXP;
    
    return (progressXP / requiredXP).clamp(0.0, 1.0);
  }
  
  /// Get level title
  String getLevelTitle() {
    if (_stats.level <= 1) return 'Beginner';
    if (_stats.level <= 3) return 'Novice';
    if (_stats.level <= 5) return 'Intermediate';
    if (_stats.level <= 7) return 'Advanced';
    if (_stats.level <= 9) return 'Expert';
    return 'Master';
  }
  
  /// Reset stats (for testing)
  Future<void> resetStats() async {
    _stats = UserStats();
    await _saveStats();
  }
}
