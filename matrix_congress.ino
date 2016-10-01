// testshapes demo for RGBmatrixPanel library.
// Demonstrates the drawing abilities of the RGBmatrixPanel library.
// For 32x64 RGB LED matrix.

// NOTE THIS CAN ONLY BE USED ON A MEGA! NOT ENOUGH RAM ON UNO!


bool inGame = false;

int locations[3][3][2] = {
  {{18,02}, {28,02}, {39,02}},
  {{18,12}, {28,12}, {39,12}},
  {{18,23}, {28,23}, {39,23}}
};

void drawX(int x, int y) {
  matrix.drawLine(locations[x][y][0],locations[x][y][1],locations[x][y][0]+6,locations[x][y][1]+6,matrix.Color333(7,0,0));
  matrix.drawLine(locations[x][y][0]+6,locations[x][y][1],locations[x][y][0],locations[x][y][1]+6,matrix.Color333(7,0,0));
}

void drawO(int x, int y) {
  matrix.drawCircle(locations[x][y][0]+3,locations[x][y][1]+3,3,matrix.Color333(0,7,0));
}

void checkGameState() {
  if(Serial.available()){
    int serin = Serial.parseInt();
    switch(serin) {
      case 0:
        inGame=false;
        break;
      case 1:
        inGame=true;
        break;
      case 2:
        drawX(0,0);
        break;
      case 3:
        drawX(0,1);
        break;
      case 4:
        drawX(0,2);
        break;
      case 5:
        drawX(1,0);
        break;
      case 6:
        drawX(1,1);
        break;
      case 7:
        drawX(1,2);
        break;
      case 8:
        drawX(2,0);
        break;
      case 9:
        drawX(2,1);
        break;
      case 10:
        drawX(2,2);
        break;
      case 11:
        drawO(0,0);
        break;
      case 12:
        drawO(0,1);
        break;
      case 13:
        drawO(0,2);
        break;
      case 14:
        drawO(1,0);
        break;
      case 15:
        drawO(1,1);
        break;
      case 16:
        drawO(1,2);
        break;
      case 17:
        drawO(2,0);
        break;
      case 18:
        drawO(2,1);
        break;
      case 19:
        drawO(2,2);
        break;
      case 20:
        matrix.fillScreen(0);
        matrix.setTextSize(2);
        matrix.setCursor(27,1);
        matrix.setTextColor(matrix.Color333(7,0,0));
        matrix.print("X");
        matrix.setCursor(10,17);
        matrix.setTextColor(matrix.Color333(0,7,7));
        matrix.print("wins");
        inGame = false;
        delay(4000);
        break;
      case 21:
        matrix.fillScreen(0);
        matrix.setTextSize(2);
        matrix.setCursor(27,1);
        matrix.setTextColor(matrix.Color333(0,7,0));
        matrix.print("O");
        matrix.setCursor(10,17);
        matrix.setTextColor(matrix.Color333(0,7,7));
        matrix.print("wins");
        inGame = false;
        delay(4000);
        break;
      case 22:
        pinMode(7, OUTPUT);digitalWrite(7, HIGH);
        break;
      case 23:
        matrix.fillScreen(0);
        matrix.setTextColor(matrix.Color333(7,7,0));matrix.setTextSize(2);matrix.setCursor(9,9);matrix.print("DRAW");
        inGame = false;
        delay(4000);
        break;
    }
  }
  delay(100);
}

void drawField() {
  matrix.fillScreen(0);
  matrix.drawRect(16,0,32,32,matrix.Color333(0,7,7));
  matrix.drawLine(26,0,26,32,matrix.Color333(0,7,7));
  matrix.drawLine(37,0,37,32,matrix.Color333(0,7,7));
  matrix.drawLine(16,10,47,10,matrix.Color333(0,7,7));
  matrix.drawLine(16,21,47,21,matrix.Color333(0,7,7));
}

String ips1, ips2, ips3, ips4;

