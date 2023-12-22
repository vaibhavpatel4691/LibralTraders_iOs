# Magento 2
# Minimum Version 11.0

### For setup the application:

- Go to AppConfiguration.swift file:
- write your key credential:

```
var baseDomain = "xxxxxx:xxxxxxxxxxxxxxxxxxxxxxxxx" // Magento
var hostName = baseDomain+"/index.php/"
var apiUserName  = "xxxxx"
var apiKey = "xxxxx"
```

# # For setup color code in app:

I have set some default color:  (All are hexa form data)

```
static let accentColor = UIColor(named: "AccentColor") (Please refere screenshot : http://prntscr.com/n7tbe5) 
static let primaryColor = UIColor(named: "primary")! (Please refere screenshot : --------) 
```

# For Push notification
- Change the topic from "mobikul_ios" to "<user-defined>" same as in Admin panel under Notification Configuration (iOS Topic heading)
- Change GoogleService-Info.plist file
- [Set UP Push Notification check ](https://mobikul.com/use-rich-push-notification-ios-using-swift-3-4/)

# For google Map key:

- Go to AppDelegate.swift file:
- change the:
- GMSServices.provideAPIKey("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");

# For Add New Localization:

1: Select project
2: under project select "localization"
3:click on "+"
4: Add your required file.
5: Now open the add file and change the value according to your requirement:

like  home = "Home";
to
home = "Required language";

# For change value

1: select Localizable.string file
2: and change the value with respective key.

# For App icon, SplashScreen & Placeholder icon 

- Go to Assets.xcassets folder and change this.

# For Bundle ID & App Name :

- Select Projecrt & Targets 
- Change the Display name & BundleIdentifier
- Localizable.strings file - Change "applicationname" 
