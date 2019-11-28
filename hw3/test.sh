#!/bin/sh

input_folder="input"
error_folder="error"
output_folder="output"

input_files=$(ls ${input_folder} | grep -v ${error_folder})
input_error_files=$(ls ${input_folder}/${error_folder})

if [ ! -d ${output_folder} ]; then
  mkdir -p ${output_folder}
fi

if [ ! -d ${output_folder}/${error_folder} ]; then
  mkdir -p ${output_folder}/${error_folder}
fi

for file in ${input_files}; do
  echo "--------------- [${file}] ---------------"
  ./parser < ${input_folder}/"${file%.*}".p > ${output_folder}/"${file%.*}".txt
done

for file in ${input_error_files}; do
  echo "--------------- [${file}] ---------------"
  ./parser < ${input_folder}/${error_folder}/"${file%.*}".p > ${output_folder}/${error_folder}/"${file%.*}".txt
done
