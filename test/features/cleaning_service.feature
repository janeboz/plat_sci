Feature: Cleaning Service

  # Scenario to run without issues on first run
  Scenario: Add and remove patches of dirt (without bug)
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

  Scenario: No patches of dirt
    Given the room size is 5 by 5
    And the hoover starts at position 1, 2
    And the patches of dirt are at positions
      | x | y |
    When the instructions are "NNESEESWNWW"
    Then the final position should be 1, 3
    And the number of patches cleaned should be 0

  # Scenario to test movement restrictions by room boundaries
  Scenario: Hoover movement restricted by room boundaries
    # The hoover is expected to start at position (1, 2) and follow the movement instructions "SSNN".
    # If it attempts to move south beyond the room boundary, it should be restricted.
    Given the room size is 5 by 5
    And the hoover starts at position 1, 2
    And the patches of dirt are at positions
      # No patches of dirt are placed in this scenario.
      | x | y |
    When the instructions are "SSNN"
      # - The first "S" moves it to (1, 1)
      # - The second "S" attempts to move it out of bounds (to (1, 0)), but should be restricted and stay at (1, 1)
      # - The first "N" moves it to (1, 2)
      # - The second "N" moves it to (1, 3)
    Then the final position should be 1, 3
      # Expecting the final position to be (1, 3) after valid moves within the room boundary
    And the number of patches cleaned should be 0
      # Since no patches were present, the hoover should report 0 patches cleaned.

  Scenario: Hoover does not move
    Given the room size is 5 by 5
    And the hoover starts at position 1, 2
    And the patches of dirt are at positions
      | x | y |
      | 1 | 2 |
    When the instructions are ""
    Then the final position should be 1, 2
    And the number of patches cleaned should be 1

# Scenario to handle multiple patches at the same position
  Scenario: Multiple patches at the same position
    Given the room size is 5 by 5
    And the hoover starts at position 1, 2
    # Adding multiple patches of dirt at the same position (1, 2)
    And the patches of dirt are at positions
      | x | y |
      | 1 | 2 |
      | 1 | 2 |
      | 1 | 2 |
    When the instructions are "NNESEESWNWW"
    Then the final position should be 1, 3
    # Expected number of patches cleaned should be 1 since there are multiple patches at the same spot
    And the number of patches cleaned should be 1

  # Scenario to demonstrate the issue with adding and removing patches
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

  Scenario: Hoover starts at the room boundary
    Given the room size is 5 by 5
    And the hoover starts at position 0, 0
    And the patches of dirt are at positions
      | x | y |
    When the instructions are "SWWN"
    Then the final position should be 0, 0
    And the number of patches cleaned should be 0

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