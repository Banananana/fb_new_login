### Bitching about FB SDK documentation?
Hey, it's not THAT bad. But it's also not THAT good. :D

This is a simple and straightforward example on FB SDK integration with 'modern' Objective-C (meaning iOS 6, ARC and Storyboards).

It basically uses `NSNotificationCenter` to receive messages about FB Session State changes (i.e. if users authorised - or not - the app).

From Apple's documentation: _A notification center manages the sending and receiving of notifications. It notifies all observers of notifications meeting specific criteria. The notification information is encapsulated in NSNotification objects. Client objects register themselves with the notification center as observers of specific notifications posted by other objects. When an event occurs, an object posts an appropriate notification to the notification center. (...) The notification center dispatches a message to each registered observer, passing the notification as the sole argument. It is possible for the posting object and the observing object to be the same._

The app also provides a button to post a 'Hi!' on your timeline (so you can have a quick look on the **Publish to Feed** thing).

I'm assuming that your environment is up and running.
[Mainly that the step 5 of the FB dev guide was already performed.](http://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/)
Of course, you must also put your own `FacebookAppId` (at the .plist file) as well as change the product name and stuff.

![U da man!](http://cl.ly/image/3I243w3J0W3Q/Ozama.jpg)

![I love Dolan...](http://f.cl.ly/items/2q2P3g2P220d0R1R213e/Dolan.jpg)

Hopefully this can somehow help you. Ping me know if any issues.

http://conaaando.github.io/fb-sdk-storyboards/
