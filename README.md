# FloatingAction

Custom Implementation of LPMessagingSDK with Floating Action Button with Notification Counter

 * LPMessagingSDK Method:

    ```swift
    /// Get unread message badge counter
    /// There are two options to get this counter:
    /// 1. If the time condition (10 seconds) is met we are performing a REST request to get it from pusher
    /// 2. otherwise, return the cached number we have
    getUnreadMessagesCount(_ conversationQuery: ConversationParamProtocol, completion: @escaping (Int) -> (), failure: @escaping (NSError) -> ())
    ```
  
* App Delegate LifeCycle:
  
    ```swift
    /// Tells the app that a remote notification arrived that indicates there is data to be fetched.
    application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    ```
    
* Notification Badge updates on the following events:
  * In-App Notification (Toast),
  * leaving ConversationViewController,
  * Opening the App.
  
* Demo

<p align="center">
  <img src="https://user-images.githubusercontent.com/11651229/35236903-f4a3d276-ff76-11e7-85ea-65efb59c3e4c.gif">
</p>
