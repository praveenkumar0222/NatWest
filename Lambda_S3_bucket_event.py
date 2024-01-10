import json
import boto3

def lambda_handler(event, context):
    s3_bucket = event['Records'][0]['s3']['bucket']['name']
    s3_object_key = event['Records'][0]['s3']['object']['key']
    
    cloudwatch_logs = boto3.client('logs')
    
    log_group_name = '/aws/lambda/S3ObjectCreatedLog'
    log_stream_name = 'S3ObjectCreatedLogStream'
    log_message = f"S3 Object Created - Bucket: {s3_bucket}, Object Key: {s3_object_key}"
    
    response = cloudwatch_logs.create_log_group(logGroupName=log_group_name)
    response = cloudwatch_logs.create_log_stream(logGroupName=log_group_name, logStreamName=log_stream_name)
    response = cloudwatch_logs.put_log_events(
        logGroupName=log_group_name,
        logStreamName=log_stream_name,
        logEvents=[
            {
                'timestamp': int(round(time.time() * 1000)),
                'message': log_message
            }
        ]
    )
    
    print(log_message)  
