import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:skill_forge/utils/color_scheme.dart';
import 'package:easter/easter.dart';
import 'package:skill_forge/utils/languages.dart';

Region region = de;

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
    //6.Jan
    if (region.identifier == 'BW' ||
        region.identifier == 'BY' ||
        region.identifier == 'ST') {
      regions.add(TimeRegion(
        startTime: DateTime(yearNow + i, 1, 6, 0),
        endTime: DateTime(yearNow + i, 1, 6, 24),
        color: AppColorScheme.antiFlash,
      ));
    }
    //8March IntWomenDay
    if (region.identifier == 'BE' || region.identifier == 'MV') {
      regions.add(TimeRegion(
        startTime: DateTime(yearNow + i, 3, 8, 0),
        endTime: DateTime(yearNow + i, 3, 8, 24),
        color: AppColorScheme.antiFlash,
      ));
    }
    //HappyCadaver
    if (region.identifier == 'BW' ||
        region.identifier == 'BY' ||
        region.identifier == 'HE' ||
        region.identifier == 'NW' ||
        region.identifier == 'RP' ||
        region.identifier == 'SL' ||
        region.identifier == 'SN' ||
        region.identifier == 'TH') {
      regions.add(TimeRegion(
        startTime: easter.add(const Duration(hours: 59 * 24)),
        endTime: easter.add(const Duration(hours: 60 * 24)),
        color: AppColorScheme.antiFlash,
      ));
    }
    //8August AugsburgPeaceHoliday
    if (region.identifier == 'BY') {
      regions.add(TimeRegion(
        startTime: DateTime(yearNow + i, 8, 8, 0),
        endTime: DateTime(yearNow + i, 8, 8, 24),
        color: AppColorScheme.antiFlash,
      ));
    }
    //15August Mariaheavendrive
    if (region.identifier == 'BY' || region.identifier == 'SL') {
      regions.add(TimeRegion(
        startTime: DateTime(yearNow + i, 15, 8, 0),
        endTime: DateTime(yearNow + i, 15, 8, 24),
        color: AppColorScheme.antiFlash,
      ));
    }
    //20Sept WorldChildDay
    if (region.identifier == 'TH') {
      regions.add(TimeRegion(
        startTime: DateTime(yearNow + i, 9, 20, 0),
        endTime: DateTime(yearNow + i, 9, 20, 24),
        color: AppColorScheme.antiFlash,
      ));
    }
    //31Oct Reformationday
    if (region.identifier == 'BB' ||
        region.identifier == 'HB' ||
        region.identifier == 'HH' ||
        region.identifier == 'MV' ||
        region.identifier == 'NI' ||
        region.identifier == 'SN' ||
        region.identifier == 'ST' ||
        region.identifier == 'SH' ||
        region.identifier == 'TH') {
      regions.add(TimeRegion(
        startTime: DateTime(yearNow + i, 10, 31, 0),
        endTime: DateTime(yearNow + i, 10, 31, 24),
        color: AppColorScheme.antiFlash,
      ));
    }
    //1Nov AllSaints
    if (region.identifier == 'BW' ||
        region.identifier == 'BY' ||
        region.identifier == 'NW' ||
        region.identifier == 'RP' ||
        region.identifier == 'SL') {
      regions.add(TimeRegion(
        startTime: DateTime(yearNow + i, 11, 1, 0),
        endTime: DateTime(yearNow + i, 11, 1, 24),
        color: AppColorScheme.antiFlash,
      ));
    }
  }
  return regions;
}

