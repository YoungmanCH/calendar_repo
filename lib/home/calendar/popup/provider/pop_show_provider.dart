import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../database/database.dart';

//autoDisposeを使うと、この場合、毎回データベースから取得する
final scheduleFromDatetimeProvider =
    FutureProvider.family.autoDispose<List<ScheduleRecord>, DateTime>((ref, datetime) {
  final db = ref.read(databaseProvider);
  return db.getScheduleListFromDateTime(datetime);
});

final weekPopProvider = StateProvider<String>((ref) => '');
final weekColorProvider = StateProvider<Color>((ref) => Colors.black);
final judgeWeekPopProvider = StateProvider<int>((ref) => 0);

final selectedDateProvider = Provider.family<DateTime, DateTime>(
    (ref, DateTime selectedDate) => selectedDate);
final selectedWeekdayProvider =
    Provider.family<int, int>((ref, int weekday) => weekday);
final selectedWeekdayStringProvider = StateProvider<String>((ref) => '');
final selectedWeekColorProvider = StateProvider<Color>((ref) => Colors.black);

final pageControllerProvider2 = Provider.family<PageController, int>((ref, index) {
  final currentPage = index;
  // return PageController(initialPage: currentPage);
  return PageController(initialPage: currentPage, viewportFraction: 0.9);
});

final changeIndexProvider = StateProvider<int>((ref) => 0);
// final pageControllerProvider2 = Provider<PageController>((ref) {
//   final currentPage = DateTime.now().month - 1;
//   return PageController(initialPage: currentPage, viewportFraction: 0.9);
// });

final firstDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final scheExistJudgeProvider = StateProvider<bool>((ref) => false);
final scheduleTitleListProvider2 =
    FutureProvider.family<List, DateTime>((ref, firstDate) async {
  final database = ref.watch(databaseProvider);
  final scheTitleList = await database.getScheduleTitle(firstDate);
  return scheTitleList;
});

final scheduleTitleListProvider = StateProvider<List>((ref) => []);
final scheduleJudgeListProvider = StateProvider<List>((ref) => []);
final scheduleStartDayListProvider = StateProvider<List>((ref) => []);
final scheduleEndDayListProvider = StateProvider<List>((ref) => []);
final scheduleContentListProvider = StateProvider<List>((ref) => []);

final popSelectedProvider = StateProvider<DateTime>((ref) => DateTime.now());
final popSelectedStartShowProvider =
    StateProvider<DateTime>((ref) => DateTime.now());
final popSelectedEndShowProvider =
    StateProvider<DateTime>((ref) => DateTime.now());

final setYearProvider = StateProvider<int>((ref) => 0);
final setMonthProvider = StateProvider<int>((ref) => 0);
final setDayProvider = StateProvider<int>((ref) => 0);
final scheduleCatchProvider =
    Provider.family<DateTime, DateTime>((ref, scheData) {
  int year = scheData.year;
  int month = scheData.month;
  int day = scheData.day;
  final data =
      ref.watch(scheduleDayProvider.notifier).setDateTime(year, month, day);
  return data;
});
final holidayCatchProvider = Provider.family<bool, bool>((ref, judge) {
  final data = ref.watch(scheduleDayProvider.notifier).holidayJudge(judge);
  return data;
});
final scheduleDayProvider =
    NotifierProvider<ScheduleDayNotifier, DateTime>(ScheduleDayNotifier.new);

class ScheduleDayNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now();
  }

  setDateTime(int year, int month, int date) {
    return DateTime(year, month, date);
  }

  holidayJudge(bool judge) {
    return judge;
  }
}

final holidayJudgeProvider = StateProvider<bool>((ref) => false);