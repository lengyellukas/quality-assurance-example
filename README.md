# quality-assurance-example

Details

- azure-pipelines.yaml: the pipeline to build out the terraform tasks, and kick-off automated tests for Postman, Selenium, and JMeter
- /terraform: directory that holds all of the files needed for creating the test environment alongwith a .tfvars file to assign values to variables that have already been declared in .tf file.
- /jmeter: directory that holds all of the files needed to create the Stress Test and Endurance Test Suites
- /postman: Regression Test Suite and Data Validation Test Suite in Postman
- /selenium: directory with UI Test Suite task
