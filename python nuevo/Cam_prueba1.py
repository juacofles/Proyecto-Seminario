import cv2

cap = cv2.VideoCapture(0)# Crear el objeto camara con el que se va a tomar los videos

leido, frame = cap.read()

if leido == True:
	cv2.imwrite("foto.png", frame)
	print("Foto tomada correctamente")
else:
	print("Error al acceder a la cámara")

"""
	Finalmente liberamos o soltamos la cámara
"""
cap.release()
    
#Liberar el recurso de la camara
cap.release()
cv2.destroyAllWindows()