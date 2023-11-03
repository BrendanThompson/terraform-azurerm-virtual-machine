terraform {
  required_providers {
    coverage = {
      source = "BrendanThompson/coverage"
    }
  }
}

data "coverage_examples_validation" "this" {
    examples_directory = "./examples"
    tests_directory = "./tests"
    filter = "validate_"
}
