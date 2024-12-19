build:
    npx tsc -w

test:
    npm test

bench:
    npx jest --projects --config jest-bench.config.ts
