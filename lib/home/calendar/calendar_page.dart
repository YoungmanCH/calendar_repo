import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'calendar_widget.dart';
import 'calendar_provider.dart';
import 'popup/provider/pop_show_provider.dart';
import 'popup/popup_show_page.dart';
import '../home_provider.dart';
import '../home_function.dart';

class CalendarScreen extends ConsumerWidget {
  final int selectedMonth;
  final DateTime firstDay;
  final DateTime lastDay;
  final PageController pageController;

  const CalendarScreen({
    Key? key,
    required this.selectedMonth,
    required this.firstDay, 
    required this.lastDay, 
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    //notifierは通知されるため、ウィジェットの描画が必要なとこに用いるか、NotiferでcopyWith()を作成して呼び出す必要がある。

    //タプル型の構造体の変数を呼び出す場合は、下記のように使用する。なお、構造体とはいえ、定数です。
    // ref.watch(calendarProvider((firstDay: firstDay))).lateCount;
    List dateList = [];
    final List dayOfWeek = ['月', '火', '水', '木', '金', '土', '日'];
    // final List monthNumber = List.generate(12, (index) => index+1);
    // String selectedMonth = '';
    int todayMonth = 0;
    List<int> dateInMonth = [];
    List<int> dateInLastMonth = [];
    List<int> dateInNextMonth = [];
    int year = 0;
    int month = 0;
    int lateCount = 0;
    int plusCount = 0;
    bool judge = false;
    int dateSave = 0;
    int plusSaveCount = 0;

    List<bool> calJudgeList = [];

    void dateInMonthFunc() {
      year = firstDay.year;
      month = firstDay.month;
      DateTime firstDate = DateTime(year, month);
      DateTime endDate = DateTime(year, month+1);
      DateTime lastMonth = DateTime(year, month-1);
      DateTime nextMonth = DateTime(year, month+1);
      DateTime nextnextMonth = DateTime(year, month+2);
      dateInMonth.clear();

      //先月
      for (DateTime date = lastMonth; date.isBefore(firstDate); date = date.add(const Duration(days: 1))) {
        dateInLastMonth.add(date.day);
      }

      //来月
      for (DateTime date = nextMonth; date.isBefore(nextnextMonth); date = date.add(const Duration(days: 1))) {
        dateInNextMonth.add(date.day);
      }

      //今月
      for (DateTime date = firstDate; date.isBefore(endDate); date = date.add(const Duration(days: 1))) {
        dateInMonth.add(date.day);
      }
    }

    // Future <void> datePickerWidget(BuildContext context, WidgetRef ref) async {
    //   final DateTime? dateTime  = await showDatePicker(
    //     context: context,
    //     initialDate: ref.watch(setDateProvider),
    //     firstDate: DateTime(1500),
    //     lastDate: DateTime(3000),
    //   );

    //   print('hello: ${dateTime}');
    //   if (dateTime != null) {
    //     ref.watch(setDateProvider.notifier).state = DateTime.parse(dateTime.toString());
    //     // pageController.animateToPage(
    //     //   int.parse(dateTime.toString()),
    //     //   duration: const Duration(milliseconds: 1000),
    //     //   curve: Curves.easeInOut,
    //     // );
    //   }
    //   // ref.watch(firstDayMonthProvider(firstDay));
    // }

    //ここのコードをカレンダー形式に変更させる。
    // Future <void> dateTimePickerFunc(BuildContext context, WidgetRef ref) async {
    //   final DateTime dateTime = DateTime.now();
    //   final dateTimeYear = dateTime.year;
    //   showCupertinoModalPopup(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return SizedBox(
    //         height: 300, //ロールリストの高さ
    //         child: CupertinoPicker(
    //           itemExtent: 50, //itemの高さ
    //           children: monthNumber.map((e) => Text('$e月')).toList(),
    //           onSelectedItemChanged: (newValue) {
    //             if (newValue < 9){
    //               selectedMonth = '0${newValue + 1}';
    //             } else {
    //               selectedMonth = '${newValue + 1}';
    //             }

    //             final selectedPageIndex = newValue;
    //             ref.watch(selectedMonthProvider.notifier).state = selectedMonth;
    //             ref.watch(selectedYearProvider.notifier).state = dateTimeYear;

    //             pageController.animateToPage(
    //               selectedPageIndex,
    //               duration: const Duration(milliseconds: 1000),
    //               curve: Curves.easeInOut,
    //             );
    //           }
    //         ),
    //       );
    //     },
    //   );
    // }

    void dateListFunc() {
      dateList.clear();
      for (int i = 0; i < 42; i++) {
        dateList.add(i);
      }
    }

    dateInMonthFunc();
    dateListFunc();
    calJudgeList.clear();
    print('firstDay: ${firstDay}');

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        child: const Text(
                          '今日', 
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        onPressed: () {
                          todayMonth = getElapsedMonths(DateTime.now());
                          print('number: $todayMonth');
                          pageController.animateToPage(
                            todayMonth,
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 50),
                          child: Text(ref.watch(firstDayMonthProvider(firstDay))),
                        ),
                        IconButton(
                          onPressed: () async {
                            final DateTime? dateTime = await showDatePicker(
                              context: context,
                              initialDate: ref.watch(setDateProvider),
                              firstDate: DateTime(1970, 1),
                              lastDate: DateTime(3000, 1),
                            );
                            if (dateTime != null) {
                              pageController.animateToPage(
                                getElapsedMonths(dateTime),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          icon: const Icon(
                            CupertinoIcons.arrowtriangle_down_fill, 
                            color: Colors.black,
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                //曜日
                height: 32,
                child: GridView.builder(
                  itemCount: dayOfWeek.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 2,
                    childAspectRatio: 2.0, // セルの幅と高さの比
                  ),
                  itemBuilder: (context, index) {
                  Color textColor = Colors.black;
                    if (index == 5) {
                      textColor = Colors.blue;
                    } else if(index == 6){
                      textColor = Colors.red;
                    } else {
                      textColor = Colors.black;
                    }
      
                    return Container(
                      color: const Color.fromARGB(255, 226, 226, 226),
                      child: Center(    
                        child: Text(
                          dayOfWeek[index].toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: textColor,
                          ),
                        )
                      ),
                    );
                  }
                ),
              ),
              SizedBox(
                height: 500,
                child: GridView.builder( 
                  itemCount: dateList.length, 
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    // crossAxisSpacing: 2,     
                    // mainAxisSpacing: 2,      
                    crossAxisCount: 7,      
                  ),
                  itemBuilder: (context, index) {
                    Color textColor = Colors.black;
                    Color backgroundColor = Colors.white;
                    final List saturday = [5, 12, 19, 26, 33, 40];
                    final List sunday = [6, 13, 20, 27, 34, 41];
                     
                    if (index == saturday[0] || index == saturday[1] || index == saturday[2] || index == saturday[3] || index == saturday[4] || index == saturday[5]) {
                      textColor = Colors.blue;
                    }else if (index == sunday[0] || index == sunday[1] || index == sunday[2] || index == sunday[3] || index == sunday[4] || index == sunday[5]) {
                      textColor = Colors.red;
                    }else {
                      textColor = Colors.black;
                    }
      
                    if (firstDay.month == DateTime.now().month) {
                      judge = true;
                    }else {
                      judge = false;
                    }
      
      
                    if (firstDay.weekday == DateTime.monday) {
                      if (index < dateInMonth.length) {
                        if (index + 1 == DateTime.now().day && judge == true) {
                          backgroundColor = Colors.blue;
                          textColor = Colors.white;
                        }else {
                          backgroundColor = Colors.white;
                        }
                        // その月の日付を表示
      
                        ref.watch(holidaysProvider(firstDay)).when(
                          loading: () => (),
                          error: (error, stackTrace) => debugPrint('error: $error, $stackTrace'),
                          data: (holidayList) {
                            final date = DateTime(firstDay.year, firstDay.month, dateInMonth[index]);
                            String dateMonth = date.month.toString();
                            String dateDay = date.day.toString();
                            if(date.month < 10) {
                              dateMonth = '0${date.month}';
                            }
                            if(date.day < 10) {
                              dateDay = '0${date.day}';
                            }
                            final dateJudge = '${date.year}-$dateMonth-$dateDay';
                            if(holidayList.contains(dateJudge)) {
                              textColor = Colors.red;
                            }
                          }
                        );
      
                        int year = firstDay.year;
                        int month = firstDay.month;
                        int day = index + 1;
      
                        DateTime dateCalen = DateTime(year, month, day);
      
                        return Container(
                          color: Colors.white,
                          child: Align(
                            alignment: Alignment.center,
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: TextButton(
                                        child: Text(
                                          dateInMonth[index % dateInMonth.length].toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: textColor,
                                          ),
                                        ),
                                        onPressed: () {
                                          dateSave = dateInMonth[index % dateInMonth.length];
                                          dateSave = dateSave;
                                          int year = firstDay.year;
                                          int month = firstDay.month;
                                          int day = dateSave;
                                          ref.watch(setYearProvider.notifier).state = year;
                                          ref.watch(setMonthProvider.notifier).state = month;
                                          ref.watch(setDayProvider.notifier).state = day;
                                          ref.watch(judgeWeekPopProvider.notifier).state = DateTime(year, month, day).weekday;
      
                                          if (textColor == Colors.red) {
                                            ref.watch(holidayJudgeProvider.notifier).state = true;
                                          }else {
                                            ref.watch(holidayJudgeProvider.notifier).state = false;
                                          }
                                          popupController(context,ref);
                                        },
                                      ),
                                    ),
                                    Container(
                                      child: CalendarFunc(ref, dateCalen),
                                    ),
                                  ],
                                ),
                              ),
                          ),
                        );
                      } else {
                        // 翌月の日付を表示
                        final nextMonthIndex = index - dateInMonth.length;
      
                        return Container(
                          color: Colors.white,
                          child: Align(
                            // alignment: Alignment.center,
                            child: Container(
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.only(top: 9),
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              // child: Center(
                                child: Text(
                                  dateInNextMonth[nextMonthIndex].toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey
                                  ),
                                // ),
                              ),
                            ),
                          ),
                        );
                      }
                    }else {
                      lateCount = firstDay.weekday -1;
                      if(lateCount > index) {
                           
                        return Container(
                          color: Colors.white,
                          child: Align(
                            // alignment: Alignment.center,
                            child: Container(
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.only(top: 9),
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              // child: Center(
                                child: Text(
                                  dateInLastMonth[dateInLastMonth.length + index - lateCount].toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              // ),
                            ),
                          ),
                        );
                      }else if (index < dateInMonth.length + lateCount) {
                        // その月の日付を表示
                        plusCount = index - lateCount;
                        int plusPressedCount = plusCount;
      
      
                        int year = firstDay.year;
                        int month = firstDay.month;
                        int day = plusPressedCount + 1;
      
                        DateTime dateCalen = DateTime(year, month, day);
                      
      
                        ref.watch(holidaysProvider(firstDay)).when(
                          loading: () => (),
                          error: (error, stackTrace) => debugPrint('error: $error, $stackTrace'),
                          data: (holidayList) {
                            final date = DateTime(firstDay.year, firstDay.month, dateInMonth[plusCount]);
                            String dateMonth = date.month.toString();
                            String dateDay = date.day.toString();
                            if(date.month < 10) {
                              dateMonth = '0${date.month}';
                            }
                            if(date.day < 10) {
                              dateDay = '0${date.day}';
                            }
                            final dateJudge = '${date.year}-$dateMonth-$dateDay';
                            if(holidayList.contains(dateJudge)) {
                              textColor = Colors.red;
                            }
                          }
                        );
      
      
                        if (plusCount + 1 == DateTime.now().day && judge == true) {
                          backgroundColor = Colors.blue;
                          textColor = Colors.white;
                        }else {
                          backgroundColor = Colors.white;
                        }
                          
                        return Container(
                          color: Colors.white,
                          child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(                            
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: TextButton(
                                        child: Text(
                                          dateInMonth[plusCount % dateInMonth.length].toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: textColor,
                                          ), 
                                        ),
                                        onPressed: ()  {
                                          dateSave = dateInMonth[plusPressedCount % dateInMonth.length];
                                          plusSaveCount = plusPressedCount;
      
                                          int year = firstDay.year;
                                          int month = firstDay.month;
                                          int day = plusSaveCount + 1;
                                          ref.watch(setYearProvider.notifier).state = year;
                                          ref.watch(setMonthProvider.notifier).state = month;
                                          ref.watch(setDayProvider.notifier).state = day;
                                          ref.watch(judgeWeekPopProvider.notifier).state = DateTime(year, month, day).weekday;
      
                                          if (textColor == Colors.red) {
                                            ref.watch(holidayJudgeProvider.notifier).state = true;
                                          }else {
                                            ref.watch(holidayJudgeProvider.notifier).state = false;
                                          }
                                          popupController(context,ref);
                                        },
                                      ),                        
                                    ),
                                    Container(
                                      child: CalendarFunc(ref, dateCalen),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        // 翌月の日付を表示
                        final nextMonthIndex = index - plusCount -lateCount -1;
                        return Container(
                          color: Colors.white,
                          child: Align(
                            // alignment: Alignment.center,
                            child: Container(
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.only(top: 9),
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              // child: Center(
                                child: Text(
                                  dateInNextMonth[nextMonthIndex].toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              // ),
                            ),
                          ),
                        );
                      }
                    }                  
                  },
                ),
              ),    
            ],
          ),
        ),
      ),
    );
  }
}
