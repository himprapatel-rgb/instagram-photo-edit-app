import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:async';
// v0.6.0 - Gamification UI Integration & Enhanced Features

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Instagram Photo Editor',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      primaryColor: Color(0xFF833AB4),
      colorScheme: ColorScheme.dark(
        primary: Color(0xFF833AB4),
        secondary: Color(0xFFFD1D1D),
      ),
    ),
    home: const HomePage(),
  );
}

// ==================== GAMIFICATION DATA MODELS ====================

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
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int requiredValue;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requiredValue,
  });
}

class DailyChallenge {
  final String title;
  final String description;
  final int xpReward;
  final int targetCount;
  int currentCount;
  bool completed;

  DailyChallenge({
    required this.title,
    required this.description,
    required this.xpReward,
    required this.targetCount,
    this.currentCount = 0,
    this.completed = false,
  });
}

// ==================== GAMIFICATION SERVICE ====================

class GamificationService {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;
  GamificationService._internal();

  UserStats stats = UserStats();
  DailyChallenge? dailyChallenge;

  static const List<int> levelThresholds = [
    0, 100, 250, 500, 1000, 2000, 3500, 5500, 8000, 12000,
    17000, 23000, 30000, 40000, 52000,
  ];

  static const int xpPerEdit = 15;
  static const int xpPerStreak = 30;
  static const int xpPerAchievement = 150;

  static const List<Achievement> achievements = [
    Achievement(id: 'first_edit', title: 'First Steps', description: 'Complete your first edit', icon: '🎨', requiredValue: 1),
    Achievement(id: 'edit_10', title: 'Getting Started', description: 'Complete 10 edits', icon: '🖼️', requiredValue: 10),
    Achievement(id: 'edit_50', title: 'Photo Enthusiast', description: 'Complete 50 edits', icon: '📸', requiredValue: 50),
    Achievement(id: 'edit_100', title: 'Master Editor', description: 'Complete 100 edits', icon: '👑', requiredValue: 100),
    Achievement(id: 'streak_3', title: 'On Fire', description: '3-day editing streak', icon: '🔥', requiredValue: 3),
    Achievement(id: 'streak_7', title: 'Week Warrior', description: '7-day editing streak', icon: '⚡', requiredValue: 7),
    Achievement(id: 'level_5', title: 'Rising Star', description: 'Reach level 5', icon: '⭐', requiredValue: 5),
    Achievement(id: 'level_10', title: 'Photo Legend', description: 'Reach level 10', icon: '🏆', requiredValue: 10),
  ];

  void initialize() {
    _generateDailyChallenge();
  }

  void _generateDailyChallenge() {
    final challenges = [
      DailyChallenge(title: 'Filter Master', description: 'Apply 5 different filters', xpReward: 100, targetCount: 5),
      DailyChallenge(title: 'Quick Editor', description: 'Edit 3 photos', xpReward: 75, targetCount: 3),
      DailyChallenge(title: 'Adjustment Pro', description: 'Use all adjustment sliders', xpReward: 80, targetCount: 3),
    ];
    dailyChallenge = challenges[DateTime.now().day % challenges.length];
  }

  List<Achievement> recordEdit() {
    stats.totalEdits++;
    stats.totalXP += xpPerEdit;
    _checkLevelUp();
    return _checkAchievements();
  }

  void _checkLevelUp() {
    for (int i = levelThresholds.length - 1; i >= 0; i--) {
      if (stats.totalXP >= levelThresholds[i]) {
        stats.level = i + 1;
        break;
      }
    }
  }

  List<Achievement> _checkAchievements() {
    final newAchievements = <Achievement>[];
    for (final achievement in achievements) {
      if (stats.unlockedAchievements.contains(achievement.id)) continue;
      bool unlocked = false;
      if (achievement.id.startsWith('edit_') || achievement.id == 'first_edit') {
        unlocked = stats.totalEdits >= achievement.requiredValue;
      } else if (achievement.id.startsWith('streak_')) {
        unlocked = stats.currentStreak >= achievement.requiredValue;
      } else if (achievement.id.startsWith('level_')) {
        unlocked = stats.level >= achievement.requiredValue;
      }
      if (unlocked) {
        stats.unlockedAchievements.add(achievement.id);
        stats.totalXP += xpPerAchievement;
        newAchievements.add(achievement);
      }
    }
    return newAchievements;
  }

