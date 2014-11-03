from django.http import HttpResponseRedirect
from django.forms import ModelForm
from HiNote.models import Developer
from django.shortcuts import render
from HiNote.models import DeveloperForm


def dev_signup(request):
    if request.method == 'POST':
        form = DeveloperForm(request.POST)
    else:
        form = DeveloperForm()
    return render(request, 'signup.html', {'form': form})

