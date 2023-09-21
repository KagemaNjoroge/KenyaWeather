import os
from bs4 import BeautifulSoup
import requests

# TODO: Add error handling and logging
url = "https://meteo.go.ke/forecast/monthly-forecast"

download_button_class = "document-download button button-main"


example_file_link = "https://meteo.go.ke/sites/default/files/monthly-forecast/September%202023%20Mothly%20Weather%20Forecast.pdf"


def get_pdf_link() -> str | dict:
    """
    This function web scrapes the meteo.go.ke website and returns the link to the pdf file for the monthly forecast

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


def download_pdf(url: str) -> None:
    """
    This function downloads the pdf file from the url saves it in forecasts/monthly_forecast directory
    File name is in the format of month_year.pdf
    :param url: url of the pdf file
    :return: None
    """
    # get the month and year from the url
    period_dates = get_period_dates_from_url(url)
    month = period_dates["month"]
    year = period_dates["year"]
    file_name = f"{month}_{year}.pdf"
    folder_name = "monthly_forecast"

    # check if the folder exists
    if not os.path.exists(f"forecasts/{folder_name}"):
        # create the folder
        os.makedirs(f"forecasts/{folder_name}")
    # check if the file exists
    if os.path.exists(f"forecasts/{folder_name}/{file_name}"):
        # file exists, abort download
        print("File exists")
        # exit the function
        return
    else:
        # file does not exist, download it
        request = requests.get(url)
        if request.status_code == 200:
            # download the file
            with open(f"forecasts/{folder_name}/{file_name}", "wb") as file:
                file.write(request.content)
        else:
            return {"error": "Something went wrong"}


def get_period_dates_from_url(url: str) -> dict:
    """
    :param url: url of the pdf file
    Takes a url link such as https://meteo.go.ke/sites/default/files/5day-forecast/5%20Day%20weather%20Forecast%20%2021st%20to%2025th%20September%202023.pdf
    and returns a dict of the forecast period details
    for the example above, the function returns {
    'month': 'September',
    'year': '2023'
    }

    """
    # extract the dates from the url
    # September%202023%20Mothly%20Weather%20Forecast.pdf
    url = url.split("/")[-1]
    # remove the .pdf extension -> September%202023%20Mothly%20Weather%20Forecast
    url = url.split(".")[0]
    # ['September', '202023', 'Mothly', 'Weather', 'Forecast']
    url = url.split("%20")
    month = url[0]  # September
    year = url[1]  # 2023

    return {"month": month, "year": year}


def parse_pdf(file_path: str) -> dict:
    """
    :param file_path: path to the pdf file
    :return: dict of the forecast data

    """
    # issue: concurrency file handling
    """
    # we need to use Langchains and connect to an LLM and vector db because the pdf is not in tabular format
    """
    pass