  double getLevelProgress() {
    if (stats.level >= levelThresholds.length) return 1.0;
    final currentLevelXP = levelThresholds[stats.level - 1];
    final nextLevelXP = levelThresholds[stats.level];
    final progressXP = stats.totalXP - currentLevelXP;
    final requiredXP = nextLevelXP - currentLevelXP;
    return (progressXP / requiredXP).clamp(0.0, 1.0);
  }

  int getXPForNextLevel() {
    if (stats.level >= levelThresholds.length) return 0;
    return levelThresholds[stats.level] - stats.totalXP;
  }

  String getLevelTitle() {
    if (stats.level <= 1) return 'Beginner';
    if (stats.level <= 3) return 'Novice';
    if (stats.level <= 5) return 'Intermediate';
    if (stats.level <= 7) return 'Advanced';
    if (stats.level <= 9) return 'Expert';
    return 'Master';
  }
}

// ==================== GAMIFICATION UI WIDGETS ====================

// XP Bar Widget
class XPBarWidget extends StatelessWidget {
  final GamificationService gamification;
  
  const XPBarWidget({Key? key, required this.gamification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A1F3A), Color(0xFF2D3561)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Level Badge
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF833AB4), Color(0xFFFD1D1D)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Lv.${gamification.stats.level}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          SizedBox(width: 12),
          // XP Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      gamification.getLevelTitle(),
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    Text(
                      '${gamification.stats.totalXP} XP',
                      style: TextStyle(fontSize: 12, color: Color(0xFFFCAF45)),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: gamification.getLevelProgress(),
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFFCAF45),
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Streak Widget
class StreakWidget extends StatelessWidget {
  final int streak;
  
