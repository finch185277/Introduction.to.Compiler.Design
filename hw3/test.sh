#!/bin/sh

input_folder="input"
output_folder="output"
no_error_folder="no-parsing-error"

input_error_files="test-minus-neg.p test-parser-error.p"
input_no_error_files=$(ls ${input_folder}/${no_error_folder})

if [ ! -d ${output_folder}/${no_error_folder} ] || [ ! -d ${output_folder}/${no_error_folder} ]; then
  mkdir -p ${output_folder}
  mkdir -p ${output_folder}/${no_error_folder}
fi

for file in ${input_error_files}; do
  echo "--------------- [${file}] ---------------"
  ./parser < ${input_folder}/"${file%.*}".p > ${output_folder}/"${file%.*}".txt
done

for file in ${input_no_error_files}; do
  echo "--------------- [${file}] ---------------"
  ./parser < ${input_folder}/${no_error_folder}/"${file%.*}".p > ${output_folder}/${no_error_folder}/"${file%.*}".txt
done
