"Simple" Evernote SDK for iOS version 2.0
=========================================

**HEADS-UP!** This fork of the SDK is unofficial and a work in progress. Although most of the "public" objects are fairly stable, changes are being made overall quite frequently. Some things might well not work as you expect. Your feedback is very valued.

NB: There currently is no "sample app" in the actual Xcode project. There will be one soon. Until then, you can just grab the files directly.

What this is
------------
A simple, workflow-oriented library built on the Evernote Cloud API. It's designed to make common tasks a piece of cake!

Installing
----------

### Register for an Evernote API key (and secret)...

You can do this on the [Evernote Developers portal page](http://dev.evernote.com/documentation/cloud/).

### ...OR get a Developer Token

You can also just test-drive the SDK against your personal production Evernote account, if you're afraid of commitment and don't like sandboxes. [Get a developer token here](https://www.evernote.com/api/DeveloperToken.action). Make sure to use the alternate setup instructions given in the "Modify Your App Delegate" section below.

### Include the code

You have a few options:

- (Recommended) Open up terminal, cd into the root folder of the SDK repo you cloned and

		cd scripts;
		./build_framework.sh
		(if you see error '-bash: ./build_framework.sh: Permission denied' from the above line, please execute 'chmod +x build_framework.sh'
		to give your script execute permission and do the above)

	The script will generate a universal ENSDK.framework library for both the simulator and the device. After the build finishes, you can see where the product is generated from the build log:

		Framework built successfully! Please find in /Users/echeng/Documents/Evernote/evernote-sdk-ios-new/scripts/..//Products/ENSDK.framework

	Please add the ENSDK.framework and the ENSDKResources.bundle in the Products folder into your projects. Make sure you check "Copy items into destination group's folder (if needed)"

- (Alternative) Copy ENSDKResources.bundle and evernote-sdk-ios folder (in the same folder with ENSDKResources.bundle) into your Xcode project directly. This will build the SDK files as part of your project when you build it. 

### Link with frameworks

evernote-sdk-ios depends on some frameworks, so you'll need to add them to any target's "Link Binary With Libraries" Build Phase.
Add the following frameworks in the "Link Binary With Libraries" phase

- MobileCoreServices.framework
- libxml2.dylib

### Modify your application's main plist file

Create an array key called URL types with a single array sub-item called URL Schemes. Give this a single item with your consumer key prefixed with 'en-'

	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleURLName</key>
			<string></string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>en-<consumer key></string>
			</array>
		</dict>
	</array>

### Add the header file to any file that uses the Evernote SDK

    #import <ENSDK/ENSDK.h>

### Modify your AppDelegate

First you set up the ENSession, configuring it with your consumer key and secret.

The SDK supports the Yinxiang Biji (Evernote China) service by default. Please make sure your consumer key has been [activated](http://dev.evernote.com/support/) for the China service.

Do something like this in your AppDelegate's `application:didFinishLaunchingWithOptions:` method.

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
		// Initial development is done on the sandbox service
		// When you want to connect to production, just pass "nil" for "optionalHost"
		NSString *SANDBOX_HOST = ENSessionHostSandbox;

		// Fill in the consumer key and secret with the values that you received from Evernote
		// To get an API key, visit http://dev.evernote.com/documentation/cloud/
		NSString *CONSUMER_KEY = @"your key";
		NSString *CONSUMER_SECRET = @"your secret";

		[ENSession setSharedSessionConsumerKey:CONSUMER_KEY
		  						consumerSecret:CONSUMER_SECRET
							      optionalHost:SANDBOX_HOST];
	}

ALTERNATE: If you are using a Developer Token to access *only* your personal, production account, then *don't* set a consumer key/secret (or the sandbox environment). Instead, give the SDK your developer token and Note Store URL (both personalized and available from [this page](https://www.evernote.com/api/DeveloperToken.action)). Replace the setup call above with the following.

        [ENSession setSharedSessionDeveloperToken:@"the token string"
                                     noteStoreUrl:@"the url that you got from us"];


Do something like this in your AppDelegate's `application:openURL:sourceApplication:annotation:` method. If the method doesn't exist, add it.

	- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
		BOOL didHandle = [[ENSession sharedSession] handleOpenURL:url];
		// ...
		return didHandle;
	}

Now you're good to go.

Using the Evernote SDK
----------------------

### Authenticate

You'll need to authenticate the `ENSession`, passing in your view controller.

A normal place to do this would be a "link to Evernote" button action.

    ENSession *session = [ENSession sharedSession];
    [session authenticateWithViewController:self completion:^(NSError *error) {
        if (error) {
            // authentication failed :(
            // show an alert, etc
            // ...
        } else {
            // authentication succeeded :)
            // do something now that we're authenticated
            // ...
        }
    }];

Calling authenticateWithViewController:completion: will start the OAuth process. ENSession will open a new modal view controller, to display Evernote's OAuth web page and handle all the back-and-forth OAuth handshaking. When the user finishes this process, Evernote's modal view controller will be dismissed.

Authentication credentials are saved on the device once the user grants access, so this step is only necessary as part of an explicit linking. Subsequent access to the shared session will automatically restore the existing session for you. You can ask a session if it's already authenticated using the `-isAuthenticated` property.

### Hello, world.

To create a new note with no user interface, you can just do this:

    ENNote * note = [[ENNote alloc] init];
	note.content = [ENNoteContent noteContentWithString:@"Hello, World!"];
	note.title = @"My First Note";
    [[ENSession sharedSession] uploadNote:note completion:^(ENNoteRef * noteRef, NSError * uploadNoteError) {
		if (noteRef) {
			// It worked! You can use this note ref to share the note or otherwise find it again.
			...
		} else {
			NSLog(@"Couldn't upload note. Error: %@", uploadNoteError);
		}
	}];

This creates a new, plaintext note, with a title, and uploads it to the user's default notebook.

### Adding Resources

Let's say you'd like to create a note with an image that you have. That's easy too. You just need to create an `ENResource` that represents the image data, and attach it to the note before uploading:

	ENNote * note = [[ENNote alloc] init];
	note.content = [ENNoteContent noteContentWithString:@"Check out this awesome picture!"];
	note.title = @"My Image Note";
	ENResource * resource = [[ENResource alloc] initWithImage:myImage]; // myImage is a UIImage object.
	[note addResource:resource]
	[[ENSession sharedSession] uploadNote:note completion:^(ENNoteRef * noteRef, NSError * uploadNoteError) {
		// same as above...
	}];

You aren't restricted to images; you can use any kind of file. Just use the appropriate initializer for `ENResource`. You'll need to know the data's MIME type to pass along.

### Sending To Evernote with UIActivityViewController

[This object works when a session is authenticated already. Note that it's a big work in progress with crummy UI for right now!]

iOS provides a handy system `UIActivityViewController` that you can create and use when a user taps an "action" or "share" button in your app. The Evernote SDK provides a drop-in `UIActivity` subclass (`ENSendToEvernoteActivity`) that you can use. This will do the work of creating resources and note contents (based on the activity items), and presents a view controller that lets the user choose a notebook, add tags, edit the title, etc. Just do this:

	ENSendToEvernoteActivity * evernoteActivity = [[ENSendToEvernoteActivity alloc] init];
	activity.noteTitle = @"Default Note Title";
	//...
	UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[evernoteActivity]];
    [self presentViewController:avc animated:YES completion:nil];
    // etc

### Creating a note using HTML or web content.

The SDK contains a facility for capturing web content as a note. This content can be remote of course (generated by your service) or could be loaded locally from resources within your app. You can use `+[ENNote populateNoteFromWebView:completion:]` to create an `ENNote` object from the contents of a loaded `UIWebView` object. 

    [ENNote populateNoteFromWebView:webView completion:^(ENNote * note) {
	    if (note) {
		    [[ENSession sharedSession] uploadNote:note completion:^(ENNoteRef *noteRef, NSError *uploadNoteError) {
	            // etc...
            }];
        }
    }];  

This method will capture content from the DOM. Images in the page will be captured as ENResource objects in the note (not true of images provided as CSS styles.) Please note that this is not a comprehensive "web clipper", though, and isn't designed to work fully on arbitrary pages from the internet. It will work best on pages which have been generally designed for the purpose of being captured as note content. 

If your app doesn't already have your content into visible web views, you can always create an offscreen `UIWebView` and populate a note from it once loaded. When doing this, please bear in mind that the dimensions of the web view (even when offscreen) can affect the rendered contents. Also note that `UIWebView`'s delegate methods don't indicate when the whole page has "completely" loaded if your page includes linked (remote) resources. 

### What else is in here?

The high level functions include those on `ENSession`, and you can look at `ENNote`, `ENResource`, `ENNotebook` for simple models of these objects as well.

See below for some initial notes on supporting more advanced functionality via including the "Advanced" header and using the full EDAM layer.

FAQ
---

### What iOS versions are supported?

This version of the SDK is designed for iOS 7 (and above). The current public version of the SDK in Evernote's repo supports back to iOS 5.

### Does the Evernote SDK support ARC?

Obvi. (To use the SDK in a non-ARC project, please use the -fobjc-arc compiler flag on all the files in the Evernote SDK.)

### What if I want to do more than the meager few functions offered on ENSession?

ENSession is a really broad, workflow-oriented abstraction layer. It's currently optimized for the creation and upload of new notes, but not a whole lot more. You can get closer to the metal, but it will require a fair bit of understanding of Evernote's object model and API.

First off, import `<ENSDK/Advanced/ENSDKAdvanced.h>` instead of `ENSDK.h`. Then ask an authenticated session for its `-primaryNoteStore`. You can look at the header for `ENNoteStoreClient` to see all the methods offered on it, with block-based completion parameters. Knock yourself out. This note store client won't work with a user's business data or shared notebook data directly; you can get note store clients for those destinations by asking for `-businessNoteStore` and `-noteStoreForLinkedNotebook:`  More info is currently beyond the scope of this README but check out the full developer docs.

### Where can I find out more about the Evernote service, API, and object model for my more sophisticated integration?

Please check out the [Evernote Developers portal page](http://dev.evernote.com/documentation/cloud/).
Apple style docs are [here](http://dev.evernote.com/documentation/reference/ios/).
