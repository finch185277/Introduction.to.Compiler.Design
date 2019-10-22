#!/bin/sh

input_folder="input"
output_folder="output"
filename=$(ls ${input_folder})

mkdir ${output_folder}
for file in ${filename}; do
  ./parser ${input_folder}/"${file%.*}".p > ${output_folder}/"${file%.*}".txt
  echo "${file} be output"
done
