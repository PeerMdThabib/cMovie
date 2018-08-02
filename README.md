# cMovie

## Installation

### Carthage
After cloning this repository please make sure to run carthage update. To install
the following farmeworks:

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
[Realm_issue](https://github.com/realm/realm-cocoa/issues/5709)


Then re-run carthage update with --no-use-binaries option as follows,


```
carthage update --no-use-binaries --platform iOS
```
Now you should be all set to build and run the application without any error
