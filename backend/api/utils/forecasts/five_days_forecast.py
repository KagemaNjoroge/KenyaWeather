import os
from bs4 import BeautifulSoup
import requests

url = "https://meteo.go.ke/forecast/5-days-forecast"
download_button_class = "document-download button button-main"


# global TODO:Add error handling


def get_pdf_link() -> str | dict:
    """
    This function web scrapes the meteo.go.ke website and returns the link to the pdf file for the 5 days forecast
    """
    request = requests.get(url)

    if request.status_code == 200:
        # download data
        soup = BeautifulSoup(request.text, "html.parser")
        download_button = soup.find("a", class_=download_button_class)
        download_link = download_button["href"]
        download_link = "https://meteo.go.ke" + download_link

        return download_link
    else:
        return {"error": "Something went wrong"}


def get_period_dates_from_url(url: str) -> dict:
    """
    Takes a url link such as https://meteo.go.ke/sites/default/files/5day-forecast/5%20Day%20weather%20Forecast%20%2021st%20to%2025th%20September%202023.pdf
    and returns a dict of the forecast period details
    for the example above, the function returns {
    'begin_date': '21',
    'end_date': '25'
    'year': '2023',
    'month': 'September'
    }

    """
    # extract the dates from the url

    # 5%20Day%20weather%20Forecast%20%2021st%20to%2025th%20September%202023.pdf
    url = url.split("/")[-1]
    url = url.split(".")[0]  # remove the .pdf extension
    # ['5', 'Day', 'weather', 'Forecast', '', '21st', 'to', '25th', 'September']
    url = url.split("%20")
    url = url[5:]  # ['21st', 'to', '25th', 'September']
    begin_date = url[0].strip("stndrh")  # 21
    end_date = url[2].strip("stndrh")  # 25
    month = url[3]  # September
    year = url[4]  # 2023

    return {
        "begin_date": begin_date,
        "end_date": end_date,
        "year": year,
        "month": month,
    }


def download_pdf(url: str) -> None:
    """
    Downloads the pdf file from the url and saves it in the forecasts/five_days_forecast folder
    The file name is in the format begin_date_end_date_month_year.pdf
    The function also checks if the file already exists and if it does, it does not download it again
    """

    # example url = https://meteo.go.ke/sites/default/files/5day-forecast/5%20Day%20weather%20Forecast%20%2021st%20to%2025th%20September%202023.pdf
    forecast_metadata = get_period_dates_from_url(url)
    file_name = f"{forecast_metadata['begin_date']}_{forecast_metadata['end_date']}_{forecast_metadata['month']}_{forecast_metadata['year']}.pdf"

    folder_name = "five_days_forecast"

    # check if the folder exists
    if not os.path.exists(f"forecasts/{folder_name}"):
        # create the folder
        os.makedirs(f"forecasts/{folder_name}")

    file_name = f"forecasts/{folder_name}/{file_name}"
    # check if the file exists
    if os.path.exists(file_name):
        print("File already exists")
        return
    else:
        # download the file
        print("Downloading file")
        file = requests.get(url)

        if file.status_code == 200:
            with open(file_name, "wb") as f:
                f.write(file.content)
        else:
            print("Something went wrong")


def parse_pdf(file_path: str) -> dict:
    """
    Parses the pdf file and returns a dictionary of the data
    This makes use of tabula-py library
    This requires java to be installed

    """
    # TODO: parse pdf logic

    pass
