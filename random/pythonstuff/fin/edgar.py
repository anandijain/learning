import requests as r
import bs4
import pandas as pd


""" todo today

email elise
quantum notes readthru 


"""



"""
list companies
get company ids 
"""



def search_link(name:str) -> str:
    company = name.replace(' ', '+')
    return 'https://www.sec.gov/cgi-bin/browse-edgar?company=' + company + '&count=100'


# def get_pages(companies:list)-> list:
#     for c in companies:
#         link = search_link()

def get_page(link:str)->bs4.BeautifulSoup:
    return bs4.BeautifulSoup(r.get(link).text, 'html.parser')

def get_CIKs():
    cik = 'https://www.sec.gov/cgi-bin/cik_lookup'
    return cik

if __name__ == "__main__":
    
    # for maximal CIK lookup give reduced names, eg 'Two Sigma' instead of 'Two Sigma Investments' 
    companies = ['Renaissance Technologies', 'Two Sigma Investments', 'Bridgewater Associates',
        'AQR Capital Management', 'Millennium Management', 'Elliott Management', 'BlackRock', 'Citadel LLC']

    links = list(map(search_link, companies))
    pages = list(map(get_page, links))

    print(len(pages))


