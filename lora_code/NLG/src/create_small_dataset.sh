#!/bin/bash

# Paths
path=data/e2e
small_path=data/e2e/small
mkdir -p $small_path

# Function to create smaller datasets
create_smaller_file() {
    input_file=$1
    output_file=$2
    num_lines=$3
    head -n $num_lines $input_file > $output_file
}

# Create smaller train, valid, and test datasets
echo "Creating smaller datasets..."
echo "Extracting first 1000 lines from train.txt..."
create_smaller_file $path/train.txt $small_path/train.txt 1000
echo "Extracting first 200 lines from valid.txt..."
create_smaller_file $path/valid.txt $small_path/valid.txt 200
echo "Extracting first 20 lines from test.txt..."
create_smaller_file $path/test.txt $small_path/test.txt 20

# Format and encode the smaller datasets
echo "Formatting and encoding datasets..."
echo "Train..."
python src/format_converting_e2e.py $small_path/train.txt $small_path/train_formatted.jsonl
python src/gpt2_encode.py --vocab vocab --input $small_path/train_formatted.jsonl --output $small_path/train.jsonl --add_bos --add_eos

echo "Test..."
python src/format_converting_e2e.py $small_path/test.txt $small_path/test_formatted.jsonl
python src/gpt2_encode.py --vocab vocab --input $small_path/test_formatted.jsonl --output $small_path/test.jsonl --add_bos --add_eos

echo "Valid..."
python src/format_converting_e2e.py $small_path/valid.txt $small_path/valid_formatted.jsonl
python src/gpt2_encode.py --vocab vocab --input $small_path/valid_formatted.jsonl --output $small_path/valid.jsonl --add_bos --add_eos

echo "Smaller dataset creation complete!"
