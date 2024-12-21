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

# Run benchmarks with V8 CPU profiling enabled
bench-prof:
    just prof {{jestFile}} --config {{benchConfig}}

debug executable *args:
    {{executable}} --inspect-brk {{args}}

# Run profiler & turn output into preprocessed JSON.
prof *args:
    #! /usr/bin/env -S nix shell nixpkgs#bash nixpkgs#coreutils nixpkgs#nodejs --command bash
    mkdir -p prof
    rm -rf ./prof/*.json
    echo -e "\n\tProfiling...\n"
    node --prof --logfile=prof/prof.log {{args}}
    for i in ./prof/*.log; do
        echo -e "\n\tConverting ${i} from V8 log -> V8 JSON...\n"
        node --prof-process --preprocess -j ${i} > ${i}.json
    done

# Build HTML reports from Preprocessed JSON and serve the from a
# web-server.
prof-reports:
    #! /usr/bin/env -S nix shell nixpkgs#bash nixpkgs#coreutils nixpkgs#nodejs --command bash
    pushd prof
    rm -rf reports
    mkdir -p reports
    for i in *.json; do
        echo -e "\n\tCompiling a CPUPro Report...\n"
        cpupro --no-open --output-dir reports ${i}
    done

    npx http-server -o --port 0 ./reports
