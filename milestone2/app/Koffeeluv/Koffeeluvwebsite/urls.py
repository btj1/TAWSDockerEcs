from django.urls import path
from Koffeeluvwebsite import views

urlpatterns = [
    path('', views.koffeeluvwebsite, name='koffeeluvwebsite'),
]