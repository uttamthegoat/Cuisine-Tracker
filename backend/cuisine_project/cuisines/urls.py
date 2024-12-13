from django.urls import path
from .views import CuisineView, CategoryView, SubcategoryView
from django.conf.urls.static import static
from django.conf import settings

urlpatterns = [
    path('cuisines/', CuisineView.as_view(), name='cuisine-list'),
    path('categories/', CategoryView.as_view(), name='category-list'),
    path('subcategories/', SubcategoryView.as_view(), name='subcategory-list'),
]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
