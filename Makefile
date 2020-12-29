#PYTHON_VERSION = 3.6m
PYTHON_VERSION = 2.7
PYTHON_INCLUDE = /usr/include/python$(PYTHON_VERSION)

# location of the Boost Python include files and library
BOOST_INC = /usr/include/boost
BOOST_LIB = /usr/lib

CC = g++-7

OPENCV_LIB = `pkg-config --libs opencv`
OPENCV_CFLAGS = `pkg-config --cflags opencv`

CFLAGS_SILENT_WARNINGS = -Wall -Wno-unused-function -Wno-unused-variable
CFLAGS = -rdynamic -g -O3 -fPIC
EXTERN_VARS = -DMODULE_STR=bv -DMODULE_PREFIX=pybv -DNDEBUG
#MY_CPP_LIB = lib_my_cpp_library.so
MY_CPP_LIB = 

TARGET = bv
SRC = cv3.cpp src/bvmodule.cpp 
OBJ =  cv3.o bvmodule.o 

$(TARGET).so: genheaders $(OBJ)
	$(CC) -shared -rdynamic $(EXTERN_VARS) $(OBJ) -L/usr/lib/python$(PYTHON_VERSION)/config -L/usr/lib/x86_64-linux-gnu/ -lpython$(PYTHON_VERSION) -o $(TARGET).so $(OPENCV_LIB) $(MY_CPP_LIB)

genheaders:
	rm -rf __pycache__
	rm -f build/*.h
	mkdir -p build
	python$(PYTHON_VERSION) gen2.py build headers.txt	
	
$(OBJ): $(SRC)
	$(CC) -g -O3 -fPIC -I$(PYTHON_INCLUDE) -I . -I build $(EXTERN_VARS) $(OPENCV_CFLAGS) -c $(SRC)

clean:
	rm -rf __pycache__
	rm -rf build
	rm -f $(OBJ)
	rm -f $(TARGET).so