# Edgetx_F5J_training_script
## Calculates score according to F5J rules.
Telemetry script to calculate the score of an F5J training flight. The score corresponds to the flight seconds minus the launch height divided by two.
When operating alone (no time keeper assisting), the launch begins at the engine start insted of at model leaving the hand. The launch ends at the engine stop. The launch height is the maximum reached in the 10 seconds following the end of the launch. The flight ends when the protocol is disarmed. The program does not take landing points into account, as it relies only on telemetry
