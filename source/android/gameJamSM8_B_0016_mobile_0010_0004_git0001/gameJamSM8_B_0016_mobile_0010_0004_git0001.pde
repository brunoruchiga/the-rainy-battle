String gameVersion = "v.0.4.3 ALPHA";

// =========================================================================APENAS ANDROID (1) VVV
import android.content.Context;
import android.app.Activity;
Context context;
Activity activity;
// =========================================================================APENAS ANDROID ^^^

//import android.media.MediaPlayer;
//MediaPlayer mediaPlayer;

//Constants
int SEC = 60; //1 second in default frames

Time time;
Canvas canvas; //área do app
float em; //tamanho de módulo global
Screens screens;
int currentScreen;
Game game;
PlayArea playArea; //área do jogo
Terrain terrain;
VisibleAreaWithBorders borders;
Player[] p;
FoodGenerator foodGenerator = new FoodGenerator();
Food[] foods;

PFont font, fontBig, fontSmall, fontSmaller;
PFont bold, boldBig;

MultiTouchControls multiTouchControls;
int maxTouches = 10; //maximum number of touches at the same time
int[] prevTouchesId = new int[maxTouches];
float[] prevTouchesX = new float[maxTouches];
float[] prevTouchesY = new float[maxTouches];

int numberOfPlayers;

boolean mouseReleased = false;
boolean debug = false;

JSONObject text, textEN, textPT;

void setup() {
  //size(800, 450); // <================================================ APENAS WIN (A)
  
  // =========================================================================APENAS ANDROID (2) VVV
  fullScreen();
  noSmooth();
  orientation(LANDSCAPE);
  context = getContext();
  activity = getActivity();
  // =========================================================================APENAS ANDROID ^^^

  time = new Time();
  canvas = new Canvas(16/9.0); //ratio of canvas 16:9
  em = canvas.h/20;
  screens = new Screens();
  currentScreen = 0;
  game = new Game();
  
  font = createFont("Roboto-Bold.ttf", em);
  fontBig = createFont("Roboto-Bold.ttf", 3*em);
  fontSmall = createFont("Roboto-Bold.ttf", em*2/3);
  fontSmaller = createFont("Roboto-Bold.ttf", em/2);  
  bold = createFont("TitanOne-Regular.ttf", 1.5*em);
  boldBig = createFont("TitanOne-Regular.ttf", 3.5*em);

  textEN = loadJSONObject("textEN.json");
  textPT = loadJSONObject("textPT.json");
  
  if (getLanguage().equals("pt")) {
    text = textPT; //português
  } else {
    text = textEN; //inglês (padrão)
  }
  
  //File audio = loadFile();
  //MediaPlayer.create(context, audio);
}

void draw() {
  time.update();

  int screenIndex = 0; //contador de telas
  if (currentScreen == screenIndex) {screens.home();} screenIndex++;
  if (currentScreen == screenIndex) {screens.selectNumberOfPlayers();} screenIndex++;
  if (currentScreen == screenIndex) {game.run();} // Jogo em si

  //currentScreen = -1; //for debug
  //debugArt();
  //debugColors();

  //transition.display();

  //Debug
  //canvas.debug();
  //canvas.grid();
  //time.debug();
  //debugFrameRate();

  mouseReleased = false;
}

void mouseReleased() {
  mouseReleased = true;
}
