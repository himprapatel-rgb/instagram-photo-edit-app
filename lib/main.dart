import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:math' as math;
// v0.7.0 - Crop & Resize, Undo/Redo System, Enhanced Features

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

// ==================== EDIT HISTORY FOR UNDO/REDO ====================
class EditState {
  final double brightness;
  final double contrast;
  final double saturation;
  final double warmth;
  final double vignette;
  final double grain;
  final double sharpness;
  final String? activeFilter;
  final Rect? cropRect;
  
  EditState({
    this.brightness = 0.0,
    this.contrast = 0.0,
    this.saturation = 0.0,
    this.warmth = 0.0,
    this.vignette = 0.0,
    this.grain = 0.0,
    this.sharpness = 0.0,
    this.activeFilter,
    this.cropRect,
  });
  
  EditState copyWith({
    double? brightness,
    double? contrast,
    double? saturation,
    double? warmth,
    double? vignette,
    double? grain,
    double? sharpness,
    String? activeFilter,
    Rect? cropRect,
  }) {
    return EditState(
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      saturation: saturation ?? this.saturation,
      warmth: warmth ?? this.warmth,
      vignette: vignette ?? this.vignette,
      grain: grain ?? this.grain,
      sharpness: sharpness ?? this.sharpness,
      activeFilter: activeFilter ?? this.activeFilter,
      cropRect: cropRect ?? this.cropRect,
    );
  }
}

class EditHistory {
  final List<EditState> _undoStack = [];
  final List<EditState> _redoStack = [];
  EditState _currentState = EditState();
  
  EditState get current => _currentState;
  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;
  
  void pushState(EditState state) {
    _undoStack.add(_currentState);
    _currentState = state;
    _redoStack.clear();
  }
  
  EditState? undo() {
    if (_undoStack.isEmpty) return null;
    _redoStack.add(_currentState);
    _currentState = _undoStack.removeLast();
    return _currentState;
  }
  
  EditState? redo() {
    if (_redoStack.isEmpty) return null;
    _undoStack.add(_currentState);
    _currentState = _redoStack.removeLast();
    return _currentState;
  }
  
  void reset() {
    _undoStack.clear();
    _redoStack.clear();
    _currentState = EditState();
  }
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
  List<String> completedChallenges;

  UserStats({
    this.totalEdits = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalXP = 0,
    this.level = 1,
    this.lastEditDate,
    List<String>? unlockedAchievements,
    List<String>? completedChallenges,
  }) : unlockedAchievements = unlockedAchievements ?? [],
       completedChallenges = completedChallenges ?? [];

  int get xpForNextLevel => level * 100;
  double get levelProgress => (totalXP % (level * 100)) / (level * 100);
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int xpReward;
  final bool Function(UserStats) condition;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.condition,
  });
}

class DailyChallenge {
  final String id;
  final String title;
  final String description;
  final int targetCount;
  final int currentProgress;
  final int xpReward;
  final DateTime expiresAt;

  DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.targetCount,
    this.currentProgress = 0,
    required this.xpReward,
    required this.expiresAt,
  });

  bool get isCompleted => currentProgress >= targetCount;
  double get progress => currentProgress / targetCount;
}

// ==================== GAMIFICATION SERVICE ====================
class GamificationService {
  static final GamificationService _instance = GamificationService._internal();
  factory GamificationService() => _instance;
  GamificationService._internal();

  UserStats _stats = UserStats();
  UserStats get stats => _stats;

  final List<Achievement> achievements = [
    Achievement(
      id: 'first_edit',
      name: 'First Steps',
      description: 'Complete your first edit',
      icon: '🎨',
      xpReward: 50,
      condition: (stats) => stats.totalEdits >= 1,
    ),
    Achievement(
      id: 'edit_master',
      name: 'Edit Master',
      description: 'Complete 50 edits',
      icon: '🏆',
      xpReward: 200,
      condition: (stats) => stats.totalEdits >= 50,
    ),
    Achievement(
      id: 'streak_warrior',
      name: 'Streak Warrior',
      description: 'Maintain a 7-day streak',
      icon: '🔥',
      xpReward: 150,
      condition: (stats) => stats.currentStreak >= 7,
    ),
    Achievement(
      id: 'level_up',
      name: 'Rising Star',
      description: 'Reach level 5',
      icon: '⭐',
      xpReward: 100,
      condition: (stats) => stats.level >= 5,
    ),
  ];

