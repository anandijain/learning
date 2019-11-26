import requests
import time


def get_page():
    url = "https://api.matchbook.com/edge/rest/events"

    querystring = {
        "offset": "0",
        "per-page": "20",
        "sport-ids": "1,4",
        "states": "open,suspended,closed,graded",
        "exchange-type": "back-lay",
        "odds-type": "DECIMAL",
        "include-prices": "true",
        "price-depth": "3",
        "price-mode": "expanded",
        "include-event-participants": "false",
    }

    headers = {"user-agent": "api-doc-test-client"}

    response = requests.request("GET", url, headers=headers, params=querystring)

    # print(response.text)
    return response


if __name__ == "__main__":
    t0 = time.time()
    ret = get_page()
    t1 = time.time()
    print(f"delta: {str(t1 -t0)}")
