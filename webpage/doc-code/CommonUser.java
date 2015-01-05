/**
 * The common (non-developer) user.
 * This user can subscribe to lists and has a SubscriptionSettings object for each list it is subscribed to.
 * By using the django User base-class, we can have assured security with regards to user authentication.
 */
public class CommonUser extends django.contrib.auth.models.User {
	/**
	 * Adds a device denoted by the given device token to this user's list of owned devices.
	 * @param device_token the device token (32 characters) given by APNS
	 * @param commit if true, returned device is saved. if false, it's not saved and only returned.
	 * @return the created device
	 */
	public IOSDevice register_device(String device_token, boolean commit)
	{
	}
}