  DailyChallenge? _currentChallenge;
  DailyChallenge? get currentChallenge => _currentChallenge;

  void initialize() {
    _generateDailyChallenge();
  }

  void _generateDailyChallenge() {
    final challenges = [
      {'title': 'Filter Explorer', 'desc': 'Apply 3 different filters', 'target': 3, 'xp': 75},
      {'title': 'Edit Enthusiast', 'desc': 'Complete 5 edits today', 'target': 5, 'xp': 100},
      {'title': 'Quick Editor', 'desc': 'Edit and save 2 photos', 'target': 2, 'xp': 50},
    ];
    final random = math.Random();
    final challenge = challenges[random.nextInt(challenges.length)];
    _currentChallenge = DailyChallenge(
      id: 'daily_${DateTime.now().day}',
      title: challenge['title'] as String,
      description: challenge['desc'] as String,
      targetCount: challenge['target'] as int,
      xpReward: challenge['xp'] as int,
      expiresAt: DateTime.now().add(Duration(hours: 24)),
    );
  }

  void recordEdit() {
    _stats.totalEdits++;
    _addXP(10);
    _updateStreak();
    _checkAchievements();
  }

  void _addXP(int amount) {
    _stats.totalXP += amount;
    while (_stats.totalXP >= _stats.xpForNextLevel) {
      _stats.totalXP -= _stats.xpForNextLevel;
      _stats.level++;
    }
  }

  void _updateStreak() {
    final now = DateTime.now();
    if (_stats.lastEditDate != null) {
      final diff = now.difference(_stats.lastEditDate!).inDays;
      if (diff == 1) {
        _stats.currentStreak++;
      } else if (diff > 1) {
        _stats.currentStreak = 1;
      }
    } else {
      _stats.currentStreak = 1;
    }
    if (_stats.currentStreak > _stats.longestStreak) {
      _stats.longestStreak = _stats.currentStreak;
    }
    _stats.lastEditDate = now;
  }

  void _checkAchievements() {
    for (final achievement in achievements) {
      if (!_stats.unlockedAchievements.contains(achievement.id) &&
          achievement.condition(_stats)) {
        _stats.unlockedAchievements.add(achievement.id);
        _addXP(achievement.xpReward);
      }
    }
  }
}

// ==================== CROP OVERLAY WIDGET ====================
class CropOverlayWidget extends StatefulWidget {
  final double imageWidth;
  final double imageHeight;
  final Function(Rect) onCropChanged;
  final Rect? initialCrop;

  const CropOverlayWidget({
    Key? key,
    required this.imageWidth,
    required this.imageHeight,
    required this.onCropChanged,
    this.initialCrop,
  }) : super(key: key);

  @override
  _CropOverlayWidgetState createState() => _CropOverlayWidgetState();
}

class _CropOverlayWidgetState extends State<CropOverlayWidget> {
  late Rect cropRect;
  String aspectRatio = 'free';
  bool isDragging = false;
  String? activeHandle;
  Offset? dragStart;

  @override
  void initState() {
    super.initState();
    cropRect = widget.initialCrop ?? Rect.fromLTWH(
      widget.imageWidth * 0.1,
      widget.imageHeight * 0.1,
      widget.imageWidth * 0.8,
      widget.imageHeight * 0.8,
    );
  }

