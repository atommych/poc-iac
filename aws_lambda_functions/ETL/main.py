from botocore.vendored import requests
import boto3
import pandas as pd
import io

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
    path_test = '/tmp/output'
    file_name = 'carlsberg.csv'

    csv_file = extract()
    new_table = transform(csv_file)
    new_table.to_csv(path_test+'/'+file_name)

    s3 = boto3.resource(u's3')
    bucket = s3.Bucket(u'learn-terraform-functions-friendly-kindly-diverse-flea')

    bucket.upload_file(path_test, file_name)

    return {
        'status': 'True',
        'statusCode': 200,
        'body': 'File Uploaded'
    }


if __name__ == "__main__":
    pass