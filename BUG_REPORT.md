# Bug Report

## 1. Issue with Hoover State Retention Between Runs

### Description
The robotic hoover service incorrectly retains state between consecutive runs. When patches of dirt are modified in subsequent inputs (either added or removed), the service continues to use the previous state, leading to incorrect counts of cleaned patches.

### Steps to Reproduce

1. **Run 1: Initial Input**
    - **Input:**
      ```json
      {
        "roomSize": [5, 5],
        "coords": [1, 2],
        "patches": [
          [1, 0],
          [2, 2],
          [2, 3]
        ],
        "instructions": "NNESEESWNWW"
      }
      ```
    - **Expected Output:**
      ```json
      {
        "coords": [1, 3],
        "patches": 1
      }
      ```
    - **Actual Output:**
      ```json
      {
        "coords": [1, 3],
        "patches": 1
      }
      ```
    - **Result:** Passed

2. **Run 2: Adding a New Patch**
    - **Input:**
      ```json
      {
        "roomSize": [5, 5],
        "coords": [1, 2],
        "patches": [
          [1, 0],
          [2, 2],
          [2, 3],
          [3, 3]
        ],
        "instructions": "NNESEESWNWW"
      }
      ```
    - **Expected Output:**
      ```json
      {
        "coords": [1, 3],
        "patches": 2
      }
      ```
    - **Actual Output:**
      ```json
      {
        "coords": [1, 3],
        "patches": 2
      }
      ```
    - **Result:** Passed

3. **Run 3: Removing the New Patch**
    - **Input:**
      ```json
      {
        "roomSize": [5, 5],
        "coords": [1, 2],
        "patches": [
          [1, 0],
          [2, 2],
          [2, 3]
        ],
        "instructions": "NNESEESWNWW"
      }
      ```
    - **Expected Output:**
      ```json
      {
        "coords": [1, 3],
        "patches": 1
      }
      ```
    - **Actual Output:**
      ```json
      {
        "coords": [1, 3],
        "patches": 2
      }
      ```
    - **Result:** Failed
## Scenario to Demonstrate the Issue
```gherkin
Scenario: Add and remove patches of dirt
    Given the room size is 5 by 5
    And the hoover starts at position 1, 2
    And the patches of dirt are at positions
      | x | y |
      | 1 | 0 |
      | 2 | 2 |
      | 2 | 3 |
    When the instructions are "NNESEESWNWW"
    Then the final position should be 1, 3
    And the number of patches cleaned should be 1

    # Adding a new patch
    Given the patches of dirt are at positions
      | x | y |
      | 1 | 0 |
      | 2 | 2 |
      | 2 | 3 |
      | 3 | 3 |
    When the instructions are "NNESEESWNWW"
    Then the final position should be 1, 3
    And the number of patches cleaned should be 2

    # Removing the new patch
    Given the patches of dirt are at positions
      | x | y |
      | 1 | 0 |
      | 2 | 2 |
      | 2 | 3 |
    When the instructions are "NNESEESWNWW"
    Then the final position should be 1, 3
    And the number of patches cleaned should be 1
```
### Expected Behavior
The service should reset its state between runs, correctly processing the patches as specified in each new input. The patch count should be recalculated based on the current input and should not retain data from previous runs.

### Actual Behavior
The service retains the patch-cleaning state from the previous runs, leading to incorrect outputs. Specifically, even when patches are removed from the input, the service still counts them as if they were present.

### Severity
High

### Impact
This bug can lead to significant issues in real-world usage, where inputs may change frequently. Incorrect outputs undermine the reliability of the service and can lead to inaccurate reporting of cleaned patches.

### Suggested Fix
Ensure that the service resets its internal state with each new input request. All data should be refreshed, and no data should be retained from previous runs unless explicitly required.

## 2. Hoover Fails to Correctly Handle Movement at Room Boundaries

## Issue Summary
When the hoover receives movement instructions that would direct it out of the room boundaries, it incorrectly processes these commands. 
Specifically, the hoover should be restricted from moving outside the room, but currently, it does not handle this scenario properly, leading to unexpected results.

## Steps to Reproduce
1. Set up the room with the following configuration:
   - Room size: `5x5`
   - Initial hoover position: `(1, 2)`
   - Patches of dirt: none
2. Provide the movement instructions: `"SSNN"`

## Expected Behavior
- The hoover should interpret the following instructions:
   - The first "S" moves it to `(1, 1)`.
   - The second "S" attempts to move it out of bounds to `(1, 0)`, but the hoover should be restricted and remain at `(1, 1)`.
   - The first "N" moves it back to `(1, 2)`.
   - The second "N" moves it to `(1, 3)`.
- **Final Position:** The hoover should end at `(1, 3)`.
- **Patches Cleaned:** `0`

## Actual Behavior
- The hoover remains at the initial position `(1, 2)` and does not process the "SSNN" instructions as expected.
- **Final Position:** `(1, 2)`
- **Patches Cleaned:** `0`

## Scenario to Demonstrate the Issue
```gherkin
Scenario: Hoover movement restricted by room boundaries
  Given the room size is 5 by 5
  And the hoover starts at position 1, 2
  And the patches of dirt are at positions
    | x | y |
  When the instructions are "SSNN"
  Then the final position should be 1, 3
  And the number of patches cleaned should be 0
```
## Impact
This bug affects the hoover's ability to handle movement commands correctly, especially when moving near the room's edges. If the hoover fails to respect room boundaries, it may lead to incorrect final positions, impacting the cleaning service's reliability.