  void _setAspectRatio(String ratio) {
    setState(() {
      aspectRatio = ratio;
      final center = cropRect.center;
      double newWidth, newHeight;
      
      switch (ratio) {
        case '1:1':
          newWidth = newHeight = math.min(cropRect.width, cropRect.height);
          break;
        case '4:3':
          newWidth = cropRect.width;
          newHeight = newWidth * 3 / 4;
          break;
        case '16:9':
          newWidth = cropRect.width;
          newHeight = newWidth * 9 / 16;
          break;
        case '9:16':
          newHeight = cropRect.height;
          newWidth = newHeight * 9 / 16;
          break;
        default:
          return;
      }
      
      cropRect = Rect.fromCenter(
        center: center,
        width: newWidth.clamp(50, widget.imageWidth),
        height: newHeight.clamp(50, widget.imageHeight),
      );
      widget.onCropChanged(cropRect);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Aspect ratio buttons
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRatioButton('Free', 'free'),
              _buildRatioButton('1:1', '1:1'),
              _buildRatioButton('4:3', '4:3'),
              _buildRatioButton('16:9', '16:9'),
              _buildRatioButton('9:16', '9:16'),
            ],
          ),
        ),
        SizedBox(height: 16),
        // Crop area
        Expanded(
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: (_) => setState(() => isDragging = false),
            child: CustomPaint(
              painter: CropPainter(cropRect: cropRect, imageSize: Size(widget.imageWidth, widget.imageHeight)),
              size: Size(widget.imageWidth, widget.imageHeight),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatioButton(String label, String ratio) {
    final isSelected = aspectRatio == ratio;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => _setAspectRatio(ratio),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF833AB4) : Colors.grey[800],
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(label, style: TextStyle(fontSize: 12)),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.localPosition;
    isDragging = true;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!isDragging) return;
    setState(() {
      final delta = details.delta;
      cropRect = cropRect.translate(delta.dx, delta.dy);
      // Clamp to image bounds
      cropRect = Rect.fromLTWH(
        cropRect.left.clamp(0, widget.imageWidth - cropRect.width),
        cropRect.top.clamp(0, widget.imageHeight - cropRect.height),
        cropRect.width,
        cropRect.height,
      );
      widget.onCropChanged(cropRect);
    });
  }
}

class CropPainter extends CustomPainter {
  final Rect cropRect;
  final Size imageSize;

  CropPainter({required this.cropRect, required this.imageSize});

  @override
  void paint(Canvas canvas, Size size) {
    // Dim areas outside crop
    final dimPaint = Paint()..color = Colors.black.withOpacity(0.6);
    
    // Top
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, cropRect.top), dimPaint);
    // Bottom
    canvas.drawRect(Rect.fromLTWH(0, cropRect.bottom, size.width, size.height - cropRect.bottom), dimPaint);
    // Left
    canvas.drawRect(Rect.fromLTWH(0, cropRect.top, cropRect.left, cropRect.height), dimPaint);
    // Right
    canvas.drawRect(Rect.fromLTWH(cropRect.right, cropRect.top, size.width - cropRect.right, cropRect.height), dimPaint);
    
    // Crop border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(cropRect, borderPaint);
    
    // Grid lines (rule of thirds)
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 0.5;
    
    final thirdWidth = cropRect.width / 3;
    final thirdHeight = cropRect.height / 3;
    
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(cropRect.left + thirdWidth * i, cropRect.top),
        Offset(cropRect.left + thirdWidth * i, cropRect.bottom),
        gridPaint,
      );
      canvas.drawLine(
        Offset(cropRect.left, cropRect.top + thirdHeight * i),
        Offset(cropRect.right, cropRect.top + thirdHeight * i),
        gridPaint,
      );
    }
    
    // Corner handles
    final handlePaint = Paint()..color = Colors.white;
    final handleSize = 12.0;
    final corners = [
      cropRect.topLeft,
      cropRect.topRight,
      cropRect.bottomLeft,
      cropRect.bottomRight,
    ];
    
    for (final corner in corners) {
      canvas.drawCircle(corner, handleSize / 2, handlePaint);
    }
  }

  @override
  bool shouldRepaint(CropPainter oldDelegate) => cropRect != oldDelegate.cropRect;
}

// ==================== BEFORE/AFTER COMPARISON WIDGET ====================
class BeforeAfterWidget extends StatefulWidget {
  final String originalImageUrl;
  final String editedImageUrl;
  final String filterCSS;

  const BeforeAfterWidget({
    Key? key,
    required this.originalImageUrl,
    required this.editedImageUrl,
    required this.filterCSS,
  }) : super(key: key);

  @override
  _BeforeAfterWidgetState createState() => _BeforeAfterWidgetState();
}

