# Discovery: A simple library to discover and retrieve data from nearby devices.

![Screenshot](https://raw.githubusercontent.com/omergul123/Discovery/master/screenshot2.png)

Discovery is a very simple but useful library for discovering nearby devices with BLE(Bluetooth Low Energy) and for exchanging a value (kind of ID or username determined by you on the running app on peer device) regardless of whether the app on peer device works at foreground or background state.

## Version ##


###Discovery:###
* lets you easily discover nearby devices
* retrieve their id(assigned by you) while the app works on either foreground or background state
* hides the nitty gritty details of BLE calls and delegates from the developer
* determines the proximity of the peer device

###Version 1.1:###
* You can initialize Discovery either in only Detection or only Broadcasting mode. The default initializer will start the both.

## Example App ##

I added a simple but cool example alongside with the library. Simply download, run **pod install** and install it on two or more of your bluetooth enabled devices and have some fun. It works both on iPhone and iPad.

## Install

pod 'Discovery', '~> 1.0'

## Example usage

````
// create our UUID.
NSString *uuidStr = @"B9407F30-F5F8-466E-AFF9-25556B57FE99";
CBUUID *uuid = [CBUUID UUIDWithString:uuidStr];
    
__weak typeof(self) weakSelf = self;
    
// start Discovery
self.discovery = [[Discovery alloc] initWithUUID:uuid username:self.username usersBlock:^(NSArray *users, BOOL usersChanged) {
        
    NSLog(@"Updating table view with users count : %d", users.count);
    weakSelf.users = users;
    [weakSelf.tableView reloadData];
}];

````

## The Concept, The Problem, and why we need Discovery?

Let's make clear what we are trying to solve: Our aim is to handle the problem of discovering other devices (that are our running our app too), and exchanging an ID (could be username, name or a numbered id) **even if our app on the peer device runs at background**.

If you have dived into the concepts of **BLE** and **iBeacon** you probably know that iOS has some limitations on how you can harness these features. iBeacons are basically subset of BLE technology. You can program your device to be both an advertiser and a listener. However it is not possible to advertise as iBeacon when your app runs at background state. Moreover, you can only transmit major and minor values which are also limiting.

Thus, directly using BLE functions are more convenient. Yet, we have some problems there too! Basically, the problem here lies again on the state of your app, namely, exchanging usernames(or any kind of ID) at both foreground and background states. If your app runs on foreground state, there isn't any problem. We can simply attach data which is our username, and when the peer device detects our signal, it will retrieve the username via **CBAdvertisementDataLocalNameKey**. However, iOS trims that information when our app goes into background state. It still continues to advertise, but the data(username) your are trying transmit can not be read by other peers. So we need some other methods to determine who that device belongs to.

Discovery solves this problem by creating some specific characteristics that is binded to the service of the advertiser. When the listener peer discovers our device, it initially checks whether it can read the **CBAdvertisementDataLocalNameKey** value. If it can, there is no problem, the device is identified. If it **can't read** (which means our app is at background state) it attempts to connect and discover our services. After the connection is successful, the peer device goes through our services and it reads our characteristics, and there it retrieves our username - voilà! Then, simply disconnects.

## What's next? ##

I wanted to keep Discovery as simple as possible for the initial release. In the next release I will probably add some reliable error handling and some callbacks for the developer to interfere whenever necessary. And maybe some time later, I could add some extra features for peers to persistently connect each other and continue exchanging stream of information.

## Problematic Cases ##

Have a look at this [question on Stackoverflow][1]. In my experience, I did't encounter this problem on iOS8, only sometimes on iOS7.

## Contribution

Please don't hesitate to send pull requests, however I only accept it on develop branch.

## Contact

Ömer Faruk Gül

[My LinkedIn Account][2]

 [1]: http://stackoverflow.com/questions/20380561/ios-corebluetoothwarning-unknown-error-1309
 [2]: http://www.linkedin.com/profile/view?id=44437676


