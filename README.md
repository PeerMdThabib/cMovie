# cMovie

## Installation

### Carthage
After cloning this repository please make sure to run carthage update to install
the following frameworks:

#### Networking, 
- Alamofire 
- AlamofireImage 
- SwiftyJSON 

#### Persistence Store, 
- Realm / RealmSwift 

#### Test suites, 
- Quick 
- Nimble

Make sure you are in /Movie project directory and run the following command in terminal

```
carthage update --platform iOS
```
All packages should be installed and ready for build. In case if you get the following error 

Reference to [Realm_issue](https://github.com/realm/realm-cocoa/issues/5709)

![cMovie](https://github.com/Sa74/cMovie/blob/master/realm.jpeg)



Then re-run carthage update with --no-use-binaries option as follows,


```
carthage update --no-use-binaries --platform iOS
```

Now you should be all set to build and run the application without any error

Please make sure to run the tests first to avoid any issues releated to XCTest and run the application.
