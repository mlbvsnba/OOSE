/**
 * A Subscription list which is owned by a Developer and contains Users.
 */
public class Subscription extends django.db.models.Model {
	/**
	 * The date/time that this Subscription was created.
	 */
	public final django.db.models.DateTimeField creation_date;
	/**
	 * The name of this Subscription.
	 */
	public django.db.models.CharField name;
	/**
	 * The description of this Subscription.
	 */
	public django.db.models.CharField description;
	/**
	 * A many-to-one django relationship to the Developer that created/manages this Subscription list.
	 */
	public django.db.models.ForeignKey owner;
	
	/**
	 * Pushes a given SubscriptionNotification to the subscribed User's.
	 * @param s the SubscriptionNotification to push
	 */
	public void push_notification(DeveloperNotification s) {
		
	}	
	
}
