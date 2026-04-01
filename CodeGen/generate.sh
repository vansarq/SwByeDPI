#!/bin/bash

generate_swift_domains() {
    if [ -z "$1" ]; then
        echo "❌ Empty source file"
        echo "Usage: generate_swift_domains <source_file.domains> [<output_path>]"
        return 1
    fi
    if [ ! -f "$1" ]; then
        echo "❌ $1 not found"
        return 1
    fi
    local source_file="$1"
    local source_filename_with_ext="${source_file##*/}"
    local output_swift_class="${source_filename_with_ext%.*}"

    local output_path="${output_swift_class}.swift"
    if [ -z "$2" ]; then
        echo "Not stated output path. Set from input - $output_path"
    else
        output_path="$2"
    fi

    echo "import Foundation" > "$output_path"
    echo "" >> "$output_path"
    echo "/// Generated domains from $source_filename_with_ext" >> "$output_path"
    echo "public final class $output_swift_class {" >> "$output_path"
    echo "  /// Domains list" >> "$output_path"
    echo "  public static let domainsList = SBDDomainList(name: \"$output_swift_class\", domains: Set<String>([" >> "$output_path"

    # Read the file line by line
    while IFS= read -r line || [[ -n "$line" ]]; do
    if [ -z "$line" ]; then
        continue
    fi
    echo "      \"$line\"," >> "$output_path"
    done < "$source_file"

    echo "  ]))" >> "$output_path"
    echo "  fileprivate init() {} }" >> "$output_path"
    echo "✅ Domains for $source_file have been generated at $output_path"
}

generate_swift_strategies() {
    if [ -z "$1" ]; then
        echo "❌ Empty source file"
        echo "Usage: generate_swift_strategies <source_file.strategies> [<output_path>]"
        return 1
    fi
    if [ ! -f "$1" ]; then
        echo "❌ $1 not found"
        return 1
    fi
    local source_file="$1"
    local source_filename_with_ext="${source_file##*/}"
    local output_swift_class="${source_filename_with_ext%.*}"

    local output_path="${output_swift_class}.swift"
    if [ -z "$2" ]; then
        echo "Not stated output path. Set from input - $output_path"
    else
        output_path="$2"
    fi

    echo "import Foundation" > "$output_path"
    echo "" >> "$output_path"
    echo "/// Generated strategies list from $source_filename_with_ext" >> "$output_path"
    echo "public final class $output_swift_class {" >> "$output_path"
    echo "  /// Strategies list" >> "$output_path"
    echo "  public static let strategiesList = SBDStrategyList(name: \"$output_swift_class\", strategies: Set<SBDStrategy>([" >> "$output_path"

    # Read the file line by line
    while IFS= read -r line || [[ -n "$line" ]]; do
    if [ -z "$line" ]; then
        continue
    fi
    # Set the Internal Field Separator (IFS) to the delimiter for the read command
    IFS=' ' read -ra splitted <<< "$line"

    # Example - SBDStrategy(cmdArgs: ["-s1", "-d1", "-r1+s", "-a1", "-Ar", "-o1", "-a1", "-At", "-r1+s", "-a1"]),
    local cmd_args=""
    # Loop through the resulting array
    for strategy_cmd_arg in "${splitted[@]}"; do
        cmd_args+="\"${strategy_cmd_arg}\","
    done
    echo "       SBDStrategy(cmdArgs: [$cmd_args])," >> "$output_path"
    done < "$source_file"

    echo "   ]))" >> "$output_path"
    echo "   fileprivate init() {} }" >> "$output_path"
    echo "✅ Strategies for $source_file have been generated at $output_path"
}

process_asset_folder() {
    if [ -z "$1" ]; then
        echo "❌ Empty source directory"
        echo "Usage: process_asset_folder <source_dir> <output_dir>"
        return 1
    fi
    local source_dir="$1"
    if [ ! -d "$source_dir" ]; then
        echo "❌ Source directory doesn't exist"
        return 1
    fi
    if [ -z "$2" ]; then
        echo "❌ Empty output directory path"
        echo "Usage: process_asset_folder <source_dir> <output_dir>"
        return 1
    fi
    local output_dir="$2"
    if [ ! -d "$output_dir" ]; then
        mkdir "$output_dir"
    fi
    
    # Domains process
    local target_files=("$source_dir"/*.domains)
    local source_filename_with_ext=""
    local output_swift=""
    declare -i local iterator=1
    declare -i local files_length="${#target_files[@]}"
    echo ""
    for file in "${target_files[@]}"; do
      echo "$iterator/$files_length Processing $file"
      source_filename_with_ext="${file##*/}"
      output_swift="${source_filename_with_ext%.*}"
      generate_swift_domains "$file" "$output_dir/$output_swift.swift"
      ((iterator += 1))
      echo ""
    done

    # Strategies process
    target_files=("$source_dir"/*.strategies)
    source_filename_with_ext=""
    output_swift=""
    declare -i iterator=1
    declare -i files_length="${#target_files[@]}"
    echo ""
    for file in "${target_files[@]}"; do
      echo "$iterator/$files_length Processing $file"
      source_filename_with_ext="${file##*/}"
      output_swift="${source_filename_with_ext%.*}"
      generate_swift_strategies "$file" "$output_dir/$output_swift.swift"
      ((ITERATOR += 1))
      echo ""
    done
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )
GENERATED_DIR="$SCRIPT_DIR/../Sources/SwByeDPI/Generated"
if [ ! -d "$GENERATED_DIR" ]; then
  mkdir "$GENERATED_DIR"
fi

process_asset_folder "$SCRIPT_DIR/../Assets" "$GENERATED_DIR"
process_asset_folder "$SCRIPT_DIR/../Assets/DPIBypassSLD" "$GENERATED_DIR"
process_asset_folder "$SCRIPT_DIR/../Assets/TestDomains" "$GENERATED_DIR"
