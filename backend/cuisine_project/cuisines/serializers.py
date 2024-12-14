from rest_framework import serializers
from .models import Cuisine, Category, Subcategory

class CuisineSerializer(serializers.ModelSerializer):
    category_ids = serializers.ListField(
        child=serializers.ListField(child=serializers.IntegerField()), 
        write_only=True, 
        required=False, 
        default=[]
    )
    categories = serializers.SerializerMethodField()

    class Meta:
        model = Cuisine
        fields = ['id', 'cuisine_title', 'image', 'category_ids', 'categories']

    def get_categories(self, obj):
        return [{'id': category.id, 'category_title': category.category_title} for category in obj.categories.all()]

    def create(self, validated_data):
        print(f"validated_data: {validated_data}")
        category_ids = validated_data.pop('category_ids', [])
        category_ids = category_ids[0]
        cuisine = Cuisine.objects.create(**validated_data)
        cuisine.categories.set(category_ids)
        return cuisine

class CategorySerializer(serializers.ModelSerializer):
    subcategory_ids = serializers.ListField(
        child=serializers.ListField(child=serializers.IntegerField()),
        write_only=True,
        required=False,
        allow_empty=True,
        default=[]
    )
    cuisine_ids = serializers.ListField(
        child=serializers.ListField(child=serializers.IntegerField()),
        write_only=True,
        required=False,
        allow_empty=True,
        default=[]
    )
    cuisines = CuisineSerializer(many=True, read_only=True)
    subcategories = serializers.SerializerMethodField()

    class Meta:
        model = Category
        fields = ['id', 'category_title', 'image', 'subcategory_ids', 'cuisine_ids', 'cuisines', 'subcategories']

    def get_subcategories(self, obj):
        return [{'id': subcategory.id, 'subcategory_title': subcategory.subcategory_title} for subcategory in obj.subcategories.all()]

    def get_cuisine_ids(self, obj):
        return [cuisine.id for cuisine in obj.cuisines.all()]
    
    def convert_to_int_list(self, string_list):
        """Convert a list of strings to a list of integers"""
        try:
            return [int(x) for x in string_list if x]
        except (ValueError, TypeError):
            return []

    def create(self, validated_data):
        print(validated_data)
        print("Creating category with data:", validated_data)  # Debug print
        subcategory_ids = validated_data.pop('subcategory_ids', [])
        subcategory_ids = subcategory_ids[0]
        cuisine_ids = validated_data.pop('cuisine_ids', [])
        cuisine_ids = cuisine_ids[0]
        category = Category.objects.create(**validated_data)
        print(f"Setting cuisine_ids: {cuisine_ids}")  # Debug print

        category.cuisines.set(cuisine_ids)
        print(f"Cuisine relationships: {list(category.cuisines.all())}")  # Debug print
        category.subcategories.set(subcategory_ids)
        
        return category

    def to_representation(self, instance):
        # Add this method to ensure cuisines are included
        representation = super().to_representation(instance)
        representation['cuisines'] = CuisineSerializer(instance.cuisines.all(), many=True).data
        return representation
    

class SubcategorySerializer(serializers.ModelSerializer):
    category_ids = serializers.ListField(
        child=serializers.ListField(child=serializers.IntegerField()), 
        write_only=True, 
        required=False, 
        default=[]
    )
    categories = CategorySerializer(many=True, read_only=True)

    class Meta:
        model = Subcategory
        fields = ['id', 'subcategory_title', 'image', 'category_ids', 'categories']

    def convert_to_int_list(self, string_list):
        """Convert a list of strings to a list of integers"""
        try:
            return [int(x) for x in string_list if x]
        except (ValueError, TypeError):
            return []

    def create(self, validated_data):
        print(validated_data)
        print("Creating category with data:", validated_data)  # Debug print

        category_ids = validated_data.pop('category_ids', [])
        category_ids = category_ids[0]
        subcategory = Subcategory.objects.create(**validated_data)
        print(f"Setting category_ids: {category_ids}")  # Debug print

        subcategory.categories.set(category_ids)
        print(f"Category relationships: {list(subcategory.categories.all())}")  # Debug print
        return subcategory
    
    def to_representation(self, instance):
        # Add this method to ensure cuisines are included
        representation = super().to_representation(instance)
        representation['categories'] = CategorySerializer(instance.categories.all(), many=True).data
        return representation