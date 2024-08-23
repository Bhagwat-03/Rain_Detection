#include <WiFi.h>
#include <HTTPClient.h>

const char* ssid = "G15";
const char* password = "FightClub";
const String weatherApiKey = "your_weather_api_key";
const String city = "Bengaluru";
const String weatherUrl = "http://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=" + weatherApiKey + "&units=metric";

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
  }

  Serial.println("Connected to WiFi");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  checkWeather();
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    WiFiServer server(80);
    server.begin();
    WiFiClient client = server.available();

    if (client) {
      String request = client.readStringUntil('\r');
      client.flush();
      if (request.indexOf("/open") != -1) {
        handleOpen();
      } else if (request.indexOf("/close") != -1) {
        handleClose();
      }
      client.println("HTTP/1.1 200 OK");
      client.println("Content-Type: text/plain");
      client.println("Connection: close");
      client.println();
      client.stop();
    }
  }

  static unsigned long lastWeatherCheck = 0;
  if (millis() - lastWeatherCheck > 3600000) {
    lastWeatherCheck = millis();
    checkWeather();
  }
}

void checkWeather() {
  HTTPClient http;
  http.begin(weatherUrl);
  int httpCode = http.GET();
  
  if (httpCode > 0) {
    String payload = http.getString();
    if (payload.indexOf("Rain") != -1) {
      handleRain();
    }
  }
  
  http.end();
}

void handleOpen() {
  Serial.println("Received open command");
}

void handleClose() {
  Serial.println("Received close command");
}

void handleRain() {
  Serial.println("It is raining. Activating rain protection...");
}
