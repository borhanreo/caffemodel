# CaffeModel

Run caffenet on this data

- http://caffe.berkeleyvision.org/tutorial
- https://github.com/philipperemy/yolo-9000
- https://github.com/C-Aniruddh/realtime_object_recognition
- http://caffe.berkeleyvision.org/gathered/examples/mnist.html

# Setup ProtoBuf

Download Protobuf

    cd /home/mamun/Idea/env
    wget https://github.com/google/protobuf/releases/download/v3.5.1/protobuf-all-3.5.1.tar.gz
    tar -xvf protobuf-all-3.5.1.tar.gz 
    mv protobuf-3.5.1 protobuf
    cd protobuf
    
Install Protobuf

    ./configure
    make
    make check
    sudo make install
    sudo ldconfig # refresh shared library cache
    
For use in python

    cd python
    sudo apt-get install -y python-setuptools
    sudo apt-get install build-essential
    sudo python setup.py install
    export PROTO_ROOT=/home/mamun/Idea/env/protobuf

# Install Caffe

## Ubuntu (>= 17.04)

    sudo apt install caffe-cpu

From https://github.com/BVLC/caffe/tree/master/models/bvlc_reference_caffenet

    wget dl.caffe.berkeleyvision.org/bvlc_reference_caffenet.caffemodel

## Ubuntu (< 17.04)

    sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler
    sudo apt-get install --no-install-recommends libboost-all-dev

    cd /home/mamun/Idea/env
    git clone https://github.com/BVLC/caffe
    cp Makefile.config.example Makefile.config

- open Makefile.config
- locate INCLUDE_DIRS and append /usr/include/hdf5/serial (per this SO answer)
- locate line containing LIBRARY_DIRS and append /usr/lib/x86_64-linux-gnu/hdf5/serial
- Uncomment to build without GPU support

    CPU_ONLY := 1

- Uncomment if you're using OpenCV 3

    OPENCV_VERSION := 3

Install more dependancies

    sudo apt-get install libhdf5-dev
    sudo apt-get install libgflags-dev
    sudo apt-get install libgoogle-glog-dev
    sudo apt-get install liblmdb-dev
    sudo apt-get install libopenblas-dev
    sudo apt-get install python-opencv
    sudo apt-get install libatlas-base-dev
    
**Note**: Adjust Makefile.config (for example, if using Anaconda Python, or if cuDNN is desired)
    
For CPU-only Caffe, uncomment CPU_ONLY := 1 in Makefile.config.
    
    make clean
    make all
    make test
    make runtest
    
To compile the Python and MATLAB wrappers do 

    make pycaffe
    
To MATLAB wrappers do 
    
    make matcaffe

**Note**: Be sure to set your MATLAB and Python paths in Makefile.config first!

Export CaffeRoot

    export CAFFE_ROOT=/home/mamun/Idea/env/caffe
    
## Windows

Install CMake

Install Chocolatey

    @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
    choco upgrade chocolatey

Install Ninja

    choco install ninja
    
Install Visual Studio 2015 with C++ language and tools and in the caffe root

    git checkout windows
    scripts\build_win.cmd

# Export PythonPath

    cd python
    sudo pip install -r requirements.txt
    export PYTHONPATH=$CAFFE_ROOT/python:$PROTO_ROOT/python:$PYTHONPATH
       
# Execute

    bash kickstart.sh
    
# Add new object type

Add condtion in **create_label_file.py** for new object type.
In the weights.prototxt and deploy.prototxt increase **num_output** count by one under last **inner_product_param** for addition of each new object type. 
In both file the **num_output** must be same.