void setup() {
  matrix.begin();
  Serial.begin(9600);
  Serial.setTimeout(2);
  matrix.setTextSize(1);
  matrix.setCursor(1,1);
  matrix.setTextColor(matrix.Color333(0,0,5));
  matrix.print("Waiting   for IP to be");
  matrix.setCursor(1,24);
  matrix.print("assigned");
  matrix.setCursor(51,17);
  matrix.setTextSize(2);
  matrix.setTextColor(matrix.Color333(5,1,0));
  matrix.print("4");
  while(!Serial.available());
  ips1 = Serial.readString();
  if(ips1=="!22") pinMode(7, OUTPUT);digitalWrite(7, HIGH);
  matrix.fillRect(51,17,matrix.width(),matrix.height(),0);
  matrix.setCursor(51,17);
  matrix.setTextColor(matrix.Color333(4,2,0));
  matrix.print("3");
  delay(5);
  while(!Serial.available());
  ips2 = Serial.readString();
  if(ips2=="!22") pinMode(7, OUTPUT);digitalWrite(7, HIGH);
  matrix.fillRect(51,17,matrix.width(),matrix.height(),0);
  matrix.setCursor(51,17);
  matrix.setTextColor(matrix.Color333(3,3,0));
  matrix.print("2");
  delay(5);
  while(!Serial.available());
  ips3 = Serial.readString();
  if(ips3=="!22") pinMode(7, OUTPUT);digitalWrite(7, HIGH);
  matrix.fillRect(51,17,matrix.width(),matrix.height(),0);
  matrix.setCursor(51,17);
  matrix.setTextColor(matrix.Color333(2,4,0));
  matrix.print("1");
  delay(5);
  while(!Serial.available());
  ips4 = Serial.readString();
  if(ips4=="!22") pinMode(7, OUTPUT);digitalWrite(7, HIGH);
  matrix.fillRect(51,17,matrix.width(),matrix.height(),0);
  matrix.setCursor(51,17);
  matrix.setTextColor(matrix.Color333(1,5,0));
  matrix.print("0");
  delay(3000);
  matrix.fillRect(0,0,matrix.width(),matrix.height(),matrix.Color333(0,0,5));
  matrix.fillRect(0,0,matrix.width(),matrix.height(),0);
}

void loop() {
  int ningamec = 1;
  while(!inGame){
    switch((int)(ningamec/10)) {
      case 0:
        if(ningamec%10==1){matrix.fillScreen(0);}
        matrix.setTextColor(matrix.Color333(7,7,0));matrix.setTextSize(2);matrix.setCursor(9,9);matrix.print("PLAY");checkGameState();
        ningamec++;
        break;
      case 1:
        if(ningamec%10==0){matrix.fillScreen(0);}
        matrix.setTextColor(matrix.Color333(7,7,0));matrix.setCursor(15,9);matrix.print("TIC");checkGameState();
        ningamec++;
        break;
      case 2:
        if(ningamec%10==0){matrix.fillScreen(0);}
        matrix.setTextColor(matrix.Color333(7,7,0));matrix.setCursor(15,9);matrix.print("TAC");checkGameState();
        ningamec++;
        break;
      case 3:
        if(ningamec%10==0){matrix.fillScreen(0);}
        matrix.setTextColor(matrix.Color333(7,7,0));matrix.setCursor(15,9);matrix.print("TOE");checkGameState();
        ningamec++;
        break;
      case 4:
        if(ningamec%10==0){matrix.fillScreen(0);}
        matrix.setTextSize(2);matrix.setTextColor(matrix.Color333(7,3,0));matrix.setCursor(0,1);matrix.print("tel  net");matrix.setTextColor(matrix.Color333(3,7,0));matrix.setTextSize(1);
        matrix.setCursor(40,1); matrix.print(ips1);
        matrix.setCursor(40,9); matrix.print(ips2);
        matrix.setCursor(40,17);matrix.print(ips3);
        matrix.setCursor(40,25);matrix.print(ips4);
        checkGameState();
        ningamec++;
        break;
      case 5:
        matrix.setTextSize(2);matrix.setTextColor(matrix.Color333(7,3,0));matrix.setCursor(0,1);matrix.print("tel  net");matrix.setTextColor(matrix.Color333(3,7,0));matrix.setTextSize(1);
        matrix.setCursor(40,1); matrix.print(ips1);
        matrix.setCursor(40,9); matrix.print(ips2);
        matrix.setCursor(40,17);matrix.print(ips3);
        matrix.setCursor(40,25);matrix.print(ips4);
        checkGameState();
        ningamec++;
        break;
      case 6:
        matrix.setTextSize(2);matrix.setTextColor(matrix.Color333(7,3,0));matrix.setCursor(0,1);matrix.print("tel  net");matrix.setTextColor(matrix.Color333(3,7,0));matrix.setTextSize(1);
        matrix.setCursor(40,1); matrix.print(ips1);
        matrix.setCursor(40,9); matrix.print(ips2);
        matrix.setCursor(40,17);matrix.print(ips3);
        matrix.setCursor(40,25);matrix.print(ips4);
        checkGameState();
        ningamec++;
        break;
      case 7:
        ningamec=1;
        break;
    }
  }

  while(inGame){
    drawField();
    while(inGame){
      checkGameState();
      delay(5);
    }
  }
  
}
