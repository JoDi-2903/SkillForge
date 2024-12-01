class AppStrings {
  static String appTitle = 'Skillforge';
  static String hompageTitle = 'Skillforge';
  static String english = 'en';
  static String chinese = 'zh';
  static String german = 'de';
  static String yearLabel = 'Year';
  static String monthLabel = 'Month';
  static String weekLabel = 'Week';
  static String resetLabel = 'Reset';
  static String invalidCaptcha = 'Invalid captcha. Please try again.';
  static String failedLogin = 'Login failed';
  static String networkError = 'Network error. Please try again.';
  static String login = 'Login';
  static String username = 'Username';
  static String insertUsername = 'Please enter a username';
  static String password = 'Password';
  static String insertPassword = 'Please enter a password';
  static String captcha = 'Input Captcha';
  static String insertCaptcha = 'Please enter the Captcha code';
  static String wrongCaptcha = 'Invalid Captcha code';
  static String rememberMe = 'Remember me';
  static String forgotPassword = 'Forgot password?';
  static String resetPassword = 'Reset password';
  static String filterOptions = 'Filter Options';
  static String filterByUser = 'Show only my events';
  static String loginToFilter = 'Please log in to filter by user.';
  static String eventType = 'Event Type';
  static String subjectArea = 'Subject Area';
  static String clearFilters = 'Clear Filters';
  static String applyFilters = 'Apply Filters';
  static String failedToLoadEventDetails = 'Failed to load event details.';
  static String failedToCheckRegistrationStatus =
      'Failed to check registration status.';
  static String registrationSuccessful =
      'Successfully registered for the event.';
  static String registrationFailed = 'Registration failed.';
  static String cancellationSuccessful =
      'Successfully canceled your registration.';
  static String cancellationFailed = 'Cancellation failed.';
  static String appointmentDetails = 'Appointment Details';
  static String noEventDetails = 'No event details available.';
  static String cancelRegistration = 'Cancel Registration';
  static String registerForEvent = 'Register for Event';
  static String loginRequired = 'Login required to perform this action.';
  static String participants = 'Participants';
  static String eventDates = 'Event Dates';
  static String minParticipants = 'Min Participants';
  static String maxParticipants = 'Max Participants';
  static String currentParticipants = 'Current Participants';
  static String participantInfo = 'Participant Information';

  static void refreshLanguage(String language) {
    switch (language) {
      case 'de':
        appTitle = 'Skillforge';
        hompageTitle = 'Skillforge';
        english = 'en';
        chinese = 'zh';
        german = 'de';
        yearLabel = 'Jahr';
        monthLabel = 'Monat';
        weekLabel = 'Woche';
        resetLabel = 'Zurücksetzen';
        invalidCaptcha = 'Ungültiges Captcha. Bitte versuche es erneut.';
        failedLogin = 'Anmelden fehlgeschlagen';
        networkError = 'Netzwerkfehler. Bitte versuche es erneut.';
        login = 'Anmelden';
        username = 'Nutzername';
        insertUsername = 'Bitte gebe den Nutzername ein';
        password = 'Passwort';
        insertPassword = 'Bitte gebe das Passwort ein';
        captcha = 'Captcha Eingabe';
        insertCaptcha = 'Bitte gebe den Captcha Code ein';
        wrongCaptcha = 'Ungültiger Captcha Code';
        rememberMe = 'Angemeldet bleiben';
        forgotPassword = 'Passwort vergessen?';
        resetPassword = 'Passwort zurücksetzten';
        filterOptions = 'Filteroptionen';
        filterByUser = 'Nur meine Termine anzeigen';
        loginToFilter =
            'Bitte melden Sie sich zum Filtern nach gebuchten Terminen an.';
        eventType = 'Veranstaltungstyp';
        subjectArea = 'Fachbereich';
        clearFilters = 'Filter löschen';
        applyFilters = 'Filter anwenden';
        failedToLoadEventDetails =
            'Veranstaltungsdetails konnten nicht geladen werden.';
        failedToCheckRegistrationStatus =
            'Anmeldestatus konnte nicht überprüft werden.';
        registrationSuccessful =
            'Erfolgreich für die Veranstaltung angemeldet.';
        registrationFailed = 'Anmeldung fehlgeschlagen.';
        cancellationSuccessful = 'Anmeldung erfolgreich storniert.';
        cancellationFailed = 'Stornierung fehlgeschlagen.';
        appointmentDetails = 'Veranstaltungsdetails';
        noEventDetails = 'Keine Veranstaltungsdetails verfügbar.';
        cancelRegistration = 'Anmeldung stornieren';
        registerForEvent = 'Für Veranstaltung anmelden';
        loginRequired = 'Anmeldung erforderlich, um diese Aktion auszuführen.';
        participants = 'Teilnehmer';
        eventDates = 'Veranstaltungstermine';
        minParticipants = 'Minimale Teilnehmer';
        maxParticipants = 'Maximale Teilnehmer';
        currentParticipants = 'Aktuelle Teilnehmer';
        participantInfo = 'Teilnehmerinformationen';
        break;
      case 'zh':
        appTitle = '技能鍛造';
        hompageTitle = '技能鍛造';
        english = 'en';
        chinese = 'zh';
        german = 'de';
        yearLabel = '年';
        monthLabel = '月';
        weekLabel = '星期';
        resetLabel = '重置';
        invalidCaptcha = '驗證碼無效。請再試一次。';
        failedLogin = '登入失敗';
        networkError = '網路錯誤。請再試一次。';
        login = '登入';
        username = '使用者名稱';
        insertUsername = '請輸入使用者名稱';
        password = '密碼';
        insertPassword = '請輸入密碼';
        captcha = '輸入驗證碼';
        insertCaptcha = '請輸入驗證碼';
        wrongCaptcha = '驗證碼無效';
        rememberMe = '記住帳號';
        forgotPassword = '忘記密碼？';
        resetPassword = '重設密碼';
        filterOptions = '過濾器選項';
        filterByUser = '只顯示我的約會';
        loginToFilter = '請登入以按預訂的約會進行篩選。';
        eventType = '事件類型';
        subjectArea = '部門';
        clearFilters = '清除過濾器';
        applyFilters = '應用過濾器';
        failedToLoadEventDetails = '無法載入事件詳細資訊。';
        failedToCheckRegistrationStatus = '無法檢查註冊狀態。';
        registrationSuccessful = '活動報名成功。';
        registrationFailed = '註冊失敗。';
        cancellationSuccessful = '已成功取消您的註冊。';
        cancellationFailed = '取消失敗。';
        appointmentDetails = '預約詳情';
        noEventDetails = '沒有可用的活動詳細資訊。';
        cancelRegistration = '取消註冊';
        registerForEvent = '註冊參加活動';
        loginRequired = '需要登入才能執行此操作。';
        participants = '參加者';
        eventDates = '活動日期';
        minParticipants = '最低參加人數';
        maxParticipants = '最多參加人數';
        currentParticipants = '目前參與者';
        participantInfo = '參與者資訊';
        break;
      default:
        appTitle = 'Skillforge';
        hompageTitle = 'Skillforge';
        english = 'en';
        chinese = 'zh';
        german = 'de';
        yearLabel = 'Year';
        monthLabel = 'Month';
        weekLabel = 'Week';
        resetLabel = 'Reset';
        invalidCaptcha = 'Invalid captcha. Please try again.';
        failedLogin = 'Login failed';
        networkError = 'Network error. Please try again.';
        login = 'Login';
        username = 'Username';
        insertUsername = 'Please enter a username';
        password = 'Password';
        insertPassword = 'Please enter a password';
        captcha = 'Input Captcha';
        insertCaptcha = 'Please enter the Captcha code';
        wrongCaptcha = 'Invalid Captcha code';
        rememberMe = 'Remember me';
        forgotPassword = 'Forgot password?';
        resetPassword = 'Reset password';
        filterOptions = 'Filter Options';
        filterByUser = 'Show only my events';
        loginToFilter = 'Please log in to filter by user.';
        eventType = 'Event Type';
        subjectArea = 'Subject Area';
        clearFilters = 'Clear Filters';
        applyFilters = 'Apply Filters';
        failedToLoadEventDetails = 'Failed to load event details.';
        failedToCheckRegistrationStatus =
            'Failed to check registration status.';
        registrationSuccessful = 'Successfully registered for the event.';
        registrationFailed = 'Registration failed.';
        cancellationSuccessful = 'Successfully canceled your registration.';
        cancellationFailed = 'Cancellation failed.';
        appointmentDetails = 'Appointment Details';
        noEventDetails = 'No event details available.';
        cancelRegistration = 'Cancel Registration';
        registerForEvent = 'Register for Event';
        loginRequired = 'Login required to perform this action.';
        participants = 'Participants';
        eventDates = 'Event Dates';
        minParticipants = 'Min Participants';
        maxParticipants = 'Max Participants';
        currentParticipants = 'Current Participants';
        participantInfo = 'Participant Information';
    }
  }
}

class Language {
  String identifier = '';
  String icon = '';
  Language(this.identifier, this.icon);
}

final german = Language(
  'de',
  '🇩🇪',
);
final english = Language(
  'en',
  '🇬🇧',
);
final chinese = Language(
  'zh',
  '🇨🇳',
);
