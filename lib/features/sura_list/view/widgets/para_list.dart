import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_app/core/utils/bengali_digit_extension.dart';
import 'package:native_app/features/quran/viewmodel/ayah_highlight_viewmodel.dart';
import 'package:native_app/shared/quran_data.dart';
import 'package:qlevar_router/qlevar_router.dart';

/// Bengali names for all 30 paras (Juz)
const List<String> paraNamesBengali = [
  'আলিফ লাম মীম',
  'সাইয়াকূল',
  'তিলকার রুসুল',
  'লান তানা-লু',
  'ওয়াল মুহসানাত',
  'লা ইউহিব্বুল্লাহ',
  'ওয়া ইযা সামিউ',
  'ওয়া লাও আন্নানা',
  'ক্বা-লাল মালাউ',
  'ওয়া\'লামূ',
  'ইয়া\'তাযিরূন',
  'ওয়ামা মিন দা-ব্বাহ',
  'ওয়ামা উবাররিউ',
  'রুবামা',
  'সুবহা-নাল্লাযী',
  'ক্বা-লা আলাম',
  'ইক্বতারাবা',
  'ক্বাদ আফলাহা',
  'ওয়া ক্বা-লাল্লাযীনা',
  'আম্মান খালাক্বা',
  'উতলু মা ঊহিয়া',
  'ওয়া মাই ইয়াক্বনুত',
  'ওয়া মা-লিয়া',
  'ফামান আযলামু',
  'ইলাইহি ইউরাদ্দু',
  'হা-মীম',
  'ক্বা-লা ফামা খাতবুকুম',
  'ক্বাদ সামি\'আল্লাহু',
  'তাবা-রাকাল্লাযী',
  'আম্মা',
];

class ParaList extends ConsumerWidget {
  const ParaList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      itemCount: paraStarts.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final paraNumber = index + 1;
        final (suraNumber, ayahNumber) = paraStarts[index];
        final suraName = suraNames[suraNumber - 1];
        final paraName = paraNamesBengali[index];

        return _ParaListItem(
          paraNumber: paraNumber,
          paraName: paraName,
          suraNumber: suraNumber,
          ayahNumber: ayahNumber,
          suraName: suraName,
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 1,
          thickness: 0.5,
          indent: 16,
          endIndent: 16,
        );
      },
    );
  }
}

class _ParaListItem extends StatelessWidget {
  final int paraNumber;
  final String paraName;
  final int suraNumber;
  final int ayahNumber;
  final String suraName;

  const _ParaListItem({
    required this.paraNumber,
    required this.paraName,
    required this.suraNumber,
    required this.ayahNumber,
    required this.suraName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the ayah in SurahPage
        // The initialScrollIndex is ayahNumber - 1 (0-indexed)
        QR.to('/qurans/sura/$suraNumber?scroll=${ayahNumber - 1}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            _buildParaNumber(),
            const SizedBox(width: 16),
            Expanded(child: _buildParaInfo()),
            _buildArrow(),
          ],
        ),
      ),
    );
  }

  Widget _buildParaNumber() {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        paraNumber.toBengaliDigit(),
        style: TextStyle(
          fontFamily: 'SolaimanLipi',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade700,
        ),
      ),
    );
  }

  Widget _buildParaInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          paraName,
          style: const TextStyle(
            fontFamily: 'SolaimanLipi',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.play_arrow,
              size: 16,
              color: Colors.grey.shade600,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'সূরা $suraName, আয়াত ${ayahNumber.toBengaliDigit()}',
                style: TextStyle(
                  fontFamily: 'SolaimanLipi',
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArrow() {
    return Icon(
      Icons.chevron_right,
      color: Colors.grey.shade400,
    );
  }
}
