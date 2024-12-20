jestFile := "./node_modules/jest/bin/jest.js"
benchConfig := "jest-bench.config.ts"

default:
    just --list

# Use tsc to compile the project
build:
    npx tsc -w

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
    #! /usr/bin/env -S nix shell nixpkgs#bash nixpkgs#coreutils --command bash
    node --prof {{jestFile}} --config {{benchConfig}}
    rm -rf prof && mkdir prof
    for f in isolate*.log; do
      mv $f prof/
      pushd prof
        node --prof-process -j $f | tee processed_$f
      popd
    done

# Run benchmarks with remote debugging enabled
bench-debug:
    just debug node {{jestFile}} --runInBand --config {{benchConfig}}

debug executable *args:
    {{executable}} --inspect-brk {{args}}
