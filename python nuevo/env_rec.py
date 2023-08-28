import socket

def enviar_mensaje(mensaje):
    # Crear un objeto de socket TCP/IP en Python
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # Conectar al servidor MATLAB
    sock.connect(('localhost', 4000))

    while True:
        # Esperar la entrada del usuario
        entrada = input("Ingresa 'start' para enviar el mensaje ('q' para salir): ")
        
        if entrada.lower() == 'start':
            # Enviar el mensaje al servidor MATLAB
            message = mensaje.encode('utf-8')
            sock.sendall(message)

            # Recibir la respuesta del servidor MATLAB
            response = sock.recv(1024).decode('utf-8')
            print(response)
        
        elif entrada.lower() == 'q':
            # Salir del bucle si se ingresa 'q'
            break

    # Cerrar el objeto de socket
    sock.close()

# Pedir al usuario que ingrese el mensaje
mensaje = input("ingresa el mensaje ")
# Llamar a la función enviar_mensaje con el mensaje ingresado por teclado
enviar_mensaje(mensaje)

