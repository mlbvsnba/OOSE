from django.shortcuts import render

from django.core import serializers
from django.http import HttpResponse
from django.http import HttpResponseNotAllowed
from django.http import HttpResponseBadRequest
from django.http import HttpResponseForbidden
from django.views.decorators.csrf import csrf_exempt
from django.core.exceptions import *

from HiNote.models import CommonUser

from HiNote.models import DeveloperForm
from HiNote.models import CommonUserForm
from HiNote.models import SubscriptionCreationForm
from HiNote.models import SubscriptionSettings
from HiNote.models import PushNotificationForm
from HiNote.models import DeveloperNotification
from HiNote.models import Subscription


def dev_signup(request):
    """
    The view for a Developer signup which uses DeveloperForm.
    :param request: the HTML request
    :type request: django.http.HttpRequest
    :return: HttpResponse object
    :rtype: HttpResponse
    """
    if request.method == 'POST':
        form = DeveloperForm(request.POST)
        if form.is_valid():
            dev = form.save()
            return render(request, 'basic_form.html', {'plain_response': dev.api_key})
    else:
        form = DeveloperForm()
    return render(request, 'basic_form.html', {'form': form})


@csrf_exempt
def user_signup(request):
    """
    The view for CommonUser signup which uses CommonUserForm.
    :param request: the HTML request
    :type request: django.http.HttpRequest
    :return: HttpResponse object
    :rtype: HttpResponse
    """
    if request.method == 'POST':
        form = CommonUserForm(request.POST)
        if form.is_valid():
            user = form.save()
            return render(request, 'basic_form.html', {'plain_response': 'success'})
        else:
            return HttpResponseBadRequest("wrong codes " + form.errors)
    else:
        return HttpResponseNotAllowed(['POST'])


@csrf_exempt
def check_auth(request):
    """
    A view to authenticate an already registered CommonUser.
    :param request: the HTML request
    :type request: django.http.HttpRequest
    :return: HttpResponse object
    :rtype: HttpResponse
    """
    user_valid, user, response = auth_user(request)
    if user_valid:
        return render(request, 'basic_form.html', {'plain_response': 'success'})
    else:
        return response


@csrf_exempt
def forward_notifcation(request):
    """
    A view to forward a notification from one CommonUser to another.
    :param request: the HTML request
    :type request: django.http.HttpRequest
    :return: HttpResponse object
    :rtype: HttpResponse
    """
    user_valid, user, response = auth_user(request)
    if not user_valid:
        return response
    try:
        other_username = request.POST['other_username']
        notif_id = request.POST['notif_id']
    except KeyError:
        return HttpResponseBadRequest('all required parameters must be included')
    try:
        other_user = CommonUser.objects.get(username=other_username)
    except ObjectDoesNotExist:
        return HttpResponseBadRequest('user')
    try:
        notification = DeveloperNotification.objects.get(id=notif_id)
    except ObjectDoesNotExist:
        return HttpResponseBadRequest('notif')
    personal_sub = Subscription.get_personal_sub(other_user)
    personal_sub.create_notification(notification.contents)
    return render(request, 'basic_form.html', {'plain_response': 'success'})


@csrf_exempt
def register_device(request):
    """
    A view to register an IOSDevice to a CommonUser.
    :param request: the HTML request
    :type request: django.http.HttpRequest
    :return: HttpResponse object
    :rtype: HttpResponse
    """
    user_valid, user, response = auth_user(request)
    if not user_valid:
        return response
    try:
        device_token = request.POST['device_token']
    except KeyError:
        return HttpResponseBadRequest('device_token must be sent in POST')
    if user.register_device(device_token, commit=True) is not None:
        return render(request, 'basic_form.html', {'plain_response': 'success'})
    else:
        return HttpResponseBadRequest('add device failed')


@csrf_exempt
def get_user_subscriptions(request):
    """
    A view to return a list of an authenticated CommonUser's subscriptions.
    :param request: the HTML request
    :type request: django.http.HttpRequest
    :return: HttpResponse object
    :rtype: HttpResponse
    """
    user_valid, user, response = auth_user(request)
    if not user_valid:
        return response
    try:
        settings_set = SubscriptionSettings.objects.filter(user=user)
        subscriptions = [settings.subscription for settings in settings_set]
    except ObjectDoesNotExist:
        subscriptions = []
    json = serializers.serialize('json', subscriptions)
    return HttpResponse(json, content_type='application/json')


