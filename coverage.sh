#!/bin/bash
# Create coverage import file
file=test/coverage_helper_test.dart

# Grant write permissions to the test/ directory
chmod +w test/

# Import dart files with "package:financy_app/" prefix
echo "// Helper file to make coverage work for all dart files\n" > "$file"
echo "// ignore_for_file: unused_import, avoid_relative_lib_imports" >> "$file"

# Find Dart files and generate import statements
find lib -type f -name "*.dart" ! -path "lib/generated/*" | while read -r dart_file; do
  relative_path="${dart_file#lib/}"
  echo "import 'package:financy_app/$relative_path';" >> "$file"
done

echo -e "\nvoid main() {}" >> "$file"

