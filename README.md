
## Pothole Detection & Authority Alerting App using Flutter & Deep Learning.
![FLutter APP UI](https://github.com/snehitvaddi/PotholeAlert/blob/master/Untitled%20design.jpg)

This app captures image and classifies if it contains Pothole or not. If pothole is present, app gets location and sends mail to the corresponding authories based location pothole is found. (<i>Distinct Emailing is still under development</i>)

|🗃 Dataset|⚡ Tflite Model |📑 Labels|
|:-:|:-:|:-:|
|[Drive](https://drive.google.com/drive/folders/11ywgGuEDeMYVaoiP8SegzKVuxIfu3JCi?usp=sharing)|[Model](https://github.com/snehitvaddi/PotholeAlert/blob/master/assets/colab-pothole.tflite)|[Labels](https://github.com/snehitvaddi/PotholeAlert/blob/master/assets/labels.txt)|

### 💡 Helpful References
* This model is trained using Googles Teachable Machine to save time and resources. Learn to How to train a model and deploy on demo flutter here: [Youtube Tutorial](https://www.youtube.com/watch?v=-5kUv47xKy0), Github link: [Github](https://github.com/theindianappguy/machine_learning_flutter_app).
* FLUTTER Location Coordinates to City and Place: [Geolocator Blog](https://www.digitalocean.com/community/tutorials/flutter-geolocator-plugin).
* Flutter object detection with tflite and Yolo: [Deployment tuts](https://www.youtube.com/watch?v=0pYh7Js4GM8).
* Flutter Camera image to Firebase: [Part-1](https://www.youtube.com/watch?v=aBoYbMBTu7s), [Part-2](https://www.youtube.com/watch?v=GQ8iaKSSyDI).
* Tensorflow official tflite deployment tutorial: [tflite blog](https://blog.tensorflow.org/2020/09/how-to-create-cartoonizer-with-tf-lite.html?m=1).

#### Don't forget to star ⭐ the repo, it's FREE.

### 🛠 Requirements
- Any Operating System (I'm on Windows)
- Android Studio/Visual Studio Code
- Updated Packages

### 🧠 Future Work
* Implement email filtering and divert to concerned authoriteies depending on Geolocation gathered.
* Revamp the Sign-in and Signout process.
* Enhance model performance by training model on India specific data. 

### 🤝 Let's Connect
[Snehit Vaddi's LinkedIn](https://www.linkedin.com/in/snehitvaddi/)
