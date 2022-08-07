from urllib.request import urlopen
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
    soup=BeautifulSoup(sitecode,'lxml')
    hackathons=soup.select("div.sc-ibEqUB")
    for hackathon in hackathons:
      name=hackathon.select_one('h5.sc-fxvKuh').text
      mode=hackathon.select_one('div.sc-hjQCSK').text
      urlclass=hackathon.select_one('a.sc-bPPhlf')
      url=urlclass['href']
      sitecode2=requests.get(url).text
      soup2=BeautifulSoup(sitecode2,'lxml')
      date=soup2.select_one('p.cgHRZl').text
      if date=="Online":
        continue
      startdatesplit=date.split("-")
      startdate2=startdatesplit[1].split(",")[1].replace(" ",'')
      startdate1=startdatesplit[0]
      startdate=startdate1+startdate2
      startdate = int(dateparser.parse(startdate).timestamp())
      infos=soup2.select_one('div.sc-hjQCSK div span img')['srcset']
      image=infos.split('=')[1].replace('&w','')
      image = unquote(image)
      participants=hackathon.select_one('p.kVBkpy')
      if participants!=None:
        participants=participants.text.split()[0].replace("+",'')
        participants=int(participants)
      dict_data : dict = {
        'name' : name,
        'url' : url,
        'image' : image,
        'participants' : participants,
        'date' : startdate,
        'timeline' : date,
        'mode' : mode,
        'source' : source
      }
      self.common_operations(dict_data)



  def hackerearth(self):
    pass

  def mlh(self):
    source = 'MLH'
    sitecode=requests.get('https://mlh.io/seasons/2023/events').text
    soup=BeautifulSoup(sitecode,'lxml')
    hackathons=soup.select('div.event-wrapper')
    stored_date = 0
    for hackathon in hackathons:
      url=hackathon.a['href']
      imageurl=hackathon.select_one('div.image-wrap img')['src']
      name=hackathon.select_one('h3.event-name').text
      date=hackathon.select_one('p.event-date').text
      date=date.strip()
      startdate=date.split('-')[0] + '2022'
      date += ' 2022'
      mode=hackathon.select_one('div.event-hybrid-notes').text
      if "Hybrid" in mode:
        mode="Hybrid"
      elif "Digital" in mode:
        mode="Online"
      elif "In-Person Only" in mode:
        mode="Offline"
      if int(dateparser.parse(startdate).timestamp()) < stored_date:
        break
      stored_date = int(dateparser.parse(startdate).timestamp())
      dict_data : dict = {
        'name' : name,
        'url' : url,
        'image' : imageurl,
        'timeline' : date,
        'date' : stored_date,
        'participants' : None,
        'mode' : mode,
        'source' : source
      }
      self.common_operations(dict_data)