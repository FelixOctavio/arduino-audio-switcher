#include <HID-Project.h>
#include <OneButton.h>
#include <EEPROM.h>

// Rotary Encoder Inputs
#define CLK 16
#define DT 14
#define SW 15

// Variables to debounce Rotary Encoder
unsigned long TimeOfLastDebounce = 0;
float DelayofDebounce = 1;

// Store previous Pins state
int PreviousCLK;
int PreviousDATA;

// Volume tiap mode
int HeadphoneVol;
int SpeakerVol;
int CurrentVol;

int CurrentVolMode;
int CurrentMode; // 1 = Headphone 2 = Speaker
int LoopVol;
int LoopState;
String LoopMode;

String input;

// setup a new OneButton on SW
OneButton button(SW, true); // normal LOW, set to true for normal HIGH

unsigned int integerValue = 0; // Max value is 65535
char incomingByte;

void setup() {
  if (EEPROM.read(1) > 100) {
    EEPROM.update(1, 0); //Set volume headphone 0 jika tidak ada history
  } else if (EEPROM.read(2) > 100) {
    EEPROM.update(2, 0); //Set Volume speaker 0 jika tidak ada history
  } else if (EEPROM.read(3) > 100) {
    EEPROM.update(3, 1); //Set Mode ke Headphone Jika tidak ada history
  }

  LoopVol = 0; //Jumlah Selisih
  LoopState = 0; //0 = Tidak ada Selisih | 1 = Ada Selisih (Perlu Jalankan Loop)
  HeadphoneVol = EEPROM.read(1); //Headphone Vol
  SpeakerVol = EEPROM.read(2); //Speaker Vol
  CurrentMode = EEPROM.read(3); //Check Mode Terakhir

if (CurrentMode == 1) {
  digitalWrite(10, LOW);
} else if (CurrentMode == 2) {
  digitalWrite(10, HIGH);
}
  
  CurrentVolMode = 0;

  // Put current pins state in variables
  PreviousCLK = digitalRead(CLK);
  PreviousDATA = digitalRead(DT);


  // Set encoder pins as inputs
  pinMode(CLK, INPUT);
  pinMode(DT, INPUT);
  pinMode(SW, INPUT_PULLUP); // Encoder click set Pull-Up

  //configure pin 10 Output
  pinMode(10, OUTPUT);

  //start serial connection
  Serial.begin(9600);

  // link myClickFunction to a click event
  button.attachClick(muteFunction);
  // link myDoubleClickFunction to a doubleclick event
  button.attachDoubleClick(switchFunction);
  // Single click timing
  button.setClickTicks(125);

  // Initialize Consumer API
  Consumer.begin();

}

void loop() {

  button.tick();

  //Serial.println(Serial.availableForWrite());

  // If enough time has passed check the rotary encoder
  if ((millis() - TimeOfLastDebounce) > DelayofDebounce) {
    check_rotary();  // Rotary Encoder check routine below

    PreviousCLK = digitalRead(CLK);
    PreviousDATA = digitalRead(DT);

    TimeOfLastDebounce = millis(); // Set variable to current millis() timer
  }

  if (Serial.available() > 0) {
    input = Serial.readStringUntil('\n');

    if (input.equals("System Vol")) {
      currentVol();
      Serial.println(CurrentVol);
    } else if (input.equals("Current Vol")) {
      CurrentVolMode = 1;
      currentVol();

      if (CurrentMode == 1) {
        HeadphoneVol = CurrentVol;
      } else if (CurrentMode == 2) {
        SpeakerVol = CurrentVol;
      }
      Serial.println(CurrentVol);
      CurrentVolMode = 0;
    } else if (input == ("Headphone") || ("Speaker")) {
      switchMode();
    } else if (input.equals("Headphone Vol")) {
      CurrentVolMode = 1;
      currentVol();
      HeadphoneVol = CurrentVol;
    } else if (input.equals("Speaker Vol")) {
      CurrentVolMode = 1;
      currentVol();
      SpeakerVol = CurrentVol;
    }
  }
}

void volume_loop() {
  if (LoopState == 1) {
    //Serial.print("Loop: ");
    LoopState = 0;
  }
  if (LoopVol != 0) {
    //Serial.print(LoopVol);
    //Serial.print(", ");
    if (LoopMode == "Up") {
      volume_up();
    } else if (LoopMode == "Down") {
      volume_down();
    }
  }
}

void volume_up() {
  delay(55);
  volume_upFunction();
}

void volume_down() {
  delay(55);
  volume_downFunction();
}

void volume_upFunction() {
  Consumer.write(MEDIA_VOL_UP);
  if (CurrentMode == 1) {
    if (LoopVol != 0) {
      LoopVol--;
      volume_loop();
    } else {
      headphoneVol_Up();
    }
  } else if (CurrentMode == 2) {
    if (LoopVol != 0) {
      LoopVol--;
      volume_loop();
    } else {
      speakerVol_Up();
    }
  }
}

void volume_downFunction() {
  Consumer.write(MEDIA_VOL_DOWN);
  if (CurrentMode == 1) {
    if (LoopVol != 0) {
      LoopVol--;
      volume_loop();
    } else {
      headphoneVol_Down();
    }
  } else if (CurrentMode == 2) {
    if (LoopVol != 0) {
      LoopVol--;
      volume_loop();
    } else {
      speakerVol_Down();
    }
  }
}

