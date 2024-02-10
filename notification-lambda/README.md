# Notification Lambda

## Description
This repository contains the code for the suspicious command notification. It is designed to send notifications when suspicious commands are detected.

## Getting Started

### Dependencies
This project requires Node.js and the following npm packages:
- axios (version 0.21.1 or later)
- jest (for testing)

### Installing
1. Clone the repository: `git clone https://github.com/Huzaifa-Asif/Linux-Audit-Logging-Alerts.git`
2. Navigate to the project directory: `cd Linux-Audit-Logging-Alerts`
3. Install the dependencies: `npm install`

### Executing program
Run the main application file: `node app.js`

## Testing
Run the test suite with the command: `npm test`

## Environment Variables
This project uses the following environment variables:
- `ENVIRONMENT`: The environment in which the lambda function is running. This is used when sending notifications to Slack.

## Slack Webhook
This project sends notifications to a Slack channel. You need to provide the URL of your Slack webhook in the `constants.js` file.

## Authors
This project was created by Huzaifa Asif. You can reach out at hello@huzaifa.io.

## License
This project is licensed under the GNU AFFERO GENERAL PUBLIC LICENSE Version 3.