
void debugFrameRate() {
  String fpsBar = "";
  for (int i = 0; i < 60; i++) {
    if (i < frameRate) {
      fpsBar = fpsBar + "|";
    } else {
      fpsBar = fpsBar + ".";
    }
  }
  println(fpsBar, nf(frameRate, 2, 6));
}

String getLanguage() {
  String language = "pt";
  
  // =========================================================================APENAS ANDROID (6 FIM) VVV
  if (android.os.Build.VERSION.SDK_INT < 24) {
    language = context.getResources().getConfiguration().locale.toString();
  } else {
    language = context.getResources().getConfiguration().getLocales().get(0).getLanguage();
  }

  if(language.length() >= 2) {
    language = language.substring(0, 2);
    language = language.toLowerCase();
  }
  // =========================================================================APENAS ANDROID ^^^
  
  return language;
}

String getAppVersion() {
  //Context context = getContext();
  
  //String packageName = context.getPackageName();

  String appVersion = "";
  //try {
  //  appVersion = context.getPackageManager().getPackageInfo(packageName, 0).versionName;
  //} 
  //catch (PackageManager.NameNotFoundException e) {
  //  e.printStackTrace();
  //}
  
  return appVersion;
}