void headphoneVol_Up() {
  if (HeadphoneVol < 100) {
    HeadphoneVol++;
  }
  //Serial.print("Headphone Volume Up ");
  //Serial.println(HeadphoneVol);
  EEPROM.update(1, HeadphoneVol);
}

void headphoneVol_Down() {
  if (HeadphoneVol > 0) {
    HeadphoneVol--;
  }
  //Serial.print("Headphone Volume Down ");
  //Serial.println(HeadphoneVol);
  EEPROM.update(1, HeadphoneVol);
}

void speakerVol_Up() {
  if (SpeakerVol < 100) {
    SpeakerVol++;
  }
  //Serial.print("Speaker Volume Up ");
  //Serial.println(SpeakerVol);
  EEPROM.update(2, SpeakerVol);
}

void speakerVol_Down() {
  if (SpeakerVol > 0) {
    SpeakerVol--;
  }
  //Serial.print("Speaker Volume Down ");
  //Serial.println(SpeakerVol);
  EEPROM.update(2, SpeakerVol);
}

// Check if Rotary Encoder was moved
void check_rotary() {

  if ((PreviousCLK == 0) && (PreviousDATA == 1)) {
    if ((digitalRead(CLK) == 1) && (digitalRead(DT) == 1)) {
      volume_down();
    }
  }

  if ((PreviousCLK == 0) && (PreviousDATA == 0)) {
    if ((digitalRead(CLK) == 1) && (digitalRead(DT) == 0)) {
      volume_up();
    }
  }
}

void headphoneSwitch() {
  if (digitalRead(10) == HIGH) {
    digitalWrite(10, LOW);
    CurrentVol = EEPROM.read(CurrentMode);
    CurrentMode = 1;
    vol_calc();
  }
  //currentVol(); //Check Volume di sistem
  //Serial.println("Audio Routed to Headphone");
}

void speakerSwitch() {
  if (digitalRead(10) == LOW) {
    digitalWrite(10, HIGH);
    CurrentVol = EEPROM.read(CurrentMode);
    CurrentMode = 2;
    vol_calc();
  }
  //currentVol(); //Check Volume di sistem
  //Serial.println("Audio Routed to Speaker");
}

// this function will be called when the button was pressed 2 times in a short timeframe.
void muteFunction() {
  //Serial.println("Single Click");
  Consumer.write(MEDIA_VOL_MUTE);
}

void switchFunction() {
  //Serial.println("Double Click");
  if (digitalRead(10) == HIGH) {
    headphoneSwitch();
  } else if (digitalRead(10) == LOW) {
    speakerSwitch();
  }
}

void currentVol() {
  integerValue = 0;         // throw away previous integerValue
  while (1) {           // force into a loop until 'n' is received
    incomingByte = Serial.read();
    if (incomingByte == '\n') break;   // exit the while(1), we're done receiving
    if (incomingByte == -1) continue;  // if no characters are in the buffer read() returns -1
    integerValue *= 10;  // shift left 1 decimal place
    // convert ASCII to integer, add, and shift left 1 decimal place
    integerValue = ((incomingByte - 48) + integerValue);
  }
  CurrentVol = integerValue;
  if (CurrentVolMode != 1) {
    vol_calc();
  }
}

void vol_calc() {
  LoopState = 1;
  EEPROM.update(3, CurrentMode);
  
  if (CurrentMode == 1) {
    LoopVol = CurrentVol - HeadphoneVol;
//    Serial.print("Current Vol: ");
//    Serial.print(CurrentVol);
//    Serial.print(", ");
//    Serial.print("Headphone Vol: ");
//    Serial.print(HeadphoneVol);
//    Serial.print(", ");
//    Serial.print("Loop Vol: ");
//    Serial.print(LoopVol);
//    Serial.print(", ");

    if (LoopVol < 0) {
      //Serial.println("Up");
      LoopVol = LoopVol * -1;
      LoopMode = "Up";
      volume_loop();
    } else if (LoopVol > 0 ) {
      LoopMode = "Down";
      //Serial.println("Down");
      volume_loop();
    }
  } else if (CurrentMode == 2) {
    LoopVol = CurrentVol - SpeakerVol;
//    Serial.print("Current Vol: ");
//    Serial.print(CurrentVol);
//    Serial.print(", ");
//    Serial.print("Speaker Vol: ");
//    Serial.print(SpeakerVol);
//    Serial.print(", ");
//    Serial.print("Loop Vol: ");
//    Serial.print(LoopVol);
//    Serial.print(", ");

    if (LoopVol < 0) {
      LoopVol = LoopVol * -1;
      LoopMode = "Up";
      //Serial.println("Up");
      volume_loop();
    } else if (LoopVol > 0 ) {
      LoopMode = "Down";
      //Serial.println("Down");
      volume_loop();
    }
  }
  LoopState = 0;
//  Serial.println("Done");
}

void switchMode() {
  if (input == "Headphone") {
    headphoneSwitch();
  } else if (input == "Speaker")
    speakerSwitch();
}
