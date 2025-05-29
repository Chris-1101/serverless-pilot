import json

def lambda_handler(event, context):
    # NOTE: the replace() is purely for the sake of readability in CloudWatch Logs
    print(f'Event object: { json.dumps(event, indent=4).replace("\n", "\r") }')
    print(f'Context: { context }')

    return {
        'statusCode': 200,
        'headers': { 'Access-Control-Allow-Origin': '*' },
        'body': json.dumps(event)
    }