List<Appointment> getHolidayasAppointment(DateTime? currentDate, String state) {
  List<Appointment> holidays = [];
  int yearNow = (currentDate?.year)!.toInt();
  for (int i = -1; i < 2; i++) {
    //newyear
    holidays.add(Appointment(
      isAllDay: true,
      subject: AppStrings.newYear,
      color: AppColorScheme.lapisLazuli,
      startTime: DateTime(yearNow + i, 1, 1, 0),
      endTime: DateTime(yearNow + i, 1, 1, 0),
      notes: null,
    ));
    //firstmay
    holidays.add(Appointment(
      isAllDay: true,
      subject: AppStrings.firstMay,
      color: AppColorScheme.lapisLazuli,
      startTime: DateTime(yearNow + i, 5, 1, 0),
      endTime: DateTime(yearNow + i, 5, 1, 0),
      notes: null,
    ));
    //germanunity
    holidays.add(Appointment(
      isAllDay: true,
      subject: AppStrings.germanUnity,
      color: AppColorScheme.lapisLazuli,
      startTime: DateTime(yearNow + i, 10, 3, 0),
      endTime: DateTime(yearNow + i, 10, 3, 0),
      notes: null,
    ));
    //christmas1
    holidays.add(Appointment(
      isAllDay: true,
      subject: AppStrings.christmas1,
      color: AppColorScheme.lapisLazuli,
      startTime: DateTime(yearNow + i, 12, 25, 0),
      endTime: DateTime(yearNow + i, 12, 25, 0),
      notes: null,
    ));
    //christmas2
    holidays.add(Appointment(
      isAllDay: true,
      subject: AppStrings.christmas2,
      color: AppColorScheme.lapisLazuli,
      startTime: DateTime(yearNow + i, 12, 26, 0),
      endTime: DateTime(yearNow + i, 12, 26, 0),
      notes: null,
    ));

    DateTime easter = getEaster(yearNow + i);
    //carfriday
    holidays.add(Appointment(
      isAllDay: true,
      subject: AppStrings.carFriday,
      color: AppColorScheme.lapisLazuli,
      startTime: easter.subtract(const Duration(hours: 48)),
      endTime: easter.subtract(const Duration(hours: 48)),
      notes: null,
    ));
    //eastersunday
    holidays.add(Appointment(
      isAllDay: true,
      subject: AppStrings.easterSunday,
      color: AppColorScheme.lapisLazuli,
      startTime: easter,
      endTime: easter,
      notes: null,
    ));
    //eastermonday
    holidays.add(Appointment(
      isAllDay: true,
      subject: AppStrings.easterMonday,
      color: AppColorScheme.lapisLazuli,
      startTime: easter.add(const Duration(hours: 24)),
      endTime: easter.add(const Duration(hours: 24)),
      notes: null,
    ));
    //christheavendrive
    holidays.add(Appointment(
      isAllDay: true,
      subject: AppStrings.christHeavenDrive,
      color: AppColorScheme.lapisLazuli,
      startTime: easter.add(const Duration(hours: 39 * 24)),
      endTime: easter.add(const Duration(hours: 39 * 24)),
      notes: null,
    ));
    //Pfingstsunday
    holidays.add(Appointment(
      isAllDay: true,
      subject: AppStrings.whitSunday,
      color: AppColorScheme.lapisLazuli,
      startTime: easter.add(const Duration(hours: 49 * 24)),
      endTime: easter.add(const Duration(hours: 49 * 24)),
      notes: null,
    ));
    //Pfingstmonday
    holidays.add(Appointment(
      isAllDay: true,
      subject: AppStrings.whitMonday,
      color: AppColorScheme.lapisLazuli,
      startTime: easter.add(const Duration(hours: 50 * 24)),
      endTime: easter.add(const Duration(hours: 50 * 24)),
      notes: null,
    ));
    //6.Jan
    if (region.identifier == 'BW' ||
        region.identifier == 'BY' ||
        region.identifier == 'ST') {
      holidays.add(Appointment(
        isAllDay: true,
        subject: AppStrings.epiphany,
        color: AppColorScheme.lapisLazuli,
        startTime: DateTime(yearNow + i, 1, 6, 0),
        endTime: DateTime(yearNow + i, 1, 6, 0),
        notes: null,
      ));
    }
    //8March
    if (region.identifier == 'BE' || region.identifier == 'MV') {
      holidays.add(Appointment(
        isAllDay: true,
        subject: AppStrings.intlWomen,
        color: AppColorScheme.lapisLazuli,
        startTime: DateTime(yearNow + i, 3, 8, 0),
        endTime: DateTime(yearNow + i, 3, 8, 0),
        notes: null,
      ));
    }
    //HappyCadaver
    if (region.identifier == 'BW' ||
        region.identifier == 'BY' ||
        region.identifier == 'HE' ||
        region.identifier == 'NW' ||
        region.identifier == 'RP' ||
        region.identifier == 'SL' ||
        region.identifier == 'SN' ||
        region.identifier == 'TH') {
      holidays.add(Appointment(
        isAllDay: true,
        subject: AppStrings.happyCadaver,
        color: AppColorScheme.lapisLazuli,
        startTime: easter.add(const Duration(hours: 60 * 24)),
        endTime: easter.add(const Duration(hours: 60 * 24)),
        notes: null,
      ));
    }
    //8August
    if (region.identifier == 'BY') {
      holidays.add(Appointment(
        isAllDay: true,
        subject: AppStrings.peaceParty,
        color: AppColorScheme.lapisLazuli,
        startTime: DateTime(yearNow + i, 8, 8, 0),
        endTime: DateTime(yearNow + i, 8, 8, 0),
        notes: null,
      ));
    }
    //15August
    if (region.identifier == 'BY' || region.identifier == 'SL') {
      holidays.add(Appointment(
        isAllDay: true,
        subject: AppStrings.mariaHeavenDrive,
        color: AppColorScheme.lapisLazuli,
        startTime: DateTime(yearNow + i, 8, 15, 0),
        endTime: DateTime(yearNow + i, 8, 15, 0),
        notes: null,
      ));
    }
    //20Sept
    if (region.identifier == 'TH') {
      holidays.add(Appointment(
        isAllDay: true,
        subject: AppStrings.worldChildDay,
        color: AppColorScheme.lapisLazuli,
        startTime: DateTime(yearNow + i, 9, 20, 0),
        endTime: DateTime(yearNow + i, 9, 20, 0),
        notes: null,
      ));
    }
    //31Oct
    if (region.identifier == 'BB' ||
        region.identifier == 'HB' ||
        region.identifier == 'HH' ||
        region.identifier == 'MV' ||
        region.identifier == 'NI' ||
        region.identifier == 'SN' ||
        region.identifier == 'ST' ||
        region.identifier == 'SH' ||
        region.identifier == 'TH') {
      holidays.add(Appointment(
        isAllDay: true,
        subject: AppStrings.reformationDay,
        color: AppColorScheme.lapisLazuli,
        startTime: DateTime(yearNow + i, 10, 31, 0),
        endTime: DateTime(yearNow + i, 10, 31, 0),
        notes: null,
      ));
    }
    //all saints
    if (region.identifier == 'BW' ||
        region.identifier == 'BY' ||
        region.identifier == 'NW' ||
        region.identifier == 'RP' ||
        region.identifier == 'SL') {
      holidays.add(Appointment(
        isAllDay: true,
        subject: AppStrings.allSaints,
        color: AppColorScheme.lapisLazuli,
        startTime: DateTime(yearNow + i, 11, 1, 0),
        endTime: DateTime(yearNow + i, 11, 1, 0),
        notes: null,
      ));
    }
  }

  return holidays;
}