class _BeforeAfterWidgetState extends State<BeforeAfterWidget> {
  double sliderPosition = 0.5;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              sliderPosition = (details.localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0);
            });
          },
          child: Stack(
            children: [
              // Edited image (full)
              Positioned.fill(
                child: HtmlElementView(
                  viewType: 'edited-compare-${widget.editedImageUrl.hashCode}',
                ),
              ),
              // Original image (clipped)
              ClipRect(
                clipper: _HorizontalClipper(sliderPosition),
                child: HtmlElementView(
                  viewType: 'original-compare-${widget.originalImageUrl.hashCode}',
                ),
              ),
              // Slider line
              Positioned(
                left: constraints.maxWidth * sliderPosition - 2,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  color: Colors.white,
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                      child: Icon(Icons.compare_arrows, color: Colors.black),
                    ),
                  ),
                ),
              ),
              // Labels
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('Original', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('Edited', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HorizontalClipper extends CustomClipper<Rect> {
  final double position;
  _HorizontalClipper(this.position);

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * position, size.height);

  @override
  bool shouldReclip(_HorizontalClipper oldClipper) => position != oldClipper.position;
}

// ==================== GAMIFICATION WIDGETS ====================
class XPBarWidget extends StatelessWidget {
  final UserStats stats;
  
  const XPBarWidget({Key? key, required this.stats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF833AB4), Color(0xFFFD1D1D)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Level ${stats.level}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('${stats.totalXP} / ${stats.xpForNextLevel} XP', style: TextStyle(fontSize: 12)),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: stats.levelProgress,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation(Colors.white),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class StreakWidget extends StatelessWidget {
  final int streak;
  
  const StreakWidget({Key? key, required this.streak}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: streak > 0 ? Colors.orange : Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🔥', style: TextStyle(fontSize: 20)),
          SizedBox(width: 8),
          Text('$streak day${streak != 1 ? 's' : ''}', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class AchievementNotification extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback onDismiss;

  const AchievementNotification({
    Key? key,
    required this.achievement,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFF77737)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
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
                  Text('Achievement Unlocked!', style: TextStyle(fontSize: 12, color: Colors.white70)),
                  Text(achievement.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('+${achievement.xpReward} XP', style: TextStyle(color: Colors.greenAccent)),
                ],
              ),
            ),
            IconButton(icon: Icon(Icons.close), onPressed: onDismiss),
          ],
        ),
      ),
    );
  }
}

class DailyChallengeCard extends StatelessWidget {
  final DailyChallenge challenge;

