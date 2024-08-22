# Rain_Detection
Flutter & ESP32 Weather App
Overview
This project demonstrates a Flutter app that communicates with an ESP32 microcontroller. The ESP32 provides weather-related data, including its IP and MAC addresses, via a simple HTTP server. The Flutter app fetches this data and displays it.

Features
ESP32: Connects to Wi-Fi and serves IP and MAC address information via HTTP.
Flutter App: Fetches and displays data from the ESP32.
Setup
ESP32
Connect: Ensure the ESP32 is connected to your Wi-Fi network.
Configure: Set up the ESP32 to serve HTTP requests with its IP and MAC addresses.
Flutter App
Create Project: Initialize a new Flutter project.
Add Dependency: Include the http package in your pubspec.yaml file.
Configure: Update the app to fetch data from the ESP32’s IP address.
Running the Project
ESP32: Upload the code to the ESP32 and ensure it is connected to your network.
Flutter App: Run the Flutter app on your device or emulator.
Troubleshooting
ESP32 Issues: Verify Wi-Fi credentials and connection.
Flutter App Issues: Ensure the ESP32 IP address is correct and accessible.

