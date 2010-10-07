#!/bin/bash
cat text/*.textile > tmp.textile
toc_generator.rb tmp.textile > book.html
rm tmp.textile
