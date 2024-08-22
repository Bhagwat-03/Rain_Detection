#include <WiFi.h>

const char* ssid = "G15";       // Replace with your Wi-Fi network name
const char* password = "FightClub"; // Replace with your Wi-Fi password

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }

  Serial.println("Connected to WiFi");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP()); // Prints the IP address of ESP32
}

void loop() {
  // Your main code here
}