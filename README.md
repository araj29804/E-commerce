# untitled

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Features
    User Authentication: Sign in and sign up using email and password.
    Product Browsing: Browse products by categories.
    Product Details: View detailed information about products, including price, description, and images.
    Add to Cart: Add products to the cart and view them on a separate cart page.
    Smooth UI/UX: Clean and user-friendly interface with form validation and feedback.

# API Integration
    This app uses the Fake Store API for fetching product data. The API is easy to use and returns data
    in JSON format.
    
    Example API Endpoints:
    Get all products: https://fakestoreapi.in/api/products
    Get product by ID: https://fakestoreapi.in/api/products/{id}
    Get products by category: https://fakestoreapi.in/api/products/category?type={category}
    Firebase Authentication
    The app uses Firebase Authentication for user sign-up and sign-in. You can extend it by adding more
    authentication providers (Google, Facebook, etc.).

# UI/UX Details
    Sign In/Sign Up Form
    The form includes validation for both email and password fields.
    Passwords must be at least 6 characters long.
    Error messages are displayed for invalid inputs.
    Product Listing
    Products are displayed in a list format with a clean and simple design.
    Each product can be clicked to view more details.

# Product Details
    Includes product title, description, price, and image.
    Users can add the product to the cart from this page.

# Cart
    Shows all products added to the cart.
    Users can proceed to checkout or continue shopping.

# Dependencies
    http: For making API requests.
    firebase_auth: For Firebase authentication.
    provider: For state management.
    flutter_svg: For rendering SVG images.
    flutter_form_builder: For building forms with validation.

# clone this project url
    git clone https://github.com/araj29804/E-commerce
