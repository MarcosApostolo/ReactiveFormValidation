#  Reactive Form Validation

This is a project to practice iOS skills. The objective is to implement a complex form with multiple validations for each field.
The validations are implemented using RxSwift. The project was also developed with TDD.

### Validations:

#### Name Form Field

- Required: Must not be empty

#### Email Form Field

- Required: Must not be empty
- Valid email format

#### Username Form Field

- Required: Must not be empty
- Max Length: Must be less than or equal 32 characters
- Unique: Username must be unique. Checked using a mock async validation

#### Password Form Field

- Min Length: Must have at least 8 characters
- Max Length: Must be less than or equal 16 characters
- Password must be confirmed

