clear, clc;
% Crear un objeto de socket TCP/IP en MATLAB
t = tcpip('localhost', 5555, 'NetworkRole', 'server');
% Establecer el tamaño del búfer de lectura
t.InputBufferSize = 1024;
% Establecer el tiempo de espera
t.Timeout = 60;  % Por ejemplo, establecer un tiempo de espera de 60 segundos
% Abrir el objeto de socket
fopen(t);

while true
    % Esperar la entrada del usuari
    entrada = input('Ingresa una letra ("x" para recibir, "q" para salir): ','s');
    
    if strcmp(entrada, 'x')
        % Recibir el mensaje desde Python
        message = fread(t, t.BytesAvailable);
        receivedMessage = char(message)';
        disp(receivedMessage);
        
        % Esperar a recibir una nueva entrada antes de recibir el siguiente mensaje
        pause;  % Esperar hasta que se ingrese una nueva entrada
    elseif strcmp(entrada, 'q')
        % Salir del bucle si se ingresa 'q'
        break;
    end
end

% Cerrar el objeto de socket
fclose(t);
