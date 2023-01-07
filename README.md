# Google Docs Clone

Google Docs Clone was developed as a side project only for educational purposes.


## Key Features

* Responsive design.
* Supports all different platforms (Android, iOS, Web, Desktop).
* Robust navigation system.
* Sign in with Google.
* Creating new documents.
* Sharing documents among users.
* Documents live updates.

## Technical Tools

* Navigator v2.0 =====> Routemaster
* State Management ==> Riverpod
* Custom Server =====> NodeJS, MongoDB, Express.
* Realtime Updates ===> Socket.io


-----------------------------------------------------------------------
## How to run server

1- Open terminal.

2- run "cd server" to navigate to server project.

3- run "npm install" to install all packages.

4- run "npm run dev" to start the server.

* Note: you need to have node v12+ installed on your machine.


## How to run flutter

1- In the terminal, run "flutter pub get" to install all packages.

2- Follow the above steps to start the server.

3- Go to "lib/constants/api_constants.dart" file and update "baseUrl" with your private ip address.

4- Select the platform you want to run the project on, then run run project.

5- If you run the project on web, make sure to run it on port "3000".

* Note: Use this command to run flutter web on a specific port "flutter run -d chrome --web-port=3000".