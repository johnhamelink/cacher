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

test-prof:
    just prof {{jestFile}} --config jest.config.ts --color

# Run jest with remote debugging enabled
bench:
    node {{jestFile}} --config {{benchConfig}}

# Run benchmarks with remote debugging enabled
bench-debug:
    just debug node {{jestFile}} --runInBand --config {{benchConfig}}

bench-prof:
    just prof {{jestFile}} --config {{benchConfig}}

debug executable *args:
    {{executable}} --inspect-brk {{args}}

# Run benchmarks
prof *args:
    #! /usr/bin/env -S nix shell nixpkgs#bash nixpkgs#coreutils nixpkgs#nodejs --command bash
    mkdir -p prof
    echo -e "\n\tProfiling...\n"
    node --prof --logfile=prof/prof.log {{args}}
    rm -rf ./prof/*.json
    for i in ./prof/*.log; do
        echo -e "\n\tConverting from V8 log -> V8 JSON...\n"
        node --prof-process --preprocess -j ${i} > ${i}.json
        echo -e "\n\tCompiling a CPUPro Report...\n"
        cpupro -o prof ${i}.json
    done
    # TODO: Generate an index.html
