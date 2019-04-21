float em; //tamanho de módulo
Canvas canvas; //área do app
PlayArea playArea; //área do jogo
Time time;
Player[] p;
FoodGenerator foodGenerator = new FoodGenerator();
Food[] foods;
Terrain terrain;
Borders borders;
Game game;
Menu menu;
Transition transition;
int currentScreen;

PFont font, fontBig, fontSmall, fontSmaller;
PFont bold, boldBig;

MultiTouchControls multiTouchControls;
int maxTouches = 10; //maximum number of touches at the same time
int[] prevTouchesId = new int[maxTouches];
float[] prevTouchesX = new float[maxTouches];
float[] prevTouchesY = new float[maxTouches];

int numberOfPlayers;

//boolean playing = false;
boolean mouseReleased = false;
boolean debug = false;

JSONObject text, textEN, textPT;

void setup() {
  //size(800, 450); // <================================================ APENAS WIN
  //fullScreen(2); // <================================================ APENAS WIN
  fullScreen(); // <================================================ APENAS ANDROID
  //noSmooth(); // <================================================ APENAS ANDROID
  //frameRate(30);
  //orientation(LANDSCAPE); // <================================================ APENAS ANDROID
  //Context context = getContext(); // <================================================ APENAS ANDROID

  //noCursor();

  //File audio = loadFile();
  //MediaPlayer.create(context, audio);

  canvas = new Canvas(16/9.0); //ratio of canvas 16:9
  em = canvas.h/25; //size of modulo
  time = new Time();
  foods = new Food[20]; //max number of foods at the same time

  currentScreen = 0;
  numberOfPlayers = 1;

  font = createFont("Roboto-Bold.ttf", em);
  fontBig = createFont("Roboto-Bold.ttf", 3*em);
  fontSmall = createFont("Roboto-Bold.ttf", em*2/3);
  fontSmaller = createFont("Roboto-Bold.ttf", em/2);  
  bold = createFont("TitanOne-Regular.ttf", 1.5*em);
  boldBig = createFont("TitanOne-Regular.ttf", 3.5*em*(2.5/2));

  //textEN = loadJSONObject("textEN.json");
  textPT = loadJSONObject("textPT.json");

  //String language = "";
  //if (android.os.Build.VERSION.SDK_INT < 24) {
  //  language = context.getResources().getConfiguration().locale.toString();
  //} else {
  //  language = context.getResources().getConfiguration().getLocales().get(0).getLanguage();
  //}

  //if(language.length() >= 2) {
  //  language = language.substring(0, 2);
  //  language = language.toLowerCase();
  //}

  //if (language.equals("pt")) {
  //  text = textPT; //português
  //} else {
  //  text = textEN; //inglês
  //}

  text = textPT; //português

  menu = new Menu();
  transition = new Transition();

  game = new Game();

  multiTouchControls = new MultiTouchControls();

  //String packageName = context.getPackageName();
  //String versionCode = "";
  //try {
  //  versionCode = context.getPackageManager().getPackageInfo(packageName, 0).versionName;
  //} 
  //catch (PackageManager.NameNotFoundException e) {
  //  e.printStackTrace();
  //}
}

void draw() {
  //background(lightBlue);
  time.update();

  int screenIndex = 0; //contador de telas

  if (currentScreen == screenIndex) {
    menu.home();
  }
  screenIndex++;

  if (currentScreen == screenIndex) {
    menu.selectNumberOfPlayers();
  }
  screenIndex++;

  if (currentScreen == screenIndex) { //Início do Jogo em si
    game.update();
  } // fim do jogo em si

  //canvas.debug();
  //canvas.grid();
  //time.debug();

  //Debug framerate
  String fpsBar = "";
  for (int i = 0; i < 60; i++) {
    if (i < frameRate) {
      fpsBar = fpsBar + "|";
    } else {
      fpsBar = fpsBar + ".";
    }
  }
  println(fpsBar, nf(frameRate, 2, 6));

  //transition.display();

  //Debug Scores Wet
  //if(playing) {
  //  println(nf(p[0].score, 1, 2), nf(p[1].score, 1, 2));
  //}

  if (currentScreen == 2) {
    noCursor();
    if (mousePressed) {
      float size = em/2 + sin(time.realFrameCount * 0.2) * em/10;
      noStroke();
      fill(lightGrey);
      ellipse(mouseX, mouseY, size, size);
    } else {
      noStroke();
      fill(lightGrey);
      ellipse(mouseX, mouseY, em/3, em/3);
    }
  } else {
    cursor();
  }

  mouseReleased = false;
}

void mouseReleased() {
  mouseReleased = true;
}
