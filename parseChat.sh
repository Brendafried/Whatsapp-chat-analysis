#!/bin/sh

DATA_DIR = .

cd $DATA_DIR
#replace hyphen with comma - used to seperate time column
sed -e 's/ -/,/g' chat.txt > chat_clean.txt

#remove all commas after the 3rd column
awk 'BEGIN {FS=","; OFS=","}
  NF >3{x=$3"," ; y=match($0,x);  string=substr($0,y);  gsub(/\,/,"",string); print $1, $2, string}
  NF<=3{print $1,$2,$3}' chat_clean.txt > chat_clean.txt

#remove all lines that don't start with a number (date)
sed '^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d' chat_clean.txt > chat_clean.txt

#replace second colon with comma - new column
sed 's/:/,/2' chat_clean.txt > chat_clean.txt
