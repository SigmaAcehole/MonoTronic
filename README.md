# MonoTronic
MonoTronic is a vehicle safety solution aimed at resolving some common issues that has proved to be fatal to the passengers in the vehicle in past. MonoTronic comes with an  embedded solution that will automate the mode of operation of a vehicle's AC to maintain a healthy concentration of CO and CO2 inside the vehicle cabin, and an android app that will help establishing driver awareness by displaying sensor data from the vehicle interior as well as some useful instructions.
For detailed explanation of the project, please refer to the "Monotronic Explanation.pdf" file.

The repository contains files for the embedded program, simulation files and the android app.

![image](https://user-images.githubusercontent.com/61357812/125895779-184e1da6-9024-403f-94ec-8a595b44b7aa.png)

# Embedded solution 
The embedded solution aims to exploit the HVAC of the car and expand existing automatic climate control technology by adding an automatic air quality control system which will attempt to maintain a safe concentration of gases like carbon monoxide and carbon dioxide inside the car cabin.

## Solution Block Diagram
![image](https://user-images.githubusercontent.com/61357812/125896372-b727e7a3-612d-414c-98d6-e0f50291e6bc.png)

## Simulation
C code for an ATmega16M1 chip was written and compiled using MikroC development tool. Proteus was used to simulate various test cases. 

![image](https://user-images.githubusercontent.com/61357812/125896551-96d0109d-8fdd-49dc-bb07-183eb2c86dc2.png)

# Android App
The android app i.e MonoTronic Automata provides the user with a simple to understand user interface to monitor the state of their vehicle. During danger levels of various parameters(temperature and gas concentration) detected, the app will provide users with suggestive measures to guide them to safety. 

![image](https://user-images.githubusercontent.com/61357812/125896747-06215ab1-54df-4697-883f-9da7b6361cd1.png)

Concerning to increased cases of vehicular heatstroke, most of which being caused by unawareness of people, the temperature prediction chart provides a useful way to protect the user’s health and belongings. It uses an Inside Car Temperature Calculator to estimate the interior cabin temperature upto 1 hour in future based on current interior temperature value. The predicted values may not be precise but will help the user to decide whether to park the car at a certain spot and leave their belongings inside. 

![image](https://user-images.githubusercontent.com/61357812/125896774-92d549ab-96ab-49a6-bd6f-af7e183f0cdb.png)
