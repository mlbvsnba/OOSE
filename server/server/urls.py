from django.conf.urls import patterns, include, url
from django.contrib import admin
from HiNote import views

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'server.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^signup/', 'HiNote.views.dev_signup'),
    url(r'^listall/', 'HiNote.views.list_subscriptions'),
    url(r'createsub/', 'HiNote.views.make_subscription'),
    url(r'pushnotif/', 'HiNote.views.push_notification'),
    url(r'listnotif/', 'HiNote.views.list_notifications')
)
