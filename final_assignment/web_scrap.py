from selenium import webdriver
from bs4 import BeautifulSoup
import pandas as pd 

"""
# open the html file
with open("final_assignment\strawberries_html.html", "r", encoding="utf-8") as f:
  doc = BeautifulSoup(f, "html.parser")

#print(doc.prettify())

tags = doc.find_all("strong")
print(tags)

"""
import requests

url = "https://www.healthline.com/nutrition/foods/strawberries#nutrition"

result = requests.get(url)
doc = BeautifulSoup (result.text, "html.parser")
#print(doc.prettify())

nutritional_values = doc.find_all("strong")
print(nutritional_values) 