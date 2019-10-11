import cv2
import numpy as np
import time

# IMG_PATH = 'images/cvtest.jpg'
VID_PATH = 'images/album_cover.mp4'

W = 1920
H = 1080

def process_frame(img):
    # gray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
    blur = cv2.GaussianBlur(img, (11, 11), 0)
    res = cv2.Canny(blur, 11, 11)
    # res = cv2.resize(canny, None, fx=0.125, fy=0.125, interpolation=cv2.INTER_CUBIC)
    # res = cv2.resize(img, None, fx=0.5, fy=0.5, interpolation=cv2.INTER_CUBIC)
    # gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
    # corners = cv2.goodFeaturesToTrack(gray, 25, 1, 10)
    # corners = np.int32(corners)
    # for i in corners:
    #     x,y = i.ravel()
    #     res = cv2.circle(img, (x,y), 10, 255, -1)
    cv2.imshow('img', res)
    # print(res.shape)


if __name__ == "__main__":
    # img = cv2.imread('images/cvtest.jpg')
    cap = cv2.VideoCapture(VID_PATH)
    frame_count = cap.get(cv2.CAP_PROP_FRAME_COUNT)
    cap.set(cv2.CAP_PROP_POS_FRAMES, 0)

    while cap.isOpened():
        ret, frame = cap.read()
        frame_number = cap.get(cv2.CAP_PROP_POS_FRAMES)   
        print(frame_number)
        if ret == True:
            process_frame(frame)
            cv2.waitKey(0)
        else:
            cap.release()
            cv2.destroyAllWindows()

     
