# Edgetx_F5J_training_script
## Calculates score according to F5J rules.  

Simple telemetry script to calculate the score of an F5J training flight. The score is calculated as the flight time in seconds minus the launch height divided by two.  
Since this script is meant to fly alone (no time keeper assisting the pilot), the launch begins at the engine start insted of at model leaving the hand. The launch ends at the motor stop. The launch height is the maximum altitude reached within the 10 seconds following the end of the launch. The attempt ends when the protocol is disarmed, thus the pilot shoud disarm at touch town (yes, I fly expresslrs).  
The program does not take landing points into account, as it relies only on telemetry data.

<img width="262" height="132" alt="image" src="https://github.com/user-attachments/assets/e64061de-398a-4a8d-8a88-901db6611743" />
<img width="262" height="130" alt="image" src="https://github.com/user-attachments/assets/1258636d-50cc-4998-86af-a461c7da25f5" />
<img width="262" height="132" alt="image" src="https://github.com/user-attachments/assets/9cfad286-20e3-4e37-b358-96644441aa61" />
<img width="262" height="131" alt="image" src="https://github.com/user-attachments/assets/bbe65085-e194-439c-b825-06e3224e316b" />

## Program sequence
Armed AND motor off &emsp; ready &emsp; Model in your hand ready for tossing it.  
Armed AND motor on &emsp; launch &emsp; If time of this phase is bigger than 30 s, the score will be null. Beeps will warn 8 sec before.  
Armed AND motor off &emsp; gliging &emsp; The actual gliding phase.  
Disarmed AND motor off &emsp; landed &emsp; You have to stop the gliding phase by disarm (alt sensor is not precise enough to trigger the actual landing time)

## Usage
Download the file F5J.lua in your \SD\SCRIPTS\TELEMETRY folder
In your Edgetx model, go to Custom Screens, select Type script, choose F5J.  
Set the following logic switches in the EdgeTx model  
L3 arm/disarm  (I called it arm because I fly expresslrs, but the scritp doesn't care. You can set your own switch on L3 and call it land/ready)  
L5 motor on/off
  
Make sure you have a receiver with vario.
Go to telemetry page and find sensor [Alt]

Only b&w small screen 128x64  
