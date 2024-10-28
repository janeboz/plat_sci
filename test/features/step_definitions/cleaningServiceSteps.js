const { Given, When, Then } = require('@cucumber/cucumber');
const assert = require('assert');
const axios = require('axios');

let roomWidth, roomHeight, startX, startY, patches, instructions, finalPosition, patchesCleaned;

Given('the room size is {int} by {int}', function (width, height) {
    roomWidth = width;
    roomHeight = height;
});

Given('the hoover starts at position {int}, {int}', function (x, y) {
    startX = x;
    startY = y;
});

Given('the patches of dirt are at positions', function (dataTable) {
    patches = dataTable.raw().map(row => ({ x: parseInt(row[0]), y: parseInt(row[1]) }));
});

When('the instructions are {string}', async function (instr) {
    instructions = instr;
    // Call the service and get the result
    const result = await callCleaningService(roomWidth, roomHeight, startX, startY, patches, instructions);
    finalPosition = result.coords;
   // console.log(`Final position: ${finalPosition}`);
    patchesCleaned = result.patches;
});

Then('the final position should be {int}, {int}', function (x, y) {
    assert.deepStrictEqual(finalPosition, [x, y]);
});

Then('the number of patches cleaned should be {int}', function (expectedCleanPatches) {
    // console.log(`Actual patches cleaned: ${patchesCleaned}`);
    // console.log(`Expected patches cleaned: ${expectedCleanPatches}`);
    assert.strictEqual(patchesCleaned, expectedCleanPatches);
});

Then('an out-of-bounds exception should be raised', function () {
    try {
        // Simulate the hoover movement that should raise an exception
        this.hoover.moveTo(this.finalPosition[0], this.finalPosition[1]);
    } catch (error) {
        // Store the error for the next step to check the message
        this.error = error;
        return;
    }
    throw new Error('Expected an out-of-bounds exception, but none was thrown.');
});


async function callCleaningService(roomWidth, roomHeight, startX, startY, patches, instructions) {
    try {
        // Filter out any null or invalid patches
        const validPatches = patches
            .filter(patch => patch.x !== null && patch.y !== null && !isNaN(patch.x) && !isNaN(patch.y))
            .map(patch => [patch.x, patch.y]);

        // console.log('Payload:', {
        //     roomSize: [roomWidth, roomHeight],
        //     coords: [startX, startY],
        //     patches: validPatches,
        //     instructions: instructions
        // });

        const response = await axios.post('http://localhost:8080/v1/cleaning-sessions', {
            roomSize: [roomWidth, roomHeight],
            coords: [startX, startY],
            patches: validPatches,
            instructions: instructions
        });

        return response.data;
    } catch (error) {
        console.error('Error:', error.response ? error.response.data : error.message);
        throw error;
    }
}

