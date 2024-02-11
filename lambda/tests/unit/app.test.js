const zlib = require('zlib');

jest.mock('../../utils/APIClient.js');
const { lambdaHandler } = require('../../app.js');
const SlackWebHookApiCall = require('../../utils/APIClient.js');


describe('lambdaHandler', () => {
    it('should process log events and send a Slack message', async () => {
        const mockLogData = {
            logEvents: [
                { extractedFields: { command: 'test command 1' } },
                { extractedFields: { command: 'test command 2' } },
            ],
        };
    
        // Convert the log data to a JSON string, compress it using gzip, and then encode it in base64
        const compressedLogData = zlib.gzipSync(JSON.stringify(mockLogData)).toString('base64');
    
        const mockEvent = {
            awslogs: {
                data: compressedLogData,
            },
        };
        
        // Define the environment variable
        process.env.ENVIRONMENT = 'test';

        await lambdaHandler(mockEvent);
    
        expect(SlackWebHookApiCall).toHaveBeenCalledWith('test', '\n • test command 1\n • test command 2');
    });

    it('should handle errors', async () => {
        const mockEvent = {
            awslogs: {
                data: 'invalid data',
            },
        };

        const response = await lambdaHandler(mockEvent);

        expect(response).toEqual(expect.objectContaining({ error: expect.anything() }));
    });
});