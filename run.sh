#!/bin/sh

PYTHON=python
NETWORK_LIST="alexnet vgg16 vgg19 inception-bn inception-v3 resnet50 resnet101 resnet152"
GPU=0
DTYPE=float32
BATCH_SIZE_LIST="1 2 4 8 16 32 64 128"
N_EPOCH=10
WARM_UP_NUM=10
DLLIB_LIST="caffe caffe2 mxnet pytorch tensorflow"

trap 'echo you hit Ctrl-C/Ctrl-\, now exiting..; pkill -P $$; exit' INT QUIT
for DLLIB in ${DLLIB_LIST}
do
    for NETWORK in ${NETWORK_LIST}
    do
        for BATCH_SIZE in ${BATCH_SIZE_LIST}
        do
            CUDA_VISIBLE_DEVICES=${GPU} ${PYTHON} inference_${DLLIB}.py --network ${NETWORK} \
                --dtype ${DTYPE} \
                --batch-size ${BATCH_SIZE} \
                --n-sample 1000 \
                --n-epoch ${N_EPOCH} \
                --warm-up-num ${WARM_UP_NUM} \
                --gpu 0
        done
    done
done

for NETWORK in ${NETWORK_LIST}
do
    ${PYTHON} plot_speed.py --network ${NETWORK}
done
