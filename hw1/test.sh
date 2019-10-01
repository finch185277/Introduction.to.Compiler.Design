#!/bin/sh

filename="Comments Error Escape Float Identifier Integer Operator ReservedWord String"
input_folder="input"
output_folder="output"

mkdir ${output_folder}
for input_file in ${filename}; do
	./scanner ${input_folder}/${input_file}.p 2> ${output_folder}/${input_file}.txt
  echo "${input_file} be output"
done
