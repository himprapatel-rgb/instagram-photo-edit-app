import 'package:flutter/material.dart';
import '../services/ai_filter_service.dart';

/// AI Filter Panel Widget
/// Displays AI-powered filter options in a horizontal scrollable list
/// with premium badges and one-tap enhancement buttons
class AIFilterPanel extends StatefulWidget {
  final Function(AIFilterType) onFilterSelected;
  final AIFilterType? selectedFilter;
  final bool isProcessing;
  final VoidCallback? onAutoEnhance;

  const AIFilterPanel({
    super.key,
    required this.onFilterSelected,
    this.selectedFilter,
    this.isProcessing = false,
    this.onAutoEnhance,
  });

  @override
  State<AIFilterPanel> createState() => _AIFilterPanelState();
}

class _AIFilterPanelState extends State<AIFilterPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aiFilters = AIFilterService.getAllAIFilters();

    return Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.0),
            Colors.black.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildAIBadge(),
                const SizedBox(width: 8),
                const Text(
                  'AI Filters',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Quick Auto-Enhance Button
                _buildAutoEnhanceButton(),
              ],
            ),
          ),

          // AI Filter List
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: aiFilters.length,
              itemBuilder: (context, index) {
                final filter = aiFilters[index];
                return _buildAIFilterCard(filter);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, color: Colors.white, size: 12),
          SizedBox(width: 4),
          Text(
            'AI',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoEnhanceButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isProcessing ? 1.0 : _pulseAnimation.value,
          child: GestureDetector(
            onTap: widget.isProcessing ? null : widget.onAutoEnhance,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isProcessing
                      ? [Colors.grey, Colors.grey.shade700]
                      : [const Color(0xFF10B981), const Color(0xFF059669)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: widget.isProcessing
                    ? null
                    : [
                        BoxShadow(
                          color: const Color(0xFF10B981).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.isProcessing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.auto_fix_high,
                          color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    widget.isProcessing ? 'Enhancing...' : 'Auto-Enhance',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAIFilterCard(AIFilterPreset filter) {
    final isSelected = widget.selectedFilter == filter.type;

    return GestureDetector(
      onTap: () => widget.onFilterSelected(filter.type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        width: 70,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF7C3AED)
                : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Filter Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with gradient background
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected
                          ? [const Color(0xFF7C3AED), const Color(0xFFEC4899)]
                          : [Colors.grey.shade700, Colors.grey.shade800],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    filter.icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 6),
                // Filter Name
                Text(
                  filter.name.replaceAll('AI ', ''),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            // Premium Badge
            if (filter.isPremium)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Compact AI Filter Button for toolbar
class AIFilterButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isActive;

  const AIFilterButton({
    super.key,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                )
              : null,
          color: isActive ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              color: isActive ? Colors.white : Colors.white70,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'AI',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
