import cv2
import numpy as np
import time

PATH = 'images/cvtest.jpg'


if __name__ == "__main__":
    img = cv2.imread('images/cvtest.jpg')
    gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
    blur = cv2.GaussianBlur(gray, (11, 11), 0)
    canny = cv2.Canny(gray, 150, 300)
    res = cv2.resize(canny, None, fx=0.125, fy=0.125, interpolation=cv2.INTER_CUBIC)
    
    cv2.imwrite('images/output_contour.png',  canny)
    cv2.imwrite('images/output_contour_resized.png',  res)
    cv2.imshow('canny', res)
    cv2.waitKey(0)

    print(img.shape)  
