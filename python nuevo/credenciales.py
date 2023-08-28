import os
import io
import json
import time
from msrest.authentication import CognitiveServicesCredentials
from azure.cognitiveservices.vision.computervision import ComputerVisionClient
from azure.cognitiveservices.vision.computervision.models import OperationStatusCodes, VisualFeatureTypes
import requests # pip install request
from PIL import Image, ImageDraw, ImageFont

try:
    with open("credential.json", "r") as read_file:
        credential = json.load(read_file)
except FileNotFoundError:
    print("No se encontró 'credential.json'.")
except json.JSONDecodeError:
    print("'credential.json' no es un archivo JSON válido.")

API_KEY = credential['API_KEY']
ENDPOINT = credential['ENDPOINT']

cv_client = ComputerVisionClient(ENDPOINT, CognitiveServicesCredentials(API_KEY))

image_url = 'https://i.redd.it/oh-the-horror-v0-s2wtfchzkzbb1.jpg?s=13d023b6363567ab88c11b88cb23e67e5abc014b.jpg'
local_file = 'C:/Users/juanc/OneDrive/Documentos/proyecto final/Flow/oh-the-horror-v0-s2wtfchzkzbb1.jpg'
response = cv_client.read(url=image_url, Language='en', raw=True)

response = cv_client.read_in_stream(open(local_file, 'rb'), Language='en', raw=True)

print("Status code: ", response.status_code)
print("Headers: ", response.headers)


operationLocation = response.headers['Operation-Location']
operation_id = operationLocation.split('/')[-1]
time.sleep(5)
result =  cv_client.get_read_result(operation_id)

# print(result)
# print(result.status)
# print(result.analyze_result)

if result.status == OperationStatusCodes.succeeded:
    read_results = result.analyze_result.read_results
    for analyzed_result in read_results:
        for line in analyzed_result.lines:
            print(line.text)
            # for word in line.words:
            #     print('Words:')
            #     print(word.text)
            
image = Image.open(local_file)
if result.status == OperationStatusCodes.succeeded:
    read_results = result.analyze_result.read_results
    for analyzed_result in read_results:
        for line in analyzed_result.lines:
            x1, y1, x2, y2, x3, y3, x4, y4 = line.bounding_box
            draw = ImageDraw.Draw(image)
            draw.line(
                    ((x1, y1), (x2, y1), (x2, y2), (x3, y2), (x3, y3), (x4, y3), (x4, y4), (x1, y4), (x1, y1)),
                    fill=(255, 0, 0),
                    width=5
                ) 
            
image.show()
image.save('hand writing result.jpg')
