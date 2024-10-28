Platform Science Software Development Engineer in Test assignment
==========================================
## How to execute the service to test
### Requirements
- Docker v.18+

### Building the service
From the root of this repository, run the following:

- `sudo chmod +x service/run.sh`
- `docker build -t pltsci-sdet-assignment service`

### Running the service
- `docker run -d -p 8080:8080 --name pltsci-sdet-assignment pltsci-sdet-assignment`

### Hitting the endpoint
You can test whether the service is running correctly by executing the following command:
- `curl -H 'Content-Type: application/json' -X POST -d '{ "roomSize" : [5, 5], "coords" : [1, 2], "patches" : [ [1, 0], [2, 2], [2, 3] ], "instructions" : "NNESEESWNWW" }' http://localhost:8080/v1/cleaning-sessions`

## How to execute the service to test
### Running the Tests
Navigate to the test directory and install the dependencies:

- `cd test`
- `npm install`

Then run the tests:
- `npm test`

### Generating the Report
To generate the test report, run:
- `npm run generate-report`
This will create an HTML report in the reports directory and automatically open it in your default browser
### Test Approach
The test scenarios were structured to cover:

- **Edge case: Hoover at boundary** - Tests the hoover's behavior when it starts at the boundary and receives a command to move outside the room.
- **Edge case: Repeated movement commands** - Tests the hoover's behavior when it receives multiple commands to move in the same direction.
- **Cleaning all dirt patches** - Tests the hoover's ability to clean all specified dirt patches in the room.
- **Validating final hoover position** - Ensures the hoover ends up at the correct final position based on the input instructions.

### Assumptions & Limitations
- It is assumed that the hoover will not move outside the defined room dimensions.
- The input JSON structure must strictly follow the provided format.

### Bug Report
Please see BUG_REPORT.md for a list of bugs found during testing.
