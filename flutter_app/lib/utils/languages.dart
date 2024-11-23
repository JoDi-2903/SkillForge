

class AppStrings{
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
  static String resetPassword  = 'Reset password';

  static void refreshLanguage(String language){
    switch (language){
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
        resetPassword  = 'Passwort zurücksetzten';
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
        resetPassword  = '重設密碼';
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
        resetPassword  = 'Reset password';
    }
  }
}

class Language{
  String identifier = '';
  String icon = '';
  Language(this.identifier, this.icon);
}

final german = Language('de','🇩🇪',);
final english = Language('en','🇬🇧',);
final chinese = Language('zh','🇨🇳',);
