from django.http import HttpResponseRedirect
from django.forms import ModelForm
from HiNote.models import Developer
from django.shortcuts import render
from HiNote.models import DeveloperForm
from HiNote.models import Developer
from django.core.exceptions import ValidationError


def dev_signup(request):
    if request.method == 'POST':
        form = DeveloperForm(request.POST)
        if form.is_valid():
            dev = form.save()
            return render(request, 'signup.html', {'api_key': dev.api_key})
    else:
        form = DeveloperForm()
    return render(request, 'signup.html', {'form': form})