  const DailyChallengeCard({Key? key, required this.challenge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: challenge.isCompleted ? Colors.greenAccent : Colors.grey[700]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(challenge.isCompleted ? Icons.check_circle : Icons.flag, 
                   color: challenge.isCompleted ? Colors.greenAccent : Color(0xFF833AB4)),
              SizedBox(width: 8),
              Text('Daily Challenge', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF833AB4))),
              Spacer(),
              Text('+${challenge.xpReward} XP', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Text(challenge.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(challenge.description, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: challenge.progress,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation(challenge.isCompleted ? Colors.greenAccent : Color(0xFF833AB4)),
            ),
          ),
          SizedBox(height: 4),
          Text('${challenge.currentProgress}/${challenge.targetCount}', 
               style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

class LevelUpAnimation extends StatefulWidget {
  final int newLevel;
  final VoidCallback onComplete;

  const LevelUpAnimation({Key? key, required this.newLevel, required this.onComplete}) : super(key: key);

  @override
  _LevelUpAnimationState createState() => _LevelUpAnimationState();
}

class _LevelUpAnimationState extends State<LevelUpAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 1500), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward().then((_) {
      Future.delayed(Duration(seconds: 1), widget.onComplete);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF833AB4), Color(0xFFFD1D1D)],
              ),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Color(0xFF833AB4).withOpacity(0.5), blurRadius: 30, spreadRadius: 10)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('⭐', style: TextStyle(fontSize: 60)),
                Text('LEVEL UP!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Level ${widget.newLevel}', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==================== FILTER DATA ====================
class FilterPreset {
  final String name;
  final String cssFilter;
  final bool isPremium;

  const FilterPreset({required this.name, required this.cssFilter, this.isPremium = false});
}

final List<FilterPreset> instagramFilters = [
  FilterPreset(name: 'Original', cssFilter: 'none'),
  FilterPreset(name: 'Clarendon', cssFilter: 'contrast(1.2) saturate(1.35)'),
  FilterPreset(name: 'Gingham', cssFilter: 'brightness(1.05) hue-rotate(-10deg)'),
  FilterPreset(name: 'Moon', cssFilter: 'grayscale(1) contrast(1.1) brightness(1.1)'),
  FilterPreset(name: 'Lark', cssFilter: 'contrast(0.9) brightness(1.1) saturate(1.25)'),
  FilterPreset(name: 'Reyes', cssFilter: 'sepia(0.22) brightness(1.1) contrast(0.85) saturate(0.75)'),
  FilterPreset(name: 'Juno', cssFilter: 'contrast(1.15) saturate(1.8) sepia(0.1)'),
  FilterPreset(name: 'Slumber', cssFilter: 'saturate(0.66) brightness(1.05) sepia(0.05)'),
  FilterPreset(name: 'Crema', cssFilter: 'sepia(0.15) saturate(1.1) contrast(0.9)'),
  FilterPreset(name: 'Ludwig', cssFilter: 'contrast(1.05) saturate(0.9) brightness(1.05)'),
  FilterPreset(name: 'Aden', cssFilter: 'hue-rotate(-20deg) contrast(0.9) saturate(0.85) brightness(1.2)'),
  FilterPreset(name: 'Perpetua', cssFilter: 'contrast(1.1) brightness(1.15) saturate(1.1)'),
  FilterPreset(name: 'Amaro', cssFilter: 'hue-rotate(-10deg) contrast(0.9) brightness(1.1) saturate(1.5)', isPremium: true),
  FilterPreset(name: 'Mayfair', cssFilter: 'contrast(1.1) saturate(1.1) sepia(0.1)', isPremium: true),
  FilterPreset(name: 'Rise', cssFilter: 'brightness(1.05) sepia(0.08) contrast(0.9) saturate(0.9)', isPremium: true),
  FilterPreset(name: 'Hudson', cssFilter: 'brightness(1.2) contrast(0.9) saturate(1.1)', isPremium: true),
  FilterPreset(name: 'Valencia', cssFilter: 'sepia(0.15) saturate(1.5) contrast(1.1)', isPremium: true),
  FilterPreset(name: 'X-Pro II', cssFilter: 'contrast(1.3) saturate(1.3) sepia(0.15)', isPremium: true),
  FilterPreset(name: 'Sierra', cssFilter: 'contrast(0.85) saturate(0.75) sepia(0.2)', isPremium: true),
  FilterPreset(name: 'Willow', cssFilter: 'grayscale(0.5) contrast(0.95) brightness(1.05)', isPremium: true),
  FilterPreset(name: 'Lo-Fi', cssFilter: 'contrast(1.5) saturate(1.1)', isPremium: true),
  FilterPreset(name: 'Inkwell', cssFilter: 'grayscale(1) contrast(1.1) brightness(1.1) sepia(0.3)', isPremium: true),
  FilterPreset(name: 'Nashville', cssFilter: 'sepia(0.25) contrast(1.2) brightness(1.05) saturate(1.2)', isPremium: true),
];

// ==================== HOME PAGE ====================
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GamificationService _gamification = GamificationService();
  List<String> _imageUrls = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _gamification.initialize();
  }

  void _pickImages() {
    final input = html.FileUploadInputElement()..accept = 'image/*'..multiple = true;
    input.click();
    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        setState(() => _isLoading = true);
        _imageUrls.clear();
        for (final file in files) {
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoadEnd.listen((e) {
            setState(() {
              _imageUrls.add(reader.result as String);
              _isLoading = false;
            });
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
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f0f23)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildGamificationSection(),
              Expanded(child: _buildMainContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFF77737)],
            ).createShader(bounds),
            child: Text(
              'InstaEdit Pro',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Spacer(),
          StreakWidget(streak: _gamification.stats.currentStreak),
        ],
      ),
    );
  }

  Widget _buildGamificationSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          XPBarWidget(stats: _gamification.stats),
          SizedBox(height: 12),
          if (_gamification.currentChallenge != null)
            DailyChallengeCard(challenge: _gamification.currentChallenge!),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF833AB4)),
            SizedBox(height: 16),
            Text('Loading images...', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    if (_imageUrls.isEmpty) {
      return _buildUploadSection();
    }

    return _buildImageGrid();
  }

  Widget _buildUploadSection() {
    return Center(
      child: GestureDetector(
        onTap: _pickImages,
        child: Container(
          margin: EdgeInsets.all(32),
          padding: EdgeInsets.all(48),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Color(0xFF833AB4), width: 2),
            gradient: LinearGradient(
              colors: [Color(0xFF833AB4).withOpacity(0.1), Color(0xFFFD1D1D).withOpacity(0.1)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_photo_alternate, size: 80, color: Color(0xFF833AB4)),
              SizedBox(height: 16),
              Text('Tap to Select Photos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Support for multiple images', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${_imageUrls.length} image(s) selected', style: TextStyle(color: Colors.grey)),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _pickImages,
                    icon: Icon(Icons.add, color: Color(0xFF833AB4)),
                    label: Text('Add More', style: TextStyle(color: Color(0xFF833AB4))),
                  ),
                  SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => setState(() => _imageUrls.clear()),
                    icon: Icon(Icons.clear_all, color: Colors.red),
                    label: Text('Clear All', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _imageUrls.length,
            itemBuilder: (context, index) => _buildImageTile(index),
          ),
        ),
      ],
    );
  }

  Widget _buildImageTile(int index) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditorPage(
            imageUrl: _imageUrls[index],
            allImageUrls: _imageUrls,
            currentIndex: index,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(_imageUrls[index], fit: BoxFit.cover),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16, color: Colors.white70),
                      SizedBox(width: 4),
                      Text('Tap to edit', style: TextStyle(fontSize: 12, color: Colors.white70)),
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
}

