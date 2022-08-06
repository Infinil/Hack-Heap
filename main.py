import dateparser
import requests 
from urllib.parse import unquote
from appwrite.client import Client
from appwrite.services.databases import Databases
from appwrite.query import Query
from bs4 import BeautifulSoup

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
    soup=BeautifulSoup(sitecode,'lxml')
    hackathons=soup.find_all('div', class_ ="sc-ddcaxn hkkldD sc-ibEqUB dMpoHf")
    for hackathon in hackathons:    
      name=hackathon.find('h5', class_="sc-fxvKuh klAoDB").text
      mode=hackathon.find('div', class_="sc-hjQCSK hgqIBf").text
      urlclass=hackathon.find('a', class_='sc-bPPhlf eQJQck')
      url=urlclass['href']
      sitecode2=requests.get(url).text
      soup2=BeautifulSoup(sitecode2,'lxml')
      date=soup2.find('p',class_='sc-fxvKuh cgHRZl').text
      if date=="Online":
        continue
      startdatesplit=date.split("-")
      startdate2=startdatesplit[1].split(",")[1].replace(" ",'')
      startdate1=startdatesplit[0]
      startdate=startdate1+startdate2
      startdate = int(dateparser.parse(startdate).timestamp())
      infos=soup2.find('div',class_='sc-hjQCSK jMnjua')
      image=infos.div.span.img['srcset'].split('=')[1].replace('&w','')
      image = unquote(image)
      participants=hackathon.find('p','sc-fxvKuh kVBkpy')
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
    source = 'Hackerearth'
    sitecode=requests.get('https://www.hackerearth.com/challenges/hackathon/').text
    soup=BeautifulSoup(sitecode,'lxml')
    hackathons=soup.find_all('div', class_ ="challenge-card-modern")
    for hackathon in hackathons:
      name=hackathon.find('span',class_='challenge-list-title challenge-card-wrapper') 
      if name==None:
        continue
      elif len(name.text) < 2:
        name = 'Unknown Name'
      else:
        name=name.text
      participants=int(hackathon.find('div',class_='registrations tool-tip align-left').text)
      image=hackathon.a.div.div['style'].split('\'')[1]
      register=hackathon.a['href']
      sitecode2=requests.get(register).text
      soup2=BeautifulSoup(sitecode2,'lxml')
      infos=soup2.find('div', class_='event-details-container')
      everything=infos.find_all('div',class_='regular bold desc dark')
      if len(everything)==6:
        iphase=everything[0].text
        istartson=everything[1].text.split(',')[0]
        hphase=everything[3].text
        hend=everything[5].text.split(",")
        if iphase==hphase:
          mode=iphase.strip()
        else:
          mode="Hybrid"
        date=istartson+" -"+hend[0]+hend[1]
      elif len(everything)==3:
        mode=everything[0].text.strip()
        istartson=everything[1].text.split(',')[0].strip()
        hend=everything[2].text.split(",")
      date=istartson+" -"+hend[0]+hend[1]
      startdate=istartson+hend[1]
      dict_data : dict = {
        'name' : name,
        'url' : register,
        'participants' : participants,
        'image' : image,
        'date' : int(dateparser.parse(startdate).timestamp()),
        'timeline' : date,
        'mode' : mode,
        'source' : source
      }
      self.common_operations(dict_data)

  def mlh(self):
    source = 'MLH'
    sitecode=requests.get('https://mlh.io/seasons/2023/events').text
    soup=BeautifulSoup(sitecode,'lxml')
    hackathons=soup.find_all('div',"event-wrapper")
    stored_date = 0
    for hackathon in hackathons:
      url=hackathon.a['href']
      image=hackathon.find('div','image-wrap')
      imageurl=image.img['src']
      name=hackathon.find('h3',class_='event-name').text
      date=hackathon.find('p',class_='event-date').text
      date=date.strip()
      startdate=date.split('-')[0] + '2022'
      date += ' 2022'
      mode=hackathon.find('div',class_='event-hybrid-notes').text
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