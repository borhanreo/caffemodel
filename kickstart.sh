#!/bin/bash

export CAFFE_ROOT=/home/mamun/Development/environment/caffe
export PROTO_ROOT=/home/mamun/Development/environment/protobuf
export APP_FOLDER=$(pwd)

# Unzip train and test data
# sudo apt-get -y install unzip
# unzip train -d .
# unzip test2 -d .

# Format data
python create_label_file.py # creates 2 text files with labels for training and validation
bash build_datasets.sh # build lmdbs

# Download ImageNet pretrained weights (takes ~20 min)
# $CAFFE_ROOT/scripts/download_model_binary.py $CAFFE_ROOT/models/bvlc_reference_caffenet

# Fine-tune AlexNet architecture (takes ~60 min)
$CAFFE_ROOT/build/tools/caffe train -solver $APP_FOLDER/dnn_solver.prototxt -weights $CAFFE_ROOT/models/bvlc_reference_caffenet/bvlc_reference_caffenet.caffemodel

# Classify test dataset
export PYTHONPATH=$CAFFE_ROOT/python:$PROTO_ROOT/python:$PYTHONPATH
python convert_binaryproto2npy.py
python dnn_classify.py # Returns prediction.txt (takes ~20 min)

# A better approach is to train five AlexNets w/init parameters from the same distribution,
# fine-tuned those five, and compute the average of the five networks
