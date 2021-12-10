# Echidna action

This action allows you to run `echidna-test` from within a GitHub Actions
workflow.

## Inputs

### `files`

**Required** Solidity files or folders to analyze

### `contract`

Contract to analyze

### `config`

Config file (CLI arguments override config options)

### `format`

Output format: json, text, none. Disables interactive UI

### `corpus-dir`

Directory to store corpus and coverage data

### `check-asserts`

Check asserts in the code

### `multi-abi`

Use multi-abi mode of testing

### `test-limit`

Number of sequences of transactions to generate during testing

### `shrink-limit`

Number of tries to attempt to shrink a failing sequence of transactions

### `seq-len`

Number of transactions to generate during testing

### `contract-addr`

Address to deploy the contract to test

### `deployer`

Address of the deployer of the contract to test

### `sender`

Addresses to use for the transactions sent during testing

### `seed`

Run with a specific seed

### `crytic-args`

Additional arguments to use in crytic-compile for the compilation of the
contract to test

### `solc-args`

Additional arguments to use in solc for the compilation of the contract to test

### `solc-version`

Version of the Solidity compiler to use

### `negate-exit-status`

Apply logical NOT to echidna-test's exit status (for testing the action)


## Outputs

This action has no outputs.


## Example usage

```yaml
uses: crytic/echidna-action@v1
with:
  files: contracts/
  contract: Marketplace
```
