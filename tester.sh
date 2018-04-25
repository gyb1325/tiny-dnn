#!/bin/bash
function test_inject () {
  rm -f temp.txt
  rm -f temp2.txt
  cat ./tiny_dnn/core/kernels/conv2d_op_internal_inject.h |sed "s/\#define char_pos [0-9]/\#define char_pos $1/" > temp.txt
  cat temp.txt |sed "s/\#define bit_pos [0-9]/\#define bit_pos $2/" > temp2.txt
  cat temp2.txt > ./tiny_dnn/core/kernels/conv2d_op_internal_inject.h
    rm -f temp.txt
    rm -f temp2.txt
}
set a=0
for b in {0..31}
  do
    test_inject $a $b
    make  -j4 example_caffe_converter
    echo "testing $a-$b"
    echo "******************************testing $a-$b***********************" 1>>log.txt 2>&1
    bash ./examples/test_caffemodel/run.sh 1>>log.txt 2>&1
done
