FROM python:3.6

# Creating Application Source Code Directory
RUN mkdir -p /app

# Setting Home Directory for containers
WORKDIR /app

# Copy src files folder (requirements.txt and classify.py)
COPY requirements.txt /app
COPY classify.py /app
COPY train.py /app
COPY data_preload.py /app
COPY utils.py /app
COPY models.py /app

# Installing python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# create directories for models and data
RUN mkdir -p /app/models
RUN mkdir -p /app/data

# Preload the data
RUN python data_preload.py

# Pretrain the models
# Application Environment variables. 
# These variables will be used when you run the image. 
# You will also need to pass corresponding DATASET and TYPE variables from the job yaml files of both free-service and default types of jobs.

ENV APP_ENV development
ENV DATASET kmnist
ENV TYPE cnn
RUN echo "$APP_ENV"
RUN echo "$DATASET"
RUN echo "$TYPE"
RUN python train.py

ENV APP_ENV development
ENV DATASET mnist
ENV TYPE cnn
RUN echo "$APP_ENV"
RUN echo "$DATASET"
RUN echo "$TYPE"
RUN python train.py

ENV APP_ENV development
ENV DATASET kmnist
ENV TYPE ff
RUN echo "$APP_ENV"
RUN echo "$DATASET"
RUN echo "$TYPE"
RUN python train.py

ENV APP_ENV development
ENV DATASET mnist
ENV TYPE ff
RUN echo "$APP_ENV"
RUN echo "$DATASET"
RUN echo "$TYPE"
RUN python train.py

# Exposing Ports
EXPOSE 5035

# Setting Persistent data
VOLUME ["/app-data"]

# Running Python Application (classify.py)
CMD ["python", "classify.py"]
