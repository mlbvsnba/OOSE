/**
 * A notification sent from a Developer to a User through a Subscription.
 */
public class DeveloperNotification implements Notification {
	
	/**
	 * A django many-to-one relationship to the subscription that this notification belongs to.
	 */
	public django.db.models.ForeignKey subscription;
	
	
	@Override
	public Collection<String> getActions() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<String> getIOSDisplay() {
		// TODO Auto-generated method stub
		return null;
	}
	
}
