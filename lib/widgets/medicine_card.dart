// lib/widgets/medicine_card.dart
import 'package:flutter/material.dart';

import 'package:flutter_locales/flutter_locales.dart';
import '../models/medicine.dart';
import '../services/tts_service.dart';
import '../providers/theme_provider.dart';
import 'package:provider/provider.dart';

class MedicineCard extends StatefulWidget {
  final Medicine medicine;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const MedicineCard({
    super.key,
    required this.medicine,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  _MedicineCardState createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard>
    with SingleTickerProviderStateMixin {
  final TTSService _ttsService = TTSService();
  bool _isSpeaking = false;
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _isSpeaking = _ttsService.isSpeaking();
    _ttsService.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightFactor = _controller.drive(CurveTween(curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _ttsService.dispose();
    super.dispose();
  }

  Future<void> _speakMedicineInfo() async {
    if (!_isSpeaking) {
      setState(() {
        _isSpeaking = true;
      });
      await _ttsService.speak(widget.medicine.name);
    } else {
      await _ttsService.stop();
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    }
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    bool isDarkMode = themeProvider.isDarkMode;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? Color.fromARGB(255, 12, 23, 33) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleExpand,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              // Main Content
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Left side - Icon
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? _getTypeColor(
                                  widget.medicine.typeName,
                                ).withOpacity(0.1)
                                : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getMedicineIcon(widget.medicine.typeName),
                        color:
                            isDarkMode
                                ? Colors.white
                                : _getTypeColor(widget.medicine.typeName),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    // Center - Medicine Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.medicine.name,
                            style: TextStyle(
                              fontFamily: "Drug",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            widget.medicine.typeName,
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: "Drug",
                              color:
                                  isDarkMode
                                      ? Colors.white
                                      : _getTypeColor(widget.medicine.typeName),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right side - Actions
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildActionButton(
                          icon: _isSpeaking ? Icons.stop : Icons.volume_up,
                          color:
                              isDarkMode
                                  ? Colors.white
                                  : _getTypeColor(widget.medicine.typeName),
                          onPressed: _speakMedicineInfo,
                        ),
                        SizedBox(width: 8),
                        _buildActionButton(
                          icon:
                              widget.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                          color:
                              isDarkMode
                                  ? Colors.white
                                  : widget.isFavorite
                                  ? Colors.red
                                  : Colors.grey,
                          onPressed: widget.onToggleFavorite,
                        ),
                        SizedBox(width: 8),
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: Duration(milliseconds: 300),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: isDarkMode ? Colors.white : Colors.black,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Expandable Content
              ClipRect(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Align(
                      alignment: Alignment.topCenter,
                      heightFactor: _heightFactor.value,
                      child: child,
                    );
                  },
                  child: _isExpanded ? _buildExpandableContent() : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
      ),
    );
  }

  Widget _buildExpandableContent() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.grey.shade200),
          _buildInfoItem(
            'other_names',
            widget.medicine.otherNames,
            Icons.label_outline,
          ),
          _buildInfoItem(
            'description',
            _getDescriptionForCurrentLocale(),
            Icons.description_outlined,
          ),
          _buildInfoItem(
            'uses',
            _getUsesForCurrentLocale(),
            Icons.medical_services_outlined,
          ),
          _buildInfoItem(
            'dosage',
            _getDosageForCurrentLocale(),
            Icons.science_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String content, IconData icon) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    bool isDarkMode = themeProvider.isDarkMode;
    if (content.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isDarkMode
                      ? _getTypeColor(widget.medicine.typeName).withOpacity(0.1)
                      : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color:
                  isDarkMode
                      ? Colors.white
                      : _getTypeColor(widget.medicine.typeName),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocaleText(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Drug",
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "Drug",
                    color: isDarkMode ? Colors.white : Colors.grey,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMedicineIcon(String typeName) {
    switch (typeName.toLowerCase()) {
      case 'pills':
        return Icons.medication_outlined;
      case 'injections':
        return Icons.medical_information_outlined;
      case 'capsules':
        return Icons.medication_liquid_outlined;
      case 'creams':
        return Icons.spa_outlined;
      case 'syrup':
        return Icons.water_drop_outlined;
      default:
        return Icons.medication_outlined;
    }
  }

  Color _getTypeColor(String typeName) {
    switch (typeName.toLowerCase()) {
      case 'pills':
        return Color(0xFFB8860B);
      case 'injections':
        return Color(0xFFFF6B6B);
      case 'capsules':
        return Color(0xFFF57C00);
      case 'creams':
        return Color(0xFF43A047);
      case 'syrup':
        return Color(0xFFFF9F43);
      default:
        return Color(0xFF455A64);
    }
  }

  // Gold
  String _getDescriptionForCurrentLocale() {
    final currentLocale = Locales.currentLocale(context)?.languageCode ?? 'en';
    return widget.medicine.getDescriptionForLanguage(currentLocale);
  }

  String _getUsesForCurrentLocale() {
    final currentLocale = Locales.currentLocale(context)?.languageCode ?? 'en';
    return widget.medicine.getUsesForLanguage(currentLocale);
  }

  String _getDosageForCurrentLocale() {
    final currentLocale = Locales.currentLocale(context)?.languageCode ?? 'en';
    return widget.medicine.getDosageForLanguage(currentLocale);
  }
}