## Recommended Fix
Update the movement logic to ensure that the hoover does not move outside the defined room dimensions. Commands that would take the hoover out of bounds should be ignored, and the hoover should remain at the current valid position.

## 3. Incorrect Handling of Multiple Patches at Same Position

## Description
The cleaning service fails to correctly count patches of dirt when multiple patches are located at the same position. Despite the hoover cleaning the position, the count of cleaned patches is incorrect.

## Steps to Reproduce
1. Set the room size to `5x5`.
2. Start the hoover at position `1, 2`.
3. Place patches of dirt at:
   - `1, 2`
   - `1, 2`
   - `1, 2` (multiple patches at the same spot)
4. Issue the instructions: `"NNESEESWNWW"`

## Expected Result
- The hoover should end up at coordinates `(1, 3)`.
- The number of patches cleaned should be `1`, regardless of multiple patches at the same location.
## Actual Result
```json
{
  "coords": [1, 3],
  "patches": 0
}
```
## Scenario to Demonstrate the Issue
```gherkin

Scenario: Hoover cleaning multiple patches at the same position
  Given the room size is 5 by 5
  And the hoover starts at position 1, 2
  And the patches of dirt are at positions
    | x | y |
    | 1 | 2 |
    | 1 | 2 |
    | 1 | 2 |
  When the instructions are "NNESEESWNWW"
  Then the final position should be 1, 3
  And the number of patches cleaned should be 1
```
## Impact
This bug affects the hoover's ability to clean patches when there are multiple entries for the same location. It incorrectly reports 0 patches cleaned, which could mislead users about the cleaning service's performance.
## Recommended Fix
Update the cleaning logic to correctly handle multiple patches at the same coordinates. The hoover should only count the patch once, even if it encounters multiple patches at the same position, ensuring accurate reporting of cleaned patches.

## 4. Hoover incorrectly moves out of boundary position `(0,0)
**Description**:
When the hoover starts at the bottom-left corner of the room `(0,0)`, it should not be able to move south or west as those directions are out of the room's bounds. However, the actual result shows that the hoover moved north to position `(0,1)` even though the instructions were `SWWN`. This indicates a failure in enforcing boundary restrictions correctly.

**Steps to Reproduce**:
1. Set the room size to `5x5`.
2. Initialize the hoover at position `(0,0)`.
3. Provide the patches of dirt (none in this scenario).
4. Execute the movement instructions `"SWWN"`.

## Expected Result
- The hoover should remain at the initial position `(0,0)` after attempting to move south and west, as these are out of bounds.
- The final output should be:
  ```json
  {
      "coords": [0, 0],
      "patches": 0
  } 
  ```
## Actual Result
```json
{
  "coords": [0, 1],
  "patches": 0
}
```
## Scenario to Demonstrate the Issue
```gherkin
Scenario: Hoover starts at the room boundary
  Given the room size is 5 by 5
  And the hoover starts at position 0, 0
  And the patches of dirt are at positions
    | x | y |
  When the instructions are "SWWN"
  Then the final position should be 0, 0
  And the number of patches cleaned should be 0
```
## Impact
This bug affects the hoover's ability to correctly follow movement instructions when starting at or near room boundaries. If boundary restrictions aren't properly enforced, the hoover may end up in incorrect positions, leading to unreliable cleaning performance.
## Recommended Fix
Ensure the movement logic correctly checks room boundaries before executing a move. If the move would take the hoover out of bounds, the command should be ignored, and the hoover should remain in its current valid position.

## 5. Out-of-Bounds Movement Not Handled Correctly

## Description
The hoover is expected to handle out-of-bounds movements properly when given driving instructions that would take it beyond the defined room dimensions. However, in the scenario where the room size is 5 by 5 and the hoover starts at position (1, 2) with movement instructions that exceed the room boundaries, the actual result does not raise an exception.

## Steps to Reproduce
1. Set the room size to 50 by 50.
2. Initialize the hoover's position at (10, 20).
3. Define patches of dirt at positions (30, 30), (10, 10), and (45, 45).
4. Provide the movement instructions: "NNNNNNEEEEEESSSSSWWWWWNNNN".
5. Execute the hoover movement.

## Expected Result
- An out-of-bounds exception should be raised when the hoover attempts to move beyond the defined room dimensions.

## Actual Result
```json
{
    "coords": [
        11,
        25
    ],
    "patches": 0
} 
```
## Scenario to Demonstrate the Issue
```gherkin
  Scenario: Handling out-of-bounds movements with large dimensions
    Given the room size is 50 by 50
    And the hoover starts at position 10, 20
    And the patches of dirt are at positions
      | x | y |
      | 30 | 30 |
      | 10 | 10 |
      | 45 | 45 |
    When the instructions are "NNNNNNEEEEEESSSSSWWWWWNNNN"
    Then an out-of-bounds exception should be raised
    And the number of patches cleaned should be 0
```
## Impact
This bug affects the hoover's ability to handle room boundaries, which can lead to unpredictable behavior and incorrect final positions when the hoover receives movement instructions that exceed the defined limits of the room.
## Recommended Fix
Implement boundary checks that raise exceptions when the hoover attempts to move outside the defined room dimensions. This will ensure that the hoover's movements are always valid and within the specified room size.