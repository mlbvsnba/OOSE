import pyapns.client
import time


def notify(apns_token, message, badge=None, sound=None):
    """Push notification to device with the given message

    @param apns_token - The device's APNS-issued unique token
    @param message - The message to display in the
                     notification window
    """
    notification = {'aps': {'alert': message}}
    if badge is not None:
        notification['aps']['badge'] = int(badge)
    if sound is not None:
        notification['aps']['sound'] = str(sound)
    for attempt in range(4):
        try:
            pyapns.client.notify('HiNote', apns_token,
                                 notification)
            break
        except (pyapns.client.UnknownAppID,
                pyapns.client.APNSNotConfigured):
            # This can happen if the pyapns server has been
            # restarted since django started running.  In
            # that case, we need to clear the client's
            # configured flag so we can reconfigure it from
            # our settings.py PYAPNS_CONFIG settings.
            pyapns.client.OPTIONS['CONFIGURED'] = False
            pyapns.client.configure({})
            time.sleep(0.5)