@csrf_exempt
def subscribe(request):
    """
    A view to subscribe an authenticated CommonUser to a Subscription list (represented by its ID).
    :param request: the HTML request
    :type request: django.http.HttpRequest
    :return: HttpResponse object
    :rtype: HttpResponse
    """
    user_valid, user, response = auth_user(request)
    if not user_valid:
        return response
    try:
        subscription_id = request.POST['sub_id']
    except KeyError:
        return HttpResponseBadRequest('sub_id must be sent in POST')
    try:
        subscription = Subscription.objects.get(id=subscription_id)
    except ObjectDoesNotExist:
        return HttpResponseBadRequest('sub_id was invalid')
    settings = subscription.add_user(user)
    if settings is not None:
        return render(request, 'basic_form.html', {'plain_response': 'success'})
    else:
        return HttpResponseBadRequest('subscribe failed')


def auth_user(request):
    """
    Checks if an HTML request properly authenticates a CommonUser.
    :param request: the HTML request
    :type request: django.http.HttpRequest
    :return: list of: true if user/pass is valid, user object (if valid, else None), and response (if lookup failed,
    else None)
    :rtype: list of (bool, CommonUser, HttpResponse)
    """
    if request.method == 'POST':
        try:
            username = request.POST['username']
            password = request.POST['password']
        except KeyError:
            return False, None, HttpResponseBadRequest('username and password must be sent in POST')
        user = None
        found = False
        try:
            user = CommonUser.objects.get(username=username)
            found = user.check_password(password)
        except ObjectDoesNotExist:
            pass
        if found:
            return True, user, None
        else:
            return False, None, HttpResponseForbidden('username and/or password are incorrect')
    else:
        return False, None, HttpResponseNotAllowed(['POST'])


def make_subscription(request):
    """
    A view to create a Subscription for a Developer.  Part of DEV API.
    :param request: the HTML request
    :type request: django.http.HttpRequest
    :return: HttpResponse object
    :rtype: HttpResponse
    """
    if request.method == 'POST':
        form = SubscriptionCreationForm(request.POST)
        if form.is_valid():
            sub = form.save()
            return render(request, 'basic_form.html', {'plain_response': sub.id})
    else:
        form = SubscriptionCreationForm()
    return render(request, 'basic_form.html', {'form': form})


def push_notification(request):
    """
    A view to push a new Notification to a Developer's Subscription list.  Part of DEV API.
    :param request: the HTML request
    :type request: django.http.HttpRequest
    :return: HttpResponse object
    :rtype: HttpResponse
    """
    if request.method == 'POST':
        form = PushNotificationForm(request.POST)
        if form.is_valid():
            notif = form.save()
            return render(request, 'basic_form.html', {'plain_response': notif.id})
    else:
        form = PushNotificationForm()
    return render(request, 'basic_form.html', {'form': form})


def list_subscriptions(request):
    """
    A view to provide a JSON encoded list of all possible/created Subscription lists (not including personal lists).
    :param request: the HTML request
    :type request: django.http.HttpRequest
    :return: HttpResponse object
    :rtype: HttpResponse
    """
    subs = Subscription.objects.filter(is_personal=False)
    json = serializers.serialize('json', subs)
    return HttpResponse(json, content_type='application/json')


def list_notifications(request):
    """
    A view to provide all notifications in JSON encoding from a given Subscription list.
    :param request: the HTML request
    :type request: django.http.HttpRequest
    :return: HttpResponse object
    :rtype: HttpResponse
    """
    if 'id' in request.GET:
        id = request.GET['id']
        sub = Subscription.objects.get(id=id)
        notifs = sub.developernotification_set.all()
        json = serializers.serialize('json', notifs)
        return HttpResponse(json, content_type='application/json')
    else:
        return render(request, 'basic_form.html', {'plain_response': 'need an id'})