class Region {
  String identifier = '';
  String name = '';
  Region(this.identifier, this.name);
}

final bw = Region(
  'BW',
  AppStrings.badenWurrtemberg,
);
final by = Region(
  'BY',
  AppStrings.bavaria,
);
final be = Region(
  'BE',
  AppStrings.berlin,
);
final bb = Region(
  'BB',
  AppStrings.brandenburg,
);
final hb = Region(
  'HB',
  AppStrings.bremen,
);
final hh = Region(
  'HH',
  AppStrings.hamburg,
);
final he = Region(
  'HE',
  AppStrings.hesse,
);
final mv = Region(
  'MV',
  AppStrings.mecklenburg,
);
final ni = Region(
  'NI',
  AppStrings.lsaxony,
);
final nw = Region(
  'NW',
  AppStrings.nrWestphalia,
);
final rp = Region(
  'RP',
  AppStrings.palatinate,
);
final sl = Region(
  'SL',
  AppStrings.saarland,
);
final sn = Region(
  'SN',
  AppStrings.saxony,
);
final st = Region(
  'ST',
  AppStrings.saxonya,
);
final sh = Region(
  'SH',
  AppStrings.schleswig,
);
final th = Region(
  'TH',
  AppStrings.thuringia,
);
final de = Region(
  'DE',
  AppStrings.germany,
);
