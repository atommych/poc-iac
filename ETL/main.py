import requests
import boto3
import pandas as pd
import io
import os

def extract():
    url = 'https://www.trismegistos.org/geo/georef_list_export.php?referral_page=georef_list&tex_id=56084&order=standard'
    csv_file = requests.get(url).content
    return io.StringIO(csv_file.decode('utf-8'))

def transform(file):
    #Add column loadDate
    df=pd.read_csv(file, sep='\t')
    df['LAST-UPD-DT'] = pd.to_datetime("today")
    return df

def handler(event, context):
    path_test = '/tmp'
    file_name = 'carlsberg.csv'

    bucket_name = os.environ['bucket_name']
    print(bucket_name)

    s3 = boto3.resource(u's3')
    bucket = s3.Bucket(bucket_name)

    #s3_client = boto3.client('s3')
    #buckets = s3_client.list_buckets()
    #print(buckets)

    csv_file = extract()
    new_table = transform(csv_file)
    new_table.to_csv(path_test+'/'+file_name)

    bucket.upload_file(
        path_test+'/'+file_name,
        bucket_name,
        None)

    return {
        'status': 'True',
        'statusCode': 200,
        'body': 'File Uploaded'
    }


if __name__ == "__main__":
    pass