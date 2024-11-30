import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:skill_forge/utils/color_scheme.dart';

List<TimeRegion> _getTimeRegions() {
  final List<TimeRegion> regions = <TimeRegion>[];
  regions.add(TimeRegion(
    startTime: DateTime(2020, 5, 29, 00, 0, 0),
    endTime: DateTime(2020, 5, 29, 24, 0, 0),
    recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=SAT,SUN',
    color: AppColorScheme.lapisLazuli,
  ));

  return regions;
}
