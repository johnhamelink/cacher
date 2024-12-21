jestFile := "./node_modules/jest/bin/jest.js"
benchConfig := "jest-bench.config.ts"

default:
    just --list

# Use tsc to compile the project
build:
    tsc -w

# Run jest
test:
    node {{jestFile}} --projects --config jest.config.ts --color

# Run jest with remote debugging enabled
test-debug:
    just debug node {{jestFile}} --runInBand --config jest.config.ts --color

# Run jest with remote debugging enabled
bench:
    node {{jestFile}} --config {{benchConfig}}

# Run benchmarks
bench-prof:
    #! /usr/bin/env -S nix shell nixpkgs#bash nixpkgs#coreutils nixpkgs#nodejs --command bash
    mkdir -p prof
    echo -e "\n\tProfiling...\n"
    node --prof --no-logfile-per-isolate --logfile=prof/prof.log {{jestFile}} --config {{benchConfig}}
    echo -e "\n\tConverting from V8 log -> V8 JSON...\n"
    node --prof-process --preprocess -j prof/prof.log > prof/prof.json
    echo -e "\n\tCompiling a CPUPro Report...\n"
    cpupro -o prof prof/prof.json

# Run benchmarks with remote debugging enabled
bench-debug:
    just debug node {{jestFile}} --runInBand --config {{benchConfig}}

debug executable *args:
    {{executable}} --inspect-brk {{args}}
