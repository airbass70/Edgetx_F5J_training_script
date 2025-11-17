# Edgetx_F5J_training_script
## Calculates score according to F5J rules.
Telemetry script to calculate the score of an F5J training flight. The score corresponds to the flight time in second minus the launch height divided by two.
When operating alone (no time keeper assisting the pilot), the launch begins at the engine start insted of at model leaving the hand. The launch ends at the motor stop. The launch height is the maximum altitude reached in the 10 seconds following the end of the launch. The flight ends when the protocol is disarmed, thus the pilot shoud disarm when touching town (yes, I fly expresslrs). The program does not take landing points into account, as it relies only on telemetry data.

<img width="262" height="132" alt="image" src="https://github.com/user-attachments/assets/e64061de-398a-4a8d-8a88-901db6611743" />
<img width="262" height="130" alt="image" src="https://github.com/user-attachments/assets/1258636d-50cc-4998-86af-a461c7da25f5" />
<img width="262" height="132" alt="image" src="https://github.com/user-attachments/assets/9cfad286-20e3-4e37-b358-96644441aa61" />
<img width="262" height="131" alt="image" src="https://github.com/user-attachments/assets/bbe65085-e194-439c-b825-06e3224e316b" />

## Program sequence
Armed AND motor off     is READY  
Armed AND motor on      is LAUNCH  
Armed AND motor off     is GLIDING  
Disarmed AND motor off  is LANDED

