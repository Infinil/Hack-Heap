from concurrent.futures import process
from appwrite.client import Client
from appwrite.services.databases import Databases
from appwrite.query import Query
import dateparser
import selenium
from selenium import webdriver
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
    driver = webdriver.Chrome(ChromeDriverManager().install())
    driver.get("https://devfolio.co/hackathons")
  
  def hackerearth(self):
    source = 'Hackerearth'
  
  def mlh(self):
    source = 'MLH'

class Request:
  env = {
    'API_ENDPOINT' : 'http://backend.limitnil.com/v1',
    'DATABASE_ID' : 'default',
    'PROJECT_ID' : 'hackheap',
    'SECRET_KEY' : '8dd766283f12dc44b71e5b152e5e2cd373a964f20dd4d4086fdd48c5c41b4f5dc8a351fb28db6762fb8beefac063d302fbef1492081ae5fdb587444739fa8cfaf4e247b9ed17618c4b88e2271b3b7a0af8e14f21eb5e0b1d79458047750d6cba5d8b5988715df099511b3cd7f3af32ca35e1a8ef08ded1d049b4dde31bc38cf3',
    'COLLECTION_ID' : 'hackathons',
  }

main(Request(),2)