from django.shortcuts import render


# Create your views here.

def koffeeluvwebsite(request):
    return render(request, 'koffeeluv.html', {})

