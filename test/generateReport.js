const reporter = require('cucumber-html-reporter');

const options = {
    theme: 'bootstrap',
    jsonFile: './reports/cucumber_report.json',
    output: './reports/cucumber_report.html',
    reportSuiteAsScenarios: true,
    launchReport: true, // This will automatically open the report in your default browser
    metadata: {
        "App Version": "1.0.0",
        "Test Environment": "STAGING",
        "Browser": "Chrome 114",
        "Platform": "Mac OS",
        "Parallel": "Scenarios",
        "Executed": "Remote"
    }
};

reporter.generate(options);
