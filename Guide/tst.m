clear all;
a = arduino()
IN1 = 'D27';
IN2 = 'D26';
ENA = 'D14';

configurePin(a, IN1, 'DigitalOutput'); % IN1
configurePin(a, IN2, 'DigitalOutput'); % IN2
configurePin(a, ENA, 'PWM'); % ENA

writeDigitalPin(a, IN1, 1); % set IN1 to HIGH
writeDigitalPin(a, IN2, 0); % set IN2 to LOW
writePWMDutyCycle(a, ENA, 1); % set ENA to 100% duty cycle

 pause(3); % wait for 2 seconds

 writeDigitalPin(a, IN1, 1); % set IN1 to HIGH
writeDigitalPin(a, IN2, 0); % set IN2 to LOW
writePWMDutyCycle(a, ENA, 0.5); % set ENA to 100% duty cycle

% % writeDigitalPin(a, 'D14', 0); % set IN1 to LOW
% % writeDigitalPin(a, 'D27', 1); % set IN2 to HIGH
% % writePWMDutyCycle(a, 'D12', 0.5); % set ENA to 50% duty cycle
% % 
% % pause(2); % wait for 2 seconds
% % 
% % writeDigitalPin(a, 'D14', 0); % set IN1 to LOW
% % writeDigitalPin(a, 'D27', 0); % set IN2 to LOW
% % writePWMDutyCycle(a, 'D12', 0); % set ENA to 0% duty cycle (stop)
% 
pause (3)
clear all;
