# On Images, Spring 2019

## For assignment 2, we had to use mylar to recreate a 3D image by taping the mylar to a window and drawing the contour.

I found this incredibly difficult, as it required me to close an eye and stay in the exact same position.

For every new line I added, I had to check roughly half of the lines already on the mylar to make sure that I was still in the correct position.

This algorithm is O(n^2) because for each new line added, a linear proportion of existing lines must be checked.

The algorithm to draw with aligned perspectives has a constant time insert because no other lines need to be referred to, therefore O(n) time. 

After about an hour, it became obvious that I needed a better solution.

OpenCV is a python package that allows for image transformations and uses numpy for data/array management.

These are some basic functions that I used to produce images that helped me finish the assignment: 
  * cv2.cvtColor(img, cv2.COLOR_RGB2GRAY): given an image img, this function call will return the grayscaled image.
  * cv2.GaussianBlur(img, (n, n {where n % 2 != 0}), 0): Given img and blur size, GaussianBlur will remove some of the more irrelevant edges.
  * cv2.Canny(img, n, m): Canny is the edge detection function, and (n, m) are 
    * [click here](https://docs.opencv.org/3.1.0/da/d22/tutorial_py_canny.html) for more details on the math of edge detection.
    
## edges.py given 'cvtest.jpg', grayscales, blurs, and does edge detection (in that order) and writes the new image and a smaller, resized version to the repository root. 
![edges.py output](https://github.com/anandijain/vision/blob/master/images/output_contour_resized.png)


## Now that I had the edges, all I needed to do was overlay the image and my mylar and trace. 
 ### Using [OBS](https://obsproject.com/), and a camera hung from above, I was able to use the filter effects in OBS to add the image and the edges as overlay to the mylar. 
 ### Now that both the mylar and the image were in the same 2D plane, I could simply watch the [stream](https://www.twitch.tv/videos/415607848) and trace.
 
 ### Using different combinations of the image mask/blend settings:
  * Edges and mylar
   * ![Edges and mylar](https://github.com/anandijain/vision/blob/master/images/edges_mylar_resized.png)
  * Photo and mylar
   * ![Photo and mylar](https://github.com/anandijain/vision/blob/master/images/photo_mylar_resized.png)
  * Edges, photo, and mylar
   * ![Edges, photo, and mylar](https://github.com/anandijain/vision/blob/master/images/edges_photo_mylar_resized.png)

# Final Drawing

![Final Drawing](https://github.com/anandijain/vision/blob/master/images/final_drawing_resized.png)
