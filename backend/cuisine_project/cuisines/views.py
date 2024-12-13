from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Cuisine, Category, Subcategory
from .serializers import CuisineSerializer, CategorySerializer, SubcategorySerializer
import json

class CuisineView(APIView):
    def get(self, request):
        cuisines = Cuisine.objects.all()
        serializer = CuisineSerializer(cuisines, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = CuisineSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CategoryView(APIView):
    def get(self, request):
        categories = Category.objects.prefetch_related(
            'cuisines',
            'subcategories'
        ).all()
        
        serializer = CategorySerializer(categories, many=True)
        
        print("\n=== Category Relationships ===")
        for category in categories:
            print(f"\nCategory: {category.category_title}")
            print(f"Raw cuisines query: {category.cuisines.all()}")
            print(f"Cuisine IDs: {[c.id for c in category.cuisines.all()]}")
            print(f"Cuisine Titles: {[c.cuisine_title for c in category.cuisines.all()]}")
        
        print("\n=== Serialized Data ===")
        for category in serializer.data:
            print(f"\nCategory: {category['category_title']}")
            print(f"Serialized cuisines: {category['cuisines']}")
        
        return Response(serializer.data)

    def post(self, request):
        print("\n=== POST Request Data ===")
        print("Raw request data:", request.data)

        data = request.data.copy()

        # Handle cuisine_ids
        if 'cuisine_ids' in data:
            try:
                cuisine_ids = json.loads(data.get('cuisine_ids', '[]'))
                data['cuisine_ids'] = [int(id_) for id_ in cuisine_ids if id_]
            except json.JSONDecodeError:
                data['cuisine_ids'] = []

        # Handle subcategory_ids
        # Remove subcategory_ids if empty
        if 'subcategory_ids' in data and not data['subcategory_ids']:
            del data['subcategory_ids']
        if 'subcategory_ids' in data:
            try:
                subcategory_ids = json.loads(data.get('subcategory_ids', '[]'))
                data['subcategory_ids'] = [int(id_) for id_ in subcategory_ids if id_]
            except json.JSONDecodeError:
                data['subcategory_ids'] = []
            
        print("Processed data:", data)
        
        serializer = CategorySerializer(data=data)
        if serializer.is_valid():
            try:
                print("\n=== Valid Data ===")
                print("Validated data:", serializer.validated_data)
                
                category = serializer.save()
                print("\n=== After Save ===")
                print(f"Created category: {category}")
                print(f"Cuisine relationships: {list(category.cuisines.all())}")
                
                return Response(CategorySerializer(category).data, status=status.HTTP_201_CREATED)
            except Exception as e:
                print(f"Error creating category: {str(e)}")
                return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        
        print("Validation errors:", serializer.errors)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class SubcategoryView(APIView):
    def get(self, request):
        subcategories = Subcategory.objects.all()
        serializer = SubcategorySerializer(subcategories, many=True)
        return Response(serializer.data)

    def post(self, request):
        print("\n=== POST Request Data ===")
        print("Raw request data:", request.data)

        data = request.data.copy()

        # Handle cuisine_ids
        if 'category_ids' in data:
            try:
                category_ids = json.loads(data.get('category_ids', '[]'))
                data['category_ids'] = [int(id_) for id_ in category_ids if id_]
            except json.JSONDecodeError:
                data['category_ids'] = []

        serializer = SubcategorySerializer(data=data)
        if serializer.is_valid():
            try:
                print("\n=== Valid Data ===")
                print("Validated data:", serializer.validated_data)
                
                subcategory = serializer.save()
                print("\n=== After Save ===")
                print(f"Created subcategory: {subcategory}")
                print(f"Category relationships: {list(subcategory.categories.all())}")
                
                return Response(SubcategorySerializer(subcategory).data, status=status.HTTP_201_CREATED)
            except Exception as e:
                print(f"Error creating subcategory: {str(e)}")
                return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
            
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
