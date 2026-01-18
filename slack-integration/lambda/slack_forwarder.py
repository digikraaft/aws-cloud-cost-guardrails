import json
import urllib3
import os

http = urllib3.PoolManager()

def lambda_handler(event, context):
    slack_webhook_url = os.environ.get('SLACK_WEBHOOK_URL')
    if not slack_webhook_url:
        return {'statusCode': 400, 'body': 'SLACK_WEBHOOK_URL not configured'}

    for record in event.get('Records', []):
        sns_message = record.get('Sns', {}).get('Message', 'No message content')
        subject = record.get('Sns', {}).get('Subject', 'Cloud Cost Alert')
        
        # Simple Slack message formatting
        slack_message = {
            "text": f"*{subject}*",
            "attachments": [
                {
                    "color": "#ff0000",
                    "text": sns_message
                }
            ]
        }
        
        encoded_message = json.dumps(slack_message).encode('utf-8')
        resp = http.request('POST', slack_webhook_url, body=encoded_message, headers={'Content-Type': 'application/json'})
        
        print(f"Slack response: {resp.status}, {resp.data}")

    return {'statusCode': 200, 'body': 'Alerts forwarded to Slack'}
