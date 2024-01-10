import boto3
s3_client = boto3.client('s3')
def list_all_buckets():
    response = s3_client.list_buckets()
    buckets = [bucket['Name'] for bucket in response['Buckets']]
    print("List of S3 Buckets:")
    for bucket in buckets:
        print(bucket)

def count_objects_in_bucket(bucket_name):
    response = s3_client.list_objects_v2(Bucket=bucket_name)
    total_objects = response.get('KeyCount', 0)
    print(f"Total number of objects in '{bucket_name}': {total_objects}")

specified_bucket = ' natwestgroup'

list_all_buckets()
count_objects_in_bucket(specified_bucket)