  const StreakWidget({Key? key, required this.streak}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: streak > 0 ? Color(0xFFFF6B35) : Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
        boxShadow: streak > 0 ? [
          BoxShadow(color: Color(0xFFFF6B35).withOpacity(0.4), blurRadius: 8),
        ] : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(streak > 0 ? '🔥' : '❄️', style: TextStyle(fontSize: 16)),
          SizedBox(width: 4),
          Text(
            '$streak day${streak != 1 ? 's' : ''}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Achievement Notification
class AchievementNotification {
  static void show(BuildContext context, Achievement achievement) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    
    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 500),
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.8 + (value * 0.2),
                child: child,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCAF45)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Color(0xFF833AB4).withOpacity(0.5), blurRadius: 20),
                ],
              ),
              child: Row(
                children: [
                  Text(achievement.icon, style: TextStyle(fontSize: 40)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🎉 Achievement Unlocked!',
                          style: TextStyle(fontSize: 12, color: Colors.white70)),
                        Text(achievement.title,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(achievement.description,
                          style: TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    
    overlay.insert(entry);
    Future.delayed(Duration(seconds: 3), () => entry.remove());
  }
}

// Level Up Animation
class LevelUpAnimation {
  static void show(BuildContext context, int newLevel) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 800),
          builder: (context, value, child) => Transform.scale(
            scale: value,
            child: child,
          ),
          child: Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF833AB4), Color(0xFFFD1D1D)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Color(0xFF833AB4).withOpacity(0.6), blurRadius: 30),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('⭐', style: TextStyle(fontSize: 60)),
                SizedBox(height: 16),
                Text('LEVEL UP!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2)),
                SizedBox(height: 8),
                Text('Level $newLevel', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Color(0xFF833AB4)),
                  child: Text('Awesome!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Daily Challenge Card
class DailyChallengeCard extends StatelessWidget {
  final DailyChallenge challenge;
  final VoidCallback onTap;
  
  const DailyChallengeCard({Key? key, required this.challenge, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = challenge.currentCount / challenge.targetCount;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: challenge.completed
              ? [Colors.green[700]!, Colors.green[500]!]
              : [Color(0xFF2D3561), Color(0xFF1A1F3A)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xFFFCAF45).withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('🎯', style: TextStyle(fontSize: 24)),
                SizedBox(width: 8),
                Text('Daily Challenge', style: TextStyle(color: Color(0xFFFCAF45), fontWeight: FontWeight.bold)),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFFCAF45),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('+${challenge.xpReward} XP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(challenge.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(challenge.description, style: TextStyle(color: Colors.white70)),
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(challenge.completed ? Colors.green : Color(0xFFFCAF45)),
                minHeight: 8,
              ),
            ),
            SizedBox(height: 4),
            Text('${challenge.currentCount}/${challenge.targetCount}', style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

// ==================== HOME PAGE ====================

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final GamificationService gamification = GamificationService();
  bool showDailyChallenge = true;

  @override
  void initState() {
    super.initState();
    gamification.initialize();
  }

  void pickImages() async {
    final input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.multiple = true;
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        List<String> dataUrls = [];
        int loaded = 0;
        for (var file in files) {
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoad.listen((_) {
            dataUrls.add(reader.result as String);
            loaded++;
            if (loaded == files.length) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditorPage(
                    imageUrls: dataUrls,
                    gamification: gamification,
                    onEditComplete: () => setState(() {}),
                  ),
                ),
              );
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF833AB4),
              Color(0xFFFD1D1D),
              Color(0xFFFCAF45),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Gamification
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(child: XPBarWidget(gamification: gamification)),
                    SizedBox(width: 12),
                    StreakWidget(streak: gamification.stats.currentStreak),
                  ],
                ),
              ),
              // Daily Challenge
              if (showDailyChallenge && gamification.dailyChallenge != null)
                DailyChallengeCard(
                  challenge: gamification.dailyChallenge!,
                  onTap: () => setState(() => showDailyChallenge = false),
                ),
              // Main Content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_rounded, size: 80, color: Colors.white),
                        SizedBox(height: 16),
                        Text(
                          'Instagram Photo Editor',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '24 Professional Filters • AI-Powered',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(height: 32),
                        _buildGlassCard(
                          icon: Icons.filter_vintage,
                          title: 'Pro Filters',
                          description: '24 Instagram-style filters',
                        ),
                        SizedBox(height: 16),
                        _buildGlassCard(
                          icon: Icons.tune,
                          title: 'Adjustments',
                          description: 'Brightness, Contrast, Saturation',
                        ),
                        SizedBox(height: 16),
                        _buildGlassCard(
                          icon: Icons.emoji_events,
                          title: 'Gamification',
                          description: 'Earn XP, unlock achievements!',
                        ),
                        SizedBox(height: 32),
                        _buildPickButton(),
                        SizedBox(height: 24),
                        Text(
                          '✨ Free • No Watermark • Unlimited Edits',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                    SizedBox(height: 4),
                    Text(description, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.2)],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: Offset(0, 10))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: pickImages,
          borderRadius: BorderRadius.circular(30),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_library, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Text('Pick Photos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== EDITOR PAGE ====================

class EditorPage extends StatefulWidget {
  final List<String> imageUrls;
  final GamificationService gamification;
  final VoidCallback onEditComplete;

  const EditorPage({
    Key? key,
    required this.imageUrls,
    required this.gamification,
    required this.onEditComplete,
  }) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  int currentIndex = 0;
  Map<int, String> selectedFilters = {};
  Map<int, double> brightness = {};
  Map<int, double> contrast = {};
  Map<int, double> saturation = {};
  Map<int, double> filterIntensity = {};
  int previousLevel = 1;

  final Map<String, ui.ColorFilter> filterMatrix = {
    'None': ui.ColorFilter.linearToSrgbGamma(),
    'Clarendon': ui.ColorFilter.srgbToLinearGamma(),
    'Gingham': ui.ColorFilter.mode(Colors.cyan.withOpacity(0.1), BlendMode.lighten),
    'Juno': ui.ColorFilter.mode(Colors.yellow.withOpacity(0.1), BlendMode.lighten),
    'Lark': ui.ColorFilter.mode(Colors.blue.withOpacity(0.1), BlendMode.lighten),
    'Ludwig': ui.ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.darken),
    'Nashville': ui.ColorFilter.mode(Colors.orange.withOpacity(0.15), BlendMode.lighten),
    'Perpetua': ui.ColorFilter.mode(Colors.pink.withOpacity(0.1), BlendMode.lighten),
    'Reyes': ui.ColorFilter.mode(Colors.yellow.withOpacity(0.05), BlendMode.lighten),
    'Slumber': ui.ColorFilter.mode(Colors.purple.withOpacity(0.1), BlendMode.lighten),
    'Toaster': ui.ColorFilter.mode(Colors.red.withOpacity(0.2), BlendMode.lighten),
    'Valencia': ui.ColorFilter.mode(Colors.amber.withOpacity(0.15), BlendMode.lighten),
    'Walden': ui.ColorFilter.mode(Colors.green.withOpacity(0.15), BlendMode.lighten),
    'Willow': ui.ColorFilter.mode(Colors.teal.withOpacity(0.15), BlendMode.lighten),
    'X-Pro II': ui.ColorFilter.mode(Colors.red.withOpacity(0.15), BlendMode.lighten),
    'Lo-Fi': ui.ColorFilter.mode(Colors.brown.withOpacity(0.15), BlendMode.lighten),
    'Hudson': ui.ColorFilter.mode(Colors.indigo.withOpacity(0.1), BlendMode.lighten),
    'Inkwell': ui.ColorFilter.mode(Colors.grey.withOpacity(0.5), BlendMode.saturation),
    'Amaro': ui.ColorFilter.mode(Colors.amber.withOpacity(0.1), BlendMode.lighten),
    'Rise': ui.ColorFilter.mode(Colors.yellow.withOpacity(0.08), BlendMode.lighten),
    'Hefe': ui.ColorFilter.mode(Colors.orange.withOpacity(0.1), BlendMode.lighten),
    'Sutro': ui.ColorFilter.mode(Colors.orange.withOpacity(0.12), BlendMode.lighten),
    'Brannan': ui.ColorFilter.mode(Colors.red.withOpacity(0.12), BlendMode.lighten),
    'Earlybird': ui.ColorFilter.mode(Colors.orange.withOpacity(0.15), BlendMode.lighten),
  };

  final List<String> filters = [
    'None', 'Clarendon', 'Gingham', 'Juno', 'Lark', 'Ludwig', 'Nashville', 'Perpetua',
    'Reyes', 'Slumber', 'Toaster', 'Valencia', 'Walden', 'Willow', 'X-Pro II', 'Lo-Fi',
    'Hudson', 'Inkwell', 'Amaro', 'Rise', 'Hefe', 'Sutro', 'Brannan', 'Earlybird'
  ];

  @override
  void initState() {
    super.initState();
    previousLevel = widget.gamification.stats.level;
    for (int i = 0; i < widget.imageUrls.length; i++) {
      selectedFilters[i] = 'None';
      filterIntensity[i] = 1.0;
      brightness[i] = 0.0;
      contrast[i] = 1.0;
      saturation[i] = 1.0;
    }
  }

  void selectFilter(String filter) {
    setState(() => selectedFilters[currentIndex] = filter);
    _recordEditAction();
  }

  void updateIntensity(double intensity) {
    setState(() => filterIntensity[currentIndex] = intensity);
  }

  void _recordEditAction() {
    final newAchievements = widget.gamification.recordEdit();
    final newLevel = widget.gamification.stats.level;
    
    // Check for level up
    if (newLevel > previousLevel) {
      previousLevel = newLevel;
      LevelUpAnimation.show(context, newLevel);
    }
    
    // Show achievement notifications
    for (final achievement in newAchievements) {
      AchievementNotification.show(context, achievement);
    }
    
    widget.onEditComplete();
  }

  void downloadImage() {
    final filter = selectedFilters[currentIndex] ?? 'None';
    final intensity = filterIntensity[currentIndex] ?? 1.0;
    final link = html.AnchorElement(href: widget.imageUrls[currentIndex])
      ..setAttribute('download', 'photo_${currentIndex + 1}_${filter}_${(intensity * 100).toStringAsFixed(0)}pct.jpg')
      ..click();
    _recordEditAction();
  }

  void showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1F3A), Color(0xFF0A0E27)],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🎨 Select Filter', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: filters.length,
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () {
                    selectFilter(filters[i]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedFilters[currentIndex] == filters[i]
                            ? Color(0xFFFCAF45)
                            : Colors.white24,
                        width: selectedFilters[currentIndex] == filters[i] ? 3 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      gradient: selectedFilters[currentIndex] == filters[i]
                          ? LinearGradient(colors: [Color(0xFF833AB4).withOpacity(0.3), Color(0xFFFD1D1D).withOpacity(0.3)])
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: ColorFiltered(
                              colorFilter: filterMatrix[filters[i]] ?? ui.ColorFilter.linearToSrgbGamma(),
                              child: Image.network(
                                widget.imageUrls[currentIndex],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[800],
                                  child: Icon(Icons.image, color: Colors.white54, size: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          filters[i],
                          style: TextStyle(fontSize: 10, color: selectedFilters[currentIndex] == filters[i] ? Color(0xFFFCAF45) : Colors.white70),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAdjustModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.55,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A1F3A), Color(0xFF0A0E27)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('⚙️ Adjustments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Brightness
                      _buildAdjustmentSlider(
                        icon: Icons.brightness_6,
                        label: 'Brightness',
                        value: brightness[currentIndex] ?? 0.0,
                        min: -100,
                        max: 100,
                        displayValue: '${(brightness[currentIndex] ?? 0).toStringAsFixed(0)}',
                        onChanged: (value) {
                          setState(() => brightness[currentIndex] = value);
                          setModalState(() {});
                        },
                      ),
                      SizedBox(height: 20),
                      // Contrast
                      _buildAdjustmentSlider(
                        icon: Icons.contrast,
                        label: 'Contrast',
                        value: contrast[currentIndex] ?? 1.0,
                        min: 0.5,
                        max: 2.0,
                        displayValue: '${((contrast[currentIndex] ?? 1.0) * 100).toStringAsFixed(0)}%',
                        onChanged: (value) {
                          setState(() => contrast[currentIndex] = value);
                          setModalState(() {});
                        },
                      ),
                      SizedBox(height: 20),
                      // Saturation
                      _buildAdjustmentSlider(
                        icon: Icons.color_lens,
                        label: 'Saturation',
                        value: saturation[currentIndex] ?? 1.0,
                        min: 0.0,
                        max: 2.0,
                        displayValue: '${((saturation[currentIndex] ?? 1.0) * 100).toStringAsFixed(0)}%',
                        onChanged: (value) {
                          setState(() => saturation[currentIndex] = value);
                          setModalState(() {});
                        },
                      ),
                      SizedBox(height: 32),
                      // Reset Button
                      Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              brightness[currentIndex] = 0.0;
                              contrast[currentIndex] = 1.0;
                              saturation[currentIndex] = 1.0;
                            });
                            setModalState(() {});
                            _recordEditAction();
                          },
                          icon: Icon(Icons.refresh),
                          label: Text('Reset All'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2D3561),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdjustmentSlider({
    required IconData icon,
    required String label,
    required double value,
    required double min,
    required double max,
    required String displayValue,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Color(0xFFFCAF45)),
            SizedBox(width: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF833AB4).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(displayValue, style: TextStyle(fontSize: 12, color: Color(0xFFFCAF45))),
            ),
          ],
        ),
        SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Color(0xFFFCAF45),
            inactiveTrackColor: Colors.white24,
            thumbColor: Color(0xFFFCAF45),
            overlayColor: Color(0xFFFCAF45).withOpacity(0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
            onChangeEnd: (_) => _recordEditAction(),
          ),
        ),
      ],
    );
  }

  // Build color matrix for adjustments
  ui.ColorFilter _buildAdjustmentFilter() {
    final b = (brightness[currentIndex] ?? 0.0) / 100;
    final c = contrast[currentIndex] ?? 1.0;
    final s = saturation[currentIndex] ?? 1.0;
    
    // Simplified brightness adjustment using color blend
    if (b > 0) {
      return ui.ColorFilter.mode(
        Colors.white.withOpacity(b.abs() * 0.3),
        BlendMode.lighten,
      );
    } else if (b < 0) {
      return ui.ColorFilter.mode(
        Colors.black.withOpacity(b.abs() * 0.3),
        BlendMode.darken,
      );
    }
    return ui.ColorFilter.linearToSrgbGamma();
  }

  @override
  Widget build(BuildContext context) {
    final currentFilter = selectedFilters[currentIndex] ?? 'None';
    final currentIntensity = filterIntensity[currentIndex] ?? 1.0;

    return Scaffold(
      backgroundColor: Color(0xFF0A0E27),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1F3A),
        elevation: 0,
        title: Row(
          children: [
            Text('Edit Photo ${currentIndex + 1}/${widget.imageUrls.length}'),
            Spacer(),
            XPBarWidget(gamification: widget.gamification),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Image Preview
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Color(0xFF833AB4).withOpacity(0.3), blurRadius: 20),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Base image with filter
                    Opacity(
                      opacity: currentIntensity,
                      child: ColorFiltered(
                        colorFilter: filterMatrix[currentFilter] ?? ui.ColorFilter.linearToSrgbGamma(),
                        child: ColorFiltered(
                          colorFilter: _buildAdjustmentFilter(),
                          child: Image.network(
                            widget.imageUrls[currentIndex],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    // Filter name overlay
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          currentFilter,
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Intensity Slider
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.opacity, size: 20, color: Color(0xFFFCAF45)),
                SizedBox(width: 8),
                Text('Intensity', style: TextStyle(fontSize: 14)),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Color(0xFFFCAF45),
                      inactiveTrackColor: Colors.white24,
                      thumbColor: Color(0xFFFCAF45),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: currentIntensity,
                      min: 0.0,
                      max: 1.0,
                      onChanged: updateIntensity,
                    ),
                  ),
                ),
                Text('${(currentIntensity * 100).toStringAsFixed(0)}%', style: TextStyle(color: Color(0xFFFCAF45))),
              ],
            ),
          ),
          // Action Buttons
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A1F3A), Color(0xFF0A0E27)],
              ),
            ),
            child: Column(
              children: [
                // Main action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.filter_vintage,
                      label: 'Filters',
                      color: Color(0xFFFCAF45),
                      onTap: showFilterModal,
                    ),
                    _buildActionButton(
                      icon: Icons.tune,
                      label: 'Adjust',
                      color: Color(0xFF833AB4),
                      onTap: showAdjustModal,
                    ),
                    _buildActionButton(
                      icon: Icons.download,
                      label: 'Save',
                      color: Color(0xFF4CAF50),
                      onTap: downloadImage,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.imageUrls.length > 1) ...[
                      IconButton(
                        onPressed: currentIndex > 0 ? () => setState(() => currentIndex--) : null,
                        icon: Icon(Icons.chevron_left, size: 32),
                        color: currentIndex > 0 ? Colors.white : Colors.white30,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3561),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${currentIndex + 1} / ${widget.imageUrls.length}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: currentIndex < widget.imageUrls.length - 1
                            ? () => setState(() => currentIndex++)
                            : null,
                        icon: Icon(Icons.chevron_right, size: 32),
                        color: currentIndex < widget.imageUrls.length - 1 ? Colors.white : Colors.white30,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
