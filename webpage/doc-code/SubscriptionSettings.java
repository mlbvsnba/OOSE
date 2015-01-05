/**
 * A specific User's settings for a Subscription.
 */
public class SubscriptionSettings extends django.db.models.Model {
	/**
	 * A django many-to-one reference to the user that "owns" this SubscriptionSettings.
	 */
	public django.db.models.ForeignKey user;
	/**
	 * A django many-to-one reference to the subscript that this SubscriptionSettings applies to.
	 */
	public django.db.models.ForeignKey subscription;
	/**
	 * Whether or not the user wants the notifications to be shown in the notification center (rather than just in the app).
	 * Defaults to true.
	 */
	public django.db.models.BooleanField receive_notifications;
	/**
	 * The radius in which the User should be from some epicenter to receive the Notification.
	 * If -1, then don't poll for location and receive it anywhere.
	 * Defaults to -1.
	 */
	public django.db.models.IntegerField radiusInMiles;
	/**
	 * The notification frequency at which the User wants to receive notifications.
	 * If -1, then all notifications are received as they are published.
	 * Defaults to -1.
	 */
	public django.db.models.IntegerField notificationFrequency;
}
