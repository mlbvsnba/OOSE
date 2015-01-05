/**
 * A Developer who can create and push Notifications to Subscriptions that it creates.
 */
public class Developer extends django.contrib.auth.models.User {
	/** The Developer's api key - used for authentication. */
	public final django.db.models.CharField api_key;
	
	/**
	 * Verifies the given api key for the developer.
	 * @param api_key the api key to check
	 * @return True if they're equal, false otherwise
	 */
	public boolean verify_api_key(String api_key) {
		return false;
	}

	
	/**
	 * Creates a Subscription under this Developer.
	 * @param name the name of the Subscription
	 * @param description the description of this Subscription
	 */
	public void createSubscription(String name, String description) {
		
	}
	
	/**
	 * Creates a new api key for a new Developer.
	 * @return the new api key
	 */
	public static String create_api_key() {
		return null;
	}
}
