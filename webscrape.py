from appwrite.client import Client
from appwrite.services.databases import Databases
from appwrite.query import Query
import dateparser
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager

def main(request, response):
  client : Client = Client()
  (client
  .set_endpoint(request.env['API_ENDPOINT'])
  .set_project(request.env['PROJECT_ID'])
  .set_key(request.env['SECRET_KEY']) 
  )
  database : Databases = Databases(client, database_id='default')
  web_scrape_obj = WebScrapeFunctions(database, request)
  web_scrape_obj.devfolio()
  web_scrape_obj.hackerearth()
  web_scrape_obj.mlh()
  return response.send('Function Execution Completed.')

class WebScrapeFunctions:
  def __init__(self, database: Databases, request):
    self.database = database
    self.request = request
  
  def common_operations(self, dict_data: dict):
    docs = self.database.list_documents(
      self.request.env['COLLECTION_ID'],
      queries=[
        Query.equal('url', dict_data['url'])
      ]
    )
    if docs['total'] == 0:
      self.database.create_document(
        collection_id = self.request.env['COLLECTION_ID'],
        document_id = 'unique()',
        data = dict_data
      )

  def devfolio(self):
    source = 'Devfolio'
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))
    driver.get("https://devfolio.co/hackathons")
    hackathons = driver.find_elements(By.XPATH, '//div[@class="sc-ddcaxn hkkldD sc-ibEqUB dMpoHf"]')
    for hackathon in hackathons:
      name=hackathon.find_element(By.XPATH, './/h5[@class="sc-fxvKuh klAoDB"]').text
      mode=hackathon.find_element(By.XPATH, './/div[@class="sc-hjQCSK hgqIBf"]').text
      print(mode)

  
  def hackerearth(self):
    source = 'Hackerearth'
  
  def mlh(self):
    source = 'MLH'