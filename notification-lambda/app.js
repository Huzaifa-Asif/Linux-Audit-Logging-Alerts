const zlib = require('zlib');
const { promisify } = require('util');

const gunzipAsync = promisify(zlib.gunzip);
const SlackWebHookApiCall = require('./utils/APIClient.js');

exports.lambdaHandler = async (event) => {
    try {
        // Log the event in the cloudwatch logs 
        console.log(JSON.stringify(event));

        // Get the environment variable
        const environment = process.env.ENVIRONMENT || 'staging';

        // Decode the base64 encoded log data
        const payload = Buffer.from(event.awslogs.data, 'base64');

        // Decompress the log data
        const decompressed = await gunzipAsync(payload);

        // Convert the log data from JSON string to an object
        const logData = JSON.parse(decompressed.toString('utf8'));

        // Process the log data
        console.log('Decoded log data:', logData);
        
        // Example: Iterate through log events
        if (logData.logEvents.length === 0) {
            console.log('No log events to process.');
            return;
        }

        // Iterate through log events and create a Slack message
        const slackMessageArray = logData.logEvents.map(logEvent => {
            console.log('Log event:', logEvent);
            return `\n • ${logEvent?.extractedFields?.command}`
        });

        // Join the array into a single string
        const slackMessage = slackMessageArray.join('');

        // Trigger Slack webhook Api to send a notification to a Slack channel
        await SlackWebHookApiCall(environment, slackMessage);
    } catch (error) {
        console.log('An error occurred while trying to send a notification to Slack.');
        console.log(error);
        return { error };
    }
};