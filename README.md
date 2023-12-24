# Automatic Release
Automatic Release is a _composite_ GitHub Action that joins together multiple actions to automate your project releases.

It does so by:
- setting up Java to the specified version in `with.java-version`;
- find out what build tool you are using:
  - if you are using **Maven**, it loads the project variables (_version_ and _modules_) from your `pom.xml` file and builds it using `mvn package`;
  - if you are using **Gradle**, it loads the project variables from both your `build.gradle` and `settings.gradle` files and builds it using `./gradlew build`;
  - if you are using **none of the above**, the action fails (**Apache Ant is NOT supported**).
- finally,
  it uses the previous loaded variables to create a new release with tag
  `$VERSION` and uses your `$COMMIT_MESSAGE` as the description.
Every file found during the compilation process will be published.

To start using it, create a new workflow and insert the following:
```yaml
# Name of the action
name: Automatic Release

# Event to run on
on:
  # Will run on every push in the "main" branch
  push:
    branches:
      - main

permissions:
  contents: write

# Jobs that will execute
jobs:
  release:
    name: Setup Environment, Build JAR and Release Project
    runs-on: ubuntu-latest
    steps:
      - name: Automatic Release
        uses: Fulminazzo/java-automatic-release@1.0
        with:
          java-version: 8
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          REPOSITORY_NAME: ${{ github.event.repository.name }}
          # Message specified in the commit
          COMMIT_MESSAGE: ${{ github.event.head_commit.message }}
```