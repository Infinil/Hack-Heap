<p align="center">
  <a href="https://github.com/Infinil/Hack-Heap">
    <img src="https://i.imgur.com/6fRzGCt.jpgt" > 
  </a>
</p>

<p align="center">
  <a href="https://github.com/Infinil/Hack-Heap">
    <img src ="https://img.shields.io/badge/Made%20By-DumbDuo-red" alt = "MADE BY">

<p align="center">
  <a href="https://github.com/Infinil/Hack-Heap">
    <img src ="https://img.shields.io/github/issues-raw/Infinil/Hack-Heap" alt = "Open Issues">
    <img src ="https://img.shields.io/github/issues-closed-raw/Infinil/Hack-Heap" alt = "Closed Issues">
    <img src ="https://img.shields.io/github/issues-pr-raw/Infinil/Hack-Heap" alt = "Open Pull Requests">
    <img src ="https://img.shields.io/github/issues-pr-closed/Infinil/Hack-Heap" alt = "Closed Pull Requests">
  </a>
 </p>

Hack Heap is an application for aggregating all the hackathons. It is a solution created by webscraping popular websites and providing it to you. So you can check them all out easily at one place.

## HOW TO INSTALL
1) Go to file `app-release.apk` from an android phnoe.
2) Click on download file.
3) Install the APK.

## IMPLEMENTATION
* Made a python script for webscraping.
* Hosted the script as a cloud function with appwrite and made it to run every hour to update documents in the database.
* Made the android app using flutter framework which displays the documents from the database.
* Added additional features like refresh, notify etc to the app.
    
    
## TECHNOLOGIES USED
  <p align="left">
  <a href="https://github.com/Infinil/Hack-Heap">
    <img src="https://i.imgur.com/v7F34Yn.jpg"> 
  </a>
</p>

## CHALLENGES FACED

#### SCRAPING
<p> - Codes of site can change with time therefore a constant code for the scrape is not possible and needs to be updated quite frequently since the code breaks if that is not done. </p>
    <p>    - An error could occur in the cloud function if the code comes across any problem which can stop database from updating. </p>
    
#### APPLICATION
<p> - The push notifications kept showing an error but we were finally able to fix it (thanks to stack overflow).
<p> - The images for one of the sites were blurry so we had to go round about it by only showing the text info.
<p> - The attributes for different sites were similar but not same so we had to decide on how to display and what to display. </p>

## FUTURE VISION
<p> - We aim to expand our database so we can provide more information.
<p> - Setting up reminders which can be customised as per the user's needs.
<p> - We also want to add contests and challenges with the hackathons.
