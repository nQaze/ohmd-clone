# Build a HIPAA Compliant Telehealth app for iOS (OhMD Clone)

Read the full tutorial [here](https://www.dropbox.com/scl/fi/u5xjdvz2f1bamda7n2x5n/How-to-Build-a-HIPAA-Compliant-Telehealth-app-for-iOS-OhMD-Clone.paper?dl=0&rlkey=0dxsxeiy0q42sojnakcw8x1qm).

In this example, we have build a clone of OhMD app - A Telehealth app which allows doctors and patients to voice, video and text chat with each other.  The OhMD app looks like this - 

![OhMD](https://user-images.githubusercontent.com/13706140/106260660-a4f9d000-6246-11eb-8cff-04e8c90ec827.png)
<br><br>

## Technology

This demo uses:

1. CometChat Pro
2. Swift
3. Firebase Auth
4. Firebase Cloud Firestore
<br><br>

## Running the demo

To run the demo follow these steps:

1. Head to CometChat Pro and create an account
2. From the dashboard, create a new app called "OhMD Clone"
3. One created, click Explore
4. Go to the API & Auth Keys tab in the side menu
5. Copy the App ID, Auth Key & API Key.
6. Download the repository here or by running git clone and open it in Xcode.
7. Create a Constants.swift file with the below content - 
```
class Constants {
    static var appId = "YOUR_APP_ID"
    static var authKey = "YOUR_AUTH_KEY"
    static var apiKey = "YOUR_API_KEY"
    static var region = "YOUR_REGION"
}
```

8. Run the app and register yourself as a doctor and then as an patient to test.
<br><br>

Questions about running the demo? Open an [issue](https://github.com/cometchat-pro-samples/kotlin-group-chat/issues). We're here to help ✌
<br><br>

## Useful links

- 🏠 [CometChat Homepage](https://www.cometchat.com/pro/?utm_source=github&utm_medium=link&utm_campaign=ohmd-clone)
- 🚀 [Create your free account](https://app.cometchat.com/signup/?utm_source=github&utm_medium=link&utm_campaign=ohmd-clone)
- 📚 [Documentation](https://prodocs.cometchat.com/?utm_source=github&utm_medium=link&utm_campaign=ohmd-clone)
- 👾 [GitHub](https://www.github.com/cometchat-pro)
