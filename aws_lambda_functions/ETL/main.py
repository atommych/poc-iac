import requests
import pandas as pd
import io

def extract():
    url = 'https://www.trismegistos.org/geo/georef_list_export.php?referral_page=georef_list&tex_id=56084&order=standard'
    csv_file = requests.get(url).content
    return io.StringIO(csv_file.decode('utf-8'))

def transform(text: str) -> str:
    #Add column loadDate
    df=pd.read_csv(csv_file, sep='\t')
    df['LAST-UPD-DT'] = pd.to_datetime("today")
    return df

def handler(event, context):

    csv_file = extract()
    transform(csv_file)

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps({"result": df.to_json(orient ='index')}),
    }


if __name__ == "__main__":
    pass