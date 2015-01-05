/**
 * An iOS Device that is owned by a related CommonUser.
 * This device is then used to push a notification.
 */
public class IOSDevice {
	/** A Many-to-one relationship to the CommonUser that owns this device. */
	public django.db.models.ForeignKey user;
	/** A 32-length character (String) field that holds the device's APNS provided token. This cannot be set to null/empty string. */ 
	public django.db.models.CharField token;
}
