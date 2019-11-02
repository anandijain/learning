#!/bin/bash

function test_both(){
    echo python:
    python req.py
    echo julia:
    julia req.jl
} 

test_both
