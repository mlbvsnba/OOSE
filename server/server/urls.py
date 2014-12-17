from django.conf.urls import patterns, include, url
from django.contrib import admin
from HiNote import views
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'server.views.home', name='home'),
    # url(r'^blog/', include('blog.urls')),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^signup/', 'HiNote.views.dev_signup'),
    url(r'^listall/', 'HiNote.views.list_subscriptions'),
    url(r'^createsub/', 'HiNote.views.make_subscription'),
    url(r'^pushnotif/', 'HiNote.views.push_notification'),
    url(r'^listnotif/', 'HiNote.views.list_notifications'),
    url(r'^user_signup/', 'HiNote.views.user_signup'),
    url(r'^check_auth/', 'HiNote.views.check_auth'),
    url(r'^register_device/', 'HiNote.views.register_device'),
    url(r'^listsubs/', 'HiNote.views.get_user_subscriptions'),
    url(r'^subscribe/', 'HiNote.views.subscribe'),
    url(r'^forward/', 'HiNote.views.forward_notifcation'),
    # url(r'^$', 'django.contrib.staticfiles.views.serve', kwargs={
    #     'path': 'index.html', 'document_root': settings.STATIC_URL})
)
urlpatterns += patterns(
    'django.contrib.staticfiles.views',
    url(r'^(?:index.html)?$', 'serve', kwargs={'path': 'index.html'})
)
urlpatterns += patterns(
    'django.contrib.staticfiles.views',
    url(r'^api.html', 'serve', kwargs={'path': 'api.html'})
)

# ) + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
