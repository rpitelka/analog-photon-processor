#!/bin/sh

if [ ! -x output ] ; then
    mkdir output
fi

if [ ! -x report ] ; then
    mkdir report
fi

genus -f rc.tcl
