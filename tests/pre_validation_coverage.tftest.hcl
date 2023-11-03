run "examples_validation_coverage" {
  module {
   source = "./tests/examples-validation-coverage"
  }

  assert {
    condition = length(data.coverage_examples_validation.this.missing_tests) == 0
    error_message = "Err: Validation tests cases missing for: ${join(", ", data.coverage_examples_validation.this.missing_tests)}"
  }
}
