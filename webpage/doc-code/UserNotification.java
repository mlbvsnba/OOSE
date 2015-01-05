import java.util.Collection;
import java.util.Date;

/**
 * A Notification that is sent from a User to a User.
 */
public class UserNotification implements Notification {

	/**
	 * A django many-to-one relationship to the recipient user.
	 */
	public django.db.models.ForeignKey recipient;
	
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
