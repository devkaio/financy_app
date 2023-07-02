#!/bin/bash
// Create coverage import file
file=test/coverage_helper_test.dart

// Import dart files
echo "// Helper file to make coverage work for all dart files\n" > $file
echo "// ignore_for_file: unused_import, avoid_relative_lib_imports" >> $file
find lib '!' -path '*generated*/*' '!' -name '*.g.dart' '!' -name '*.part.dart' '!' -name '*.freezed.dart' -name '*.dart' | awk -v package=$(grep -oP '(?<=name: ).*' pubspec.yaml | tr -d '\n') '{ relative_path = $0; gsub(/^lib\//, "", relative_path); printf "import '\''../lib/%s'\'';\n", relative_path }' >> $file
echo -e "\nvoid main() {}" >> $file
