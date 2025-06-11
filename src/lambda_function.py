import json
import math
import boto3
import time

def lambda_handler(event, context):

    sensorId = event['sensor_id']
    resistance = event['value']
    
    try:
        checkResistanceOf(sensorId, resistance)
    except Exception as e:
        return {
            'error': str(e)
        }

    temperatureCelcious = calculateTemperature(resistance)
    response = makeResponse(temperatureCelcious, event)

    send_message_to_sqs(response)

    return response

def calculateTemperature(value: float):
    a = 1.4e-3
    b = 2.37e-4
    c = 9.9e-8

    temperature = 1 / (a + b * math.log(value) + c * (math.log(value))**3)
    temperatureCelcious = temperature - 273.15

    return temperatureCelcious

def makeResponse(temperature, event_data):
    response = {
        'sensor_id': event_data['sensor_id'],
        'location_id': event_data['location_id'],
        'temperature': temperature,
        'timestamp': event_data['timestamp']
    }

    if temperature < 20.0:
        response["status"] = "TEMPERATURE.TOO.LOW"
    elif temperature >= 20.0 and temperature < 100.0:
        response["status"] = "OK"
    elif temperature >= 100.0 and temperature < 250.0:
        response["status"] = "TEMPERATURE.TOO.HIGH"
    else:
        response["status"] = "TEMPERATURE.CRITICAL"
        # sendNotification(response['status'])

    return response

def readSecrets(secret_name):
    ssm_client = boto3.client('ssm')
    response = ssm_client.get_parameter(
        Name=secret_name,
        WithDecryption=True
    )
    print(f"Secret name: {secret_name} value: {response["Parameter"]["Value"]}")

def sendNotification(message):
    sns = boto3.client('sns')
    topicARN = "arn:aws:sns:us-east-1:833677752285:LambdaEventsTopic"

    sns.publish(
        TopicArn=topicARN,
        Message=message
    )

def checkResistanceOf(sensorId, value):
    if value < 1.0 or value > 2*10e4:
        # putSensorToDB(sensorId, True)
        raise ValueError("VALUE.OUT.OF.RANGE")
    else:
        pass
        # putSensorToDB(sensorId, False)

def putSensorToDB(sensorId, isFailed):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('Sensor_Failure')

    table.put_item(
        Item={
            'sensor_id': sensorId,
            'status': isFailed
        }
    )

def send_message_to_sqs(message):
    sqs = boto3.client('sqs')
    queue_url = "https://sqs.us-east-1.amazonaws.com/833677752285/SensorDataQueue"

    sqs.send_message(
        QueueUrl=queue_url,
        MessageBody=json.dumps(message)
    )