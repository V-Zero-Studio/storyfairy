# StoryFairy

## Description

StoryFairy is an iOS app that allows users to create bedtime stories for 3-5 year old children. The app is designed to be used by parents, grandparents, and other family members to create stories with little effort.

## Project Architecture

The repository is organized as follows:

- `ios/`: The iOS app.
- `proxy/`: The proxy server that handles APIs and database access.

## Getting Started

### Run Proxy Server

Use development environment:

1. Install [Poetry](https://python-poetry.org/).
2. Run `poetry install` in the `proxy/` directory.
3. Add environment variables to running environment:

- OpenAI Api Key: `export OPENAI_API_KEY=sk-<your key>`
- MongoDB URI: `export MONGODB_URI=<your uri>`
- (Optional) IMGBB Api Key: `export IMGBB_KEY=<your key>`

4. Run `poetry run uvicorn main:app --reload` in the `proxy/` directory.

or use Docker:

1. Install [Docker](https://www.docker.com/).
2. Configure the mongodb connection string in `proxy/config/database.py`.
3. Modify `Dockerfile` to add environment variables:

- OpenAI Api Key: `ENV OPENAI_API_KEY sk-<your key>`
- MongoDB URI: `ENV MONGODB_URI <your uri>`
- (Optional) IMGBB Api Key: `ENV IMGBB_KEY <your key>`

### Run iOS App

1. Install [CocoaPods](https://cocoapods.org/).
2. Run `pod install` in the `ios/` directory.
3. Open `StoryFairy.xcworkspace` in Xcode.
4. Edit `ios/storyfairy/Endpoint/ServerEndpoint.swift:31` with your own proxy server address and port.

## License and Copyright

[Mozilla Public License v2.0](LICENSE)

©2018-2023 UCLA HCI Research. All rights reserved.
