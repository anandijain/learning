# common foss 

"""
numpy
pandas


"""
import time
import pyttsx3

def sleep_and_speak(e:pyttsx3.engine.Engine, phrase:str, sleep_amt:str):
    time.sleep(sleep_amt)
    e.say(phrase)
    e.runAndWait()


def remind_every(phrase: str, n: int, sleep_amt: int):
    i = 0
    e = pyttsx3.init()
    for i in range(n):
        sleep_and_speak(e, phrase, sleep_amt)




if __name__ == "__main__":
    remind_every("hello", 10, 5)
