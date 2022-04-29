<div id="top"></div>



[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<!-- omit in toc -->
Template Flask App For Machine Learning and Deep Learning
=========================
Use this template to automatically deploy flask application to [riset.informatika.umm.ac.id][web-riset-url].

Clone this repository to your local machine and try dockerize your app using [Docker](https://www.docker.com/)

<!-- omit in toc -->
# 📜 Table of Contents
- [Generic Setup](#generic-setup)
  - [Prerequisites](#prerequisites)
- [Clone The Repo](#clone-the-repo)
- [Contents of the src folder](#contents-of-the-src-folder)
- [Requirements File](#requirements-file)
- [Dockerfile](#dockerfile)
    - [Base Image](#base-image)
    - [Create Folder](#create-folder)
    - [Update and Install](#update-and-install)
    - [Install requirements.txt](#install-requirementstxt)
    - [Copy Source File](#copy-source-file)
    - [Run Gunicorn](#run-gunicorn)
- [Jenkinsfile](#jenkinsfile)
- [builder.yaml File](#builderyaml-file)
- [deployment.yaml File](#deploymentyaml-file)


# Generic Setup
## Prerequisites
* A Flask app that can run as a docker container
* A repository on the github [web-riset organization][web-riset-github-url]
* Permission from administrator so administrator can make a pipeline on [Jenkins][jenkins-url] server base on your repository

<p align="right">(<a href="#top">back to top</a>)</p>

# Clone The Repo
clone this repository using git command:
```sh
git clone https://github.com/web-riset/Template-Flask-App.git
```
After cloning, you may want to change the url of `remote git` to the repository url you have in [web-riset organization][web-riset-github-url]. Example:

```sh
 git remote set-url <remote_name> <remote_url>
```

If your github url in [web-riset organization][web-riset-github-url] is `https://github.com/web-riset/Batik50-cnn`, you can change to:

```sh
 git remote set-url origin https://github.com/web-riset/Batik50-cnn
```

<p align="right">(<a href="#top">back to top</a>)</p>

# Contents of the src folder

`src` folder contains flask application files with `main.py` as entrypoint

You can use folder structure from [Flask][flask-url] documentation or you can use [our][batik50-cnn-github-url] structur folder like this:

    .
    ├── ...
    ├── src                    # src folder is root folder of your project
    │   ├── templates          # contains only file with .html extension
    │   ├── static             # contains assets used by the templates, including CSS files, JavaScript files, and images
    │   └── main.py            # entrypoint of your app
    └── ...

and `main.py` as entrypoint must have at least:

```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, World!'

if __name__ == "__main__": 
        app.run(host='0.0.0.0', port=8000)
```
> `app` aplication will running on localhost with port 8000. you can use any port as long it's not used. this port must be the same as the port in the [Dockerfile](#dockerfile) for running [Gunicorn](#run-gunicorn)

<p align="right">(<a href="#top">back to top</a>)</p>

# Requirements File
Requirements [File](./requirements.txt)  is a file that containts information about all the libraries, modules, and packages in itself that are used for running [Flask][flask-url] app project.

All library files in requirements.txt will be installed when creating the container

for minimal installation of flask app requires at least the following libraries:

```
Flask
gunicorn
```

<p align="right">(<a href="#top">back to top</a>)</p>


# Dockerfile
A [Dockerfile](Dockerfile) is a text document that contains all the commands you can call on the command line to assemble an image.

### Base Image
You can use any base image version, but we recommend to use:
```Dockerfile
FROM python:3.8-slim
```
>You can read this  [article][differences-version-image] to better understand the difference

### Create Folder
This part is used to create a folder inside the image name `/app` and change the directory to `/app`
```Dockerfile
RUN mkdir /app
WORKDIR /app
```

### Update and Install 
This part used to update and install library that cv2 need
```Dockerfile
RUN apt-get update && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && \
    rm -rf /var/lib/apt/lists/*
```


### Install requirements.txt
```Dockerfile
ADD requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt --no-cache-dir
```
> we `strongly` recommend to use this method to install requirements of library to keep Docker image as small as possible


### Copy Source File
This part used to copy your source code on `src` folder to to `/app` inside the image
```Dockerfile
COPY src .
```

### Run Gunicorn
This part is used to run gunicorn on port 8000
```Dockerfile
ENV PORT 8000
ENV SCRIPT_NAME "<subfolder url from administrator>"
CMD exec gunicorn --bind 0.0.0.0:$PORT --workers 1 --threads 4 --timeout 0 main:app
```
change the SCRIPT_NAME environment with the subfolder assigned by the administrator

<p align="right">(<a href="#top">back to top</a>)</p>



# Jenkinsfile

For [Jenkinsfile](Jenkinsfile), you only need to change Environment variable:

```groovy
name = "<name of your app>"
port = "<your app port>"
urlPrefix = "<url from administrator>"
```

example:

```groovy
name = "Batik50-cnn"
port = "8000"
urlPrefix = "/data_science_product/1"
```
> Ask Administrator before naming your image to avoid conflict at the server
>
>The port must be the same as the previous container port



<p align="right">(<a href="#top">back to top</a>)</p>


# builder.yaml File
This [File](builder.yaml) is used to deploy to a Kubernetes Cluster. `Do not` Change this config file at all

Changes will make your application undeployable to the server

# deployment.yaml File
This [File](deployment.yaml) is used to deploy to a Kubernetes Cluster. `Do not` Change this config file at all

Changes will make your application undeployable to the server

<p align="right">(<a href="#top">back to top</a>)</p>



[contributors-shield]: https://img.shields.io/github/contributors/web-riset/Template-Flask-App.svg?style=for-the-badge
[contributors-url]: https://github.com/web-riset/Template-Flask-App/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/web-riset/Template-Flask-App.svg?style=for-the-badge
[forks-url]: https://github.com/web-riset/Template-Flask-App/network/members
[stars-shield]: https://img.shields.io/github/stars/web-riset/Template-Flask-App.svg?style=for-the-badge
[stars-url]: https://github.com/web-riset/Template-Flask-App/stargazers
[issues-shield]: https://img.shields.io/github/issues/web-riset/Template-Flask-App.svg?style=for-the-badge
[issues-url]: https://github.com/web-riset/Template-Flask-App/issues
[license-shield]: https://img.shields.io/github/license/web-riset/Template-Flask-App.svg?style=for-the-badge
[license-url]: https://github.com/web-riset/Template-Flask-App/blob/master/LICENSE.txt

[web-riset-url]: https://riset.informatika.umm.ac.id
[web-riset-github-url]: https://github.com/web-riset
[jenkins-url]: https://www.jenkins.io/
[flask-url]: https://flask.palletsprojects.com/en/2.1.x/tutorial/layout/
[batik50-cnn-github-url]: https://github.com/web-riset/Batik50-cnn
[differences-version-image]: https://medium.com/swlh/alpine-slim-stretch-buster-jessie-bullseye-bookworm-what-are-the-differences-in-docker-62171ed4531d