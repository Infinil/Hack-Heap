import dateparser
import requests 
from urllib.parse import unquote
from appwrite.client import Client
from appwrite.services.databases import Databases
from appwrite.query import Query
from bs4 import BeautifulSoup
from lxml import etree

def main(request, response):
  client : Client = Client()
  (client
  .set_endpoint(request.env['API_ENDPOINT'])
  .set_project(request.env['PROJECT_ID'])
  .set_key(request.env['SECRET_KEY']) 
  )
  database : Databases = Databases(client, database_id='default')
  web_scrape_obj = WebScrape(database, request)
  web_scrape_obj.devfolio()
  web_scrape_obj.hackerearth()
  web_scrape_obj.mlh()
  return response.send('Function Execution Completed.')

class WebScrape:
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
    sitecode=requests.get('https://devfolio.co/hackathons').text
    bs = BeautifulSoup(sitecode, "html.parser")
    model = etree.HTML(str(bs)) 
    hackathons = model.xpath('//div[@class="sc-ddcaxn hkkldD sc-ibEqUB dMpoHf"]')
    for hackathon in hackathons:
      name=hackathon.xpath('.//h5[@class="sc-fxvKuh klAoDB"]')[0].text

  def hackerearth(self):
    pass

  def mlh(self):
    pass