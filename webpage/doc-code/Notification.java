import java.util.Collection;

/**
 * The interface of both types of notifications that we have, User and Developer.
 * This stores the information for a notification sent from a Developer or User to Users. 
 */
public class Notification extends django.db.models.Model {
	/**
	 * A django many-to-one relationship between this notification and the sender of it.
	 */
	public django.db.models.ForeignKey sender;
	/**
	 * The contents of the notification.
	 */
	public django.db.models.CharField contents;
	/**
	 * The creation date/time of the notification.
	 */
	public final django.db.models.DateTimeField creation_date;
	
	
	/**
	 * Gets the possible actions for this Notification.
	 * @return the descriptions of the possible action(s)
	 */
	public Collection<String> getActions();
	
	/**
	 * Gets a description of how to display this Notification on IOS.
	 * @return the description
	 */
	public Collection<String> getIOSDisplay();
}
