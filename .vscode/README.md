Create a file launch.json and paste the following code, replacing `UPDATE_WITH_YOUR_ENDPOINT_URL_FROM_HASURA_CLOUD` with your own hasura cloud endpoint:

```json
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "financy_app",
            "request": "launch",
            "type": "dart",
            "toolArgs": [
                "--dart-define=GRAPHQL_ENDPOINT=UPDATE_WITH_YOUR_ENDPOINT_URL_FROM_HASURA_CLOUD",
            ]
        },
        {
            "name": "financy_app (profile mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "profile",
            "toolArgs": [
                "--dart-define=GRAPHQL_ENDPOINT=UPDATE_WITH_YOUR_ENDPOINT_URL_FROM_HASURA_CLOUD",
            ]
        },
        {
            "name": "financy_app (release mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "release",
            "toolArgs": [
                "--dart-define=GRAPHQL_ENDPOINT=UPDATE_WITH_YOUR_ENDPOINT_URL_FROM_HASURA_CLOUD",
            ]
        }
    ]
}
```