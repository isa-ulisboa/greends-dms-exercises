from bs4 import BeautifulSoup
from urllib.request import urlopen

url = "https://www.healthline.com/nutrition/foods/strawberries#nutrition"
page = urlopen(url)
html = page.read().decode("utf-8")
soup = BeautifulSoup(html, "html.parser")

print(soup.get_text()) 
