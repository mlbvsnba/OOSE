from django.http import HttpResponseRedirect
from django.forms import ModelForm
from HiNote.models import Developer
from django.shortcuts import render
from HiNote.models import CommonUser
from HiNote.models import DeveloperForm
from HiNote.models import CommonUserForm
from HiNote.models import SubscriptionCreationForm
from HiNote.models import SubscriptionSettings
from HiNote.models import PushNotificationForm
from HiNote.models import Subscription
from HiNote.models import Developer
from django.core.exceptions import ValidationError
from django.core import serializers
from django.http import HttpResponse
from django.http import HttpResponseNotAllowed
from django.http import HttpResponseBadRequest
from django.http import HttpResponseForbidden
from django.views.decorators.csrf import csrf_exempt
from django.core.exceptions import *
import json as pyjson


def dev_signup(request):
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
    if request.method == 'POST':
        form = CommonUserForm(request.POST)
        if form.is_valid():
            user = form.save()
            return render(request, 'basic_form.html', {'plain_response': 'success'})
        else:
            # this could also mean the username already exists - must change response to that later on
            # return HttpResponseBadRequest('invalid POST request - must define all required parameters')

            return HttpResponseBadRequest("wrong codes " + form.errors)
    else:
        return HttpResponseNotAllowed(['POST'])


@csrf_exempt
def check_auth(request):
    user_valid, user, response = auth_user(request)
    if user_valid:
        return render(request, 'basic_form.html', {'plain_response': 'success'})
    else:
        return response


@csrf_exempt
def register_device(request):
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
    user_valid, user, response = auth_user(request)
    if not user_valid:
        return response
    try:
        settings_set = SubscriptionSettings.objects.filter(user=user)
        subscriptions_id = [settings.subscription.id for settings in settings_set]
    except ObjectDoesNotExist:
       subscriptions_id = []
    json = pyjson.dumps(subscriptions_id)
    return HttpResponse(json, content_type='application/json')


@csrf_exempt
def subscribe(request):
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
    # checks for a user given a POST response
    # returns list of (user_valid [boolean], user [CommonUser object], response [HttpResponse])
    # response if only returned if user_valid is False
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
    if request.method == 'POST':
        form = SubscriptionCreationForm(request.POST)
        if form.is_valid():
            sub = form.save()
            return render(request, 'basic_form.html', {'plain_response': sub.id})
    else:
        form = SubscriptionCreationForm()
    return render(request, 'basic_form.html', {'form': form})


def push_notification(request):
    if request.method == 'POST':
        form = PushNotificationForm(request.POST)
        if form.is_valid():
            notif = form.save()
            return render(request, 'basic_form.html', {'plain_response': notif.id})
    else:
        form = PushNotificationForm()
    return render(request, 'basic_form.html', {'form': form})


def list_subscriptions(request):
    subs = Subscription.objects.all()
    json = serializers.serialize('json', subs)
    return HttpResponse(json, content_type='application/json')


def list_notifications(request):
    if 'id' in request.GET:
        id = request.GET['id']
        sub = Subscription.objects.get(id=id)
        notifs = sub.developernotification_set.all()
        json = serializers.serialize('json', notifs)
        return HttpResponse(json, content_type='application/json')
    else:
        return render(request, 'basic_form.html', {'plain_response': 'need an id'})
