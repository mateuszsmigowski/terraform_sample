import json

def lambda_handler(event, context):
    """
    Prosta funkcja Lambda, która zwraca powitanie.
    """
    print("Lambda została wywołana!")
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda deployed with Terraform!')
    }