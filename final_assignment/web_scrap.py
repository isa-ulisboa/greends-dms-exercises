from selenium import webdriver
from bs4 import BeautifulSoup
import pandas as pd 
import requests

url = "https://www.healthline.com/nutrition/foods/strawberries#nutrition"

result = requests.get(url)
doc = BeautifulSoup (result.content, "html.parser")
print(doc.prettify())

#doc1 = doc.find("article", class_="article-body")
#doc2 = doc1.find("div", class_="css-0")
#doc3 = doc2.find ("ul")
#doc4 = doc3.find("li")
#
#print(doc4)