// ==================== EDITOR PAGE ====================
class EditorPage extends StatefulWidget {
  final String imageUrl;
  final List<String> allImageUrls;
  final int currentIndex;

  const EditorPage({
    Key? key,
    required this.imageUrl,
    required this.allImageUrls,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  late EditHistory _editHistory;
  double _brightness = 0.0;
  double _contrast = 0.0;
  double _saturation = 0.0;
  double _warmth = 0.0;
  double _vignette = 0.0;
  double _grain = 0.0;
  double _sharpness = 0.0;
  String? _activeFilter;
  String _editorMode = 'adjust'; // 'adjust', 'crop', 'compare', 'filter'
  bool _showBeforeAfter = false;
  Rect? _cropRect;
  final GamificationService _gamification = GamificationService();

  @override
  void initState() {
    super.initState();
    _editHistory = EditHistory();
  }

  String _buildFilterCSS() {
    List<String> filters = [];
    if (_brightness != 0) filters.add('brightness(${(1 + _brightness * 0.5).toStringAsFixed(2)})');
    if (_contrast != 0) filters.add('contrast(${(1 + _contrast * 0.5).toStringAsFixed(2)})');
    if (_saturation != 0) filters.add('saturate(${(1 + _saturation * 0.5).toStringAsFixed(2)})');
    if (_warmth != 0) filters.add('sepia(${(_warmth * 0.3).abs().toStringAsFixed(2)})');
    if (_vignette != 0) filters.add('drop-shadow(0 0 ${(_vignette * 20).toStringAsFixed(0)}px rgba(0,0,0,0.5))');
    if (_grain != 0) filters.add('contrast(${(1 + _grain * 0.2).toStringAsFixed(2)})');
    if (_sharpness != 0) filters.add('contrast(${(1 + _sharpness * 0.3).toStringAsFixed(2)})');
    if (_activeFilter != null && _activeFilter != 'Original') {
      final filter = instagramFilters.firstWhere((f) => f.name == _activeFilter, orElse: () => instagramFilters[0]);
      return filter.cssFilter;
    }
    return filters.isEmpty ? 'none' : filters.join(' ');
  }

  void _applyFilter(String filterName) {
    setState(() {
      _activeFilter = filterName;
      if (filterName == 'Original') {
        _brightness = _contrast = _saturation = _warmth = _vignette = _grain = _sharpness = 0.0;
      }
      _editHistory.pushState(EditState(
        brightness: _brightness,
        contrast: _contrast,
        saturation: _saturation,
        warmth: _warmth,
        vignette: _vignette,
        grain: _grain,
        sharpness: _sharpness,
        activeFilter: _activeFilter,
        cropRect: _cropRect,
      ));
    });
  }

  void _undo() {
    final state = _editHistory.undo();
    if (state != null) {
      setState(() {
        _brightness = state.brightness;
        _contrast = state.contrast;
        _saturation = state.saturation;
        _warmth = state.warmth;
        _vignette = state.vignette;
        _grain = state.grain;
        _sharpness = state.sharpness;
        _activeFilter = state.activeFilter;
        _cropRect = state.cropRect;
      });
    }
  }

  void _redo() {
    final state = _editHistory.redo();
    if (state != null) {
      setState(() {
        _brightness = state.brightness;
        _contrast = state.contrast;
        _saturation = state.saturation;
        _warmth = state.warmth;
        _vignette = state.vignette;
        _grain = state.grain;
        _sharpness = state.sharpness;
        _activeFilter = state.activeFilter;
        _cropRect = state.cropRect;
      });
    }
  }

  void _recordEdit() {
    _gamification.recordEdit();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit recorded! +10 XP'), duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
            ),
          ),
          child: Column(
            children: [
              _buildToolbar(),
              Expanded(child: _buildEditorContent()),
              _buildControlPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[800]!, width: 1)),
        color: Colors.black26,
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          Spacer(),
          Row(
            children: [
              if (_editHistory.canUndo)
                IconButton(
                  icon: Icon(Icons.undo),
                  color: Colors.white70,
                  onPressed: _undo,
                ),
              if (_editHistory.canRedo)
                IconButton(
                  icon: Icon(Icons.redo),
                  color: Colors.white70,
                  onPressed: _redo,
                ),
              IconButton(
                icon: Icon(Icons.download),
                onPressed: _recordEdit,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditorContent() {
    final filterCSS = _buildFilterCSS();
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _editorMode == 'crop' 
            ? CropOverlayWidget(
                imageWidth: 500,
                imageHeight: 500,
                onCropChanged: (rect) => setState(() => _cropRect = rect),
                initialCrop: _cropRect,
              )
            : HtmlElementView(
                viewType: 'image-editor-${widget.imageUrl.hashCode}',
              ),
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[800]!, width: 1)),
        color: Colors.black26,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModeSelector(),
          _buildAdjustmentControls(),
          _buildFilterCarousel(),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildModeButton('Adjust', 'adjust'),
            _buildModeButton('Crop', 'crop'),
            _buildModeButton('Filters', 'filter'),
            _buildModeButton('Compare', 'compare'),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(String label, String mode) {
    final isActive = _editorMode == mode;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: () => setState(() => _editorMode = mode),
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? Color(0xFF833AB4) : Colors.grey[800],
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildAdjustmentControls() {
    if (_editorMode != 'adjust') return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          _buildSlider('Brightness', _brightness, (v) => setState(() => _brightness = v)),
          _buildSlider('Contrast', _contrast, (v) => setState(() => _contrast = v)),
          _buildSlider('Saturation', _saturation, (v) => setState(() => _saturation = v)),
          _buildSlider('Warmth', _warmth, (v) => setState(() => _warmth = v)),
          _buildSlider('Vignette', _vignette, (v) => setState(() => _vignette = v)),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
        Slider(
          value: value,
          min: -1.0,
          max: 1.0,
          activeColor: Color(0xFF833AB4),
          inactiveColor: Colors.grey[800],
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildFilterCarousel() {
    if (_editorMode != 'filter') return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: instagramFilters.map((filter) {
            final isActive = _activeFilter == filter.name;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => _applyFilter(filter.name),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isActive ? Color(0xFF833AB4) : Colors.grey[800],
                    border: isActive ? Border.all(color: Color(0xFFFD1D1D), width: 2) : null,
                  ),
                  child: Text(
                    filter.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
