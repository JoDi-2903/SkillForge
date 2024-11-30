import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:skill_forge/utils/color_scheme.dart';
import 'package:easter/easter.dart';

List<TimeRegion> getWeekTimeRegions(DateTime? currentDate, String state) {
  final List<TimeRegion> regions = <TimeRegion>[];
  int yearNow = (currentDate?.year)!.toInt();
  //weekends
  regions.add(TimeRegion(
    startTime: currentDate!,
    endTime: currentDate.add(const Duration(hours: 24)),
    recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=SAT,SUN',
    color: AppColorScheme.antiFlash,
  ));
  //add fixed holidays
  for (int i = -1; i < 2; i++) {
    //new year
    regions.add(TimeRegion(
      startTime: DateTime(yearNow + i, 1, 1, 0),
      endTime: DateTime(yearNow + i, 1, 1, 24),
      color: AppColorScheme.antiFlash,
    ));
    //firstmay
    regions.add(TimeRegion(
      startTime: DateTime(yearNow + i, 5, 1, 0),
      endTime: DateTime(yearNow + i, 5, 1, 24),
      color: AppColorScheme.antiFlash,
    ));
    //german unity
    regions.add(TimeRegion(
      startTime: DateTime(yearNow + i, 10, 3, 0),
      endTime: DateTime(yearNow + i, 10, 3, 24),
      color: AppColorScheme.antiFlash,
    ));
    //christmas1
    regions.add(TimeRegion(
      startTime: DateTime(yearNow + i, 12, 25, 0),
      endTime: DateTime(yearNow + i, 12, 25, 24),
      color: AppColorScheme.antiFlash,
    ));
    //christmas2
    regions.add(TimeRegion(
      startTime: DateTime(yearNow + i, 12, 26, 0),
      endTime: DateTime(yearNow + i, 12, 26, 24),
      color: AppColorScheme.antiFlash,
    ));

    //get date of easter for church holidays
    DateTime easter = getEaster(yearNow);
    //carfriday
    regions.add(TimeRegion(
      startTime: easter.subtract(const Duration(hours: 48)),
      endTime: easter.subtract(const Duration(hours: 24)),
      color: AppColorScheme.antiFlash,
    ));
    //eastersunday
    regions.add(TimeRegion(
      startTime: easter,
      endTime: easter.add(const Duration(hours: 24)),
      color: AppColorScheme.antiFlash,
    ));
    //eastermonday
    regions.add(TimeRegion(
      startTime: easter.add(const Duration(hours: 24)),
      endTime: easter.add(const Duration(hours: 48)),
      color: AppColorScheme.antiFlash,
    ));
    //christheavendrive
    regions.add(TimeRegion(
      startTime: easter.add(const Duration(hours: 39 * 24)),
      endTime: easter.add(const Duration(hours: 40 * 24)),
      color: AppColorScheme.antiFlash,
    ));
    //Pfingstsunday
    regions.add(TimeRegion(
      startTime: easter.add(const Duration(hours: 49 * 24)),
      endTime: easter.add(const Duration(hours: 50 * 24)),
      color: AppColorScheme.antiFlash,
    ));
    //Pfingstmonday
    regions.add(TimeRegion(
      startTime: easter.add(const Duration(hours: 50 * 24)),
      endTime: easter.add(const Duration(hours: 51 * 24)),
      color: AppColorScheme.antiFlash,
    ));
    //switch case
    //6.Jan
    regions.add(TimeRegion(
      startTime: DateTime(yearNow + i, 1, 6, 0),
      endTime: DateTime(yearNow + i, 1, 6, 24),
      color: AppColorScheme.antiFlash,
    ));
    //8March IntWomenDay
    regions.add(TimeRegion(
      startTime: DateTime(yearNow + i, 3, 8, 0),
      endTime: DateTime(yearNow + i, 3, 8, 24),
      color: AppColorScheme.antiFlash,
    ));
    //HappyCadaver
    regions.add(TimeRegion(
      startTime: easter.add(const Duration(hours: 59 * 24)),
      endTime: easter.add(const Duration(hours: 60 * 24)),
      color: AppColorScheme.antiFlash,
    ));
    //8August AugsburgPeaceHoliday
    regions.add(TimeRegion(
      startTime: DateTime(yearNow + i, 8, 8, 0),
      endTime: DateTime(yearNow + i, 8, 8, 24),
      color: AppColorScheme.antiFlash,
    ));
    //15August Mariaheavendrive
    regions.add(TimeRegion(
      startTime: DateTime(yearNow + i, 15, 8, 0),
      endTime: DateTime(yearNow + i, 15, 8, 24),
      color: AppColorScheme.antiFlash,
    ));
    //20Sept WorldChildDay
    regions.add(TimeRegion(
      startTime: DateTime(yearNow + i, 9, 20, 0),
      endTime: DateTime(yearNow + i, 9, 20, 24),
      color: AppColorScheme.antiFlash,
    ));
    //31Oct Reformationday
    regions.add(TimeRegion(
      startTime: DateTime(yearNow + i, 10, 31, 0),
      endTime: DateTime(yearNow + i, 10, 31, 24),
      color: AppColorScheme.antiFlash,
    ));
    //1Nov AllahHoly
    regions.add(TimeRegion(
      startTime: DateTime(yearNow + i, 11, 1, 0),
      endTime: DateTime(yearNow + i, 11, 1, 24),
      color: AppColorScheme.antiFlash,
    ));
    //
  }
  return regions;
}
