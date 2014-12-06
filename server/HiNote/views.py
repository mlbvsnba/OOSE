from django.http import HttpResponseRedirect
from django.forms import ModelForm
from HiNote.models import Developer
from django.shortcuts import render
from HiNote.models import DeveloperForm
from HiNote.models import CommonUserForm
from HiNote.models import RegisterDeviceForm
from HiNote.models import SubscriptionCreationForm
from HiNote.models import PushNotificationForm
from HiNote.models import Subscription
from HiNote.models import Developer
from django.core.exceptions import ValidationError
from django.core import serializers
from django.http import HttpResponse
from django.http import HttpResponseNotAllowed


def dev_signup(request):
    if request.method == 'POST':
        form = DeveloperForm(request.POST)
        if form.is_valid():
            dev = form.save()
            return render(request, 'basic_form.html', {'plain_response': dev.api_key})
    else:
        form = DeveloperForm()
    return render(request, 'basic_form.html', {'form': form})


def user_signup(request):
    if request.method == 'POST':
        form = CommonUserForm(request.POST)
        if form.is_valid():
            user = form.save()
            return render(request, 'basic_form.html', {'plain_response': 'success'})
    else:
       return HttpResponseNotAllowed(['POST'])


def register_device(request):
    if request.method == 'POST':
        form = RegisterDeviceForm(request.POST)
        if form.is_valid():
            device = form.save()
            return render(request, 'basic_form.html', {'plain_response': 'success'})
    else:
        return HttpResponseNotAllowed(['POST'])


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
    if request.method =='POST':
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
