import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/theme/app_theme_color.dart';
import '../../providers/sura_reciter_providers.dart';

String toBengaliDigit(int number) {
  const bengaliDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
  return number.toString().split('').map((digit) {
    return bengaliDigits[int.parse(digit)];
  }).join('');
}

class AudioRangeSelectionDialog extends ConsumerStatefulWidget {
  final int totalAyahs;
  final int suraNumber;

  const AudioRangeSelectionDialog({
    super.key,
    required this.totalAyahs,
    required this.suraNumber,
  });

  @override
  ConsumerState<AudioRangeSelectionDialog> createState() =>
      _AudioRangeSelectionDialogState();
}

class _AudioRangeSelectionDialogState
    extends ConsumerState<AudioRangeSelectionDialog> {
  late int _selectedStartAyah;
  late int _selectedEndAyah;
  late FixedExtentScrollController _startController;
  late FixedExtentScrollController _endController;

  bool _isFullSura = false;
  int _repeatCount = 0;

  @override
  void initState() {
    super.initState();
    _selectedStartAyah = 1;
    _selectedEndAyah = widget.totalAyahs > 1 ? 2 : 1;

    _startController =
        FixedExtentScrollController(initialItem: _selectedStartAyah - 1);
    _endController =
        FixedExtentScrollController(initialItem: _selectedEndAyah - 1);
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  void _onFullSuraChanged(bool? value) {
    setState(() {
      _isFullSura = value ?? false;
      if (_isFullSura) {
        _selectedStartAyah = 1;
        _selectedEndAyah = widget.totalAyahs;
        _startController.animateToItem(
          _selectedStartAyah - 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _endController.animateToItem(
          _selectedEndAyah - 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isLight = Theme.of(context).colorScheme.brightness == Brightness.light;
    final accent =
        isLight ? colors.secondaryText : Theme.of(context).colorScheme.primary;
    final accentContainer = isLight
        ? colors.surfaceBg.withOpacity(0.9)
        : Theme.of(context).colorScheme.primaryContainer;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPickerUI(),
            const SizedBox(height: 16),
            _buildFullSuraCheckbox(),
            _buildRepeatStepper(),
            const SizedBox(height: 16),
            _buildListenButton(accentContainer, accent),
          ],
        ),
      ),
    );
  }

  Widget _buildListenButton(Color background, Color foreground) {
    return ElevatedButton(
      onPressed: () async {
        final audioPlayer = ref.read(suraAudioPlayerProvider);
        ref.read(selectedAudioSuraProvider.notifier).state = widget.suraNumber;
        ref.read(selectedStartAyahProvider.notifier).state = _selectedStartAyah;
        ref.read(selectedEndAyahProvider.notifier).state = _selectedEndAyah;
        if (!context.mounted) return;
        final bool playbackStarted = await audioPlayer.playAyahs(
          _selectedStartAyah,
          _selectedEndAyah,
          context,
        );
        if (playbackStarted) {
          Navigator.of(context).pop();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: const Text(
        'অডিও শুনুন',
        style: TextStyle(

            wordSpacing: 3,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPickerUI() {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isLight = Theme.of(context).colorScheme.brightness == Brightness.light;
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: isLight
            ? colors.surfaceBg.withOpacity(0.9)
            : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'শুরু',
                  style: TextStyle(
        
                    wordSpacing: 3,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
                Text(
                  'শেষ',
                  style: TextStyle(
        
                    wordSpacing: 3,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Row(
              children: [
                _buildPickerColumn(
                  controller: _startController,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedStartAyah = index + 1;
                      if (_isFullSura) _isFullSura = false;
                      if (_selectedStartAyah > _selectedEndAyah) {
                        _selectedEndAyah = _selectedStartAyah;
                        _endController.animateToItem(_selectedEndAyah - 1,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut);
                      }
                    });
                  },
                ),
                const VerticalDivider(width: 1),
                _buildPickerColumn(
                  controller: _endController,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedEndAyah = index + 1;
                      if (_isFullSura) _isFullSura = false;
                      if (_selectedEndAyah < _selectedStartAyah) {
                        _selectedStartAyah = _selectedEndAyah;
                        _startController.animateToItem(_selectedStartAyah - 1,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerColumn({
    required FixedExtentScrollController controller,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isLight = Theme.of(context).colorScheme.brightness == Brightness.light;
    final stripBg = isLight
        ? colors.divider.withOpacity(0.5)
        : Theme.of(context).colorScheme.primary;
    final selectedTextColor =
        isLight ? colors.secondaryText : Theme.of(context).colorScheme.onPrimary;

    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: stripBg,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 40,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onSelectedItemChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final ayahNumber = index + 1;
                final isSelected = (_selectedStartAyah == ayahNumber &&
                        controller == _startController) ||
                    (_selectedEndAyah == ayahNumber &&
                        controller == _endController);
                return Center(
                  child: Text(
                    toBengaliDigit(ayahNumber),
                    style: TextStyle(
                      fontSize: 22,
          
                      wordSpacing: 3,
                      color: isSelected
                          ? selectedTextColor
                          : Theme.of(context).textTheme.bodyLarge?.color,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
              childCount: widget.totalAyahs,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullSuraCheckbox() {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isLight = Theme.of(context).colorScheme.brightness == Brightness.light;
    final accent =
        isLight ? colors.secondaryText : Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _isFullSura,
            onChanged: _onFullSuraChanged,
            activeColor: accent,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _onFullSuraChanged(!_isFullSura),
          child: Text(
            'সম্পূর্ণ সূরা',
            style: TextStyle(
  
              wordSpacing: 3,
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRepeatStepper() {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final isLight = Theme.of(context).colorScheme.brightness == Brightness.light;
    final accent =
        isLight ? colors.secondaryText : Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'আয়াতের পুনরাবৃত্তি',
          style: TextStyle(

            wordSpacing: 3,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            if (_repeatCount > 0) {
              setState(() => _repeatCount--);
            }
          },
          color: Theme.of(context).dividerColor,
        ),
        Text(
          toBengaliDigit(_repeatCount),
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: accent,
              fontFamily: 'bangla/solaimanlipi'),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            setState(() => _repeatCount++);
          },
          color: Theme.of(context).dividerColor,
        ),
      ],
    );
  }
}
