const axios = require('axios');
const { SLACK_WEBHOOK_BASE_URL } = require('../constants');

const SlackWebHookApiCall = async (environment, command) => {
    const data = JSON.stringify({
        environment,
        suspicious_command: command,
    });

    const config = {
        method: 'post',
        url: SLACK_WEBHOOK_BASE_URL,
        headers: {
            'Content-Type': 'application/json'
        },
        data
    };

    console.log("SlackWebHookApiCall config: ", config)

    return axios.request(config);
}

module.exports = SlackWebHookApiCall;