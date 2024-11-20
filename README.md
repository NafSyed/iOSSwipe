# Product Management App

This project is a simple **Product Management App** implemented as per the requirements. The app consists of two primary screens:

1. **Product Listing Screen**: Displays a list of products fetched from an API.  
2. **Add Product Screen**: Allows users to add new products via a user-friendly interface.

---

## Demo Video
You can view a demo of the app in action by clicking the link below:  
[Watch Demo Video](https://drive.google.com/file/d/12FBuO_H6XQB_MIekfhiNS2uWSVXRENCg/view?usp=sharing)

---

## Features Implemented

### **Screen 1: Product Listing**
- **Display Products**: Fetches and displays a list of products from the API.
- **Search Functionality**: Users can search for specific products by name.
- **Scrollable List**: The product list is scrollable for ease of navigation.
- **Default Image Handling**: If a product's image URL is empty, a default image is displayed.
- **Product Details**: Each product card includes:
  - Product Name
  - Product Type
  - Price
  - Tax
- **Favorite Products**: 
  - Users can mark products as favorites using a heart icon. 
  - Favorited products appear at the top of the list.
  - Favorite status is stored locally and persists between sessions.
- **Loading Indicator**: A progress bar is displayed while the product data is being fetched.
- **Navigation Button**: A button is provided to navigate to the **Add Product Screen**.

### **Screen 2: Add Product**
- **Product Type Selection**: Users can select the product type from a dropdown menu.
- **Input Fields**: Text fields to enter:
  - Product Name
  - Selling Price
  - Tax Rate
- **Image Upload**: Users can upload an optional image in JPEG or PNG format (1:1 ratio required).
- **Form Validation**: 
  - Product type selection is mandatory.
  - Product name cannot be empty.
  - Selling price and tax rate must be valid decimal numbers.
- **Submit Action**: 
  - The form data is submitted using the **POST** method to the API endpoint.
  - Clear feedback is provided to users on submission success or failure.
- **User-Friendly Interface**: Ensures a smooth and intuitive experience for users.

---

## API Integration

### **Fetch Products**  
- **Endpoint**: `https://app.getswipe.in/api/public/get`  
- **Method**: `GET`  
- **Expected Response**:  
  ```json
  [
    {
      "image": "https://example.com/image.png",
      "price": 1694.91,
      "product_name": "Sample Product",
      "product_type": "Product",
      "tax": 18.0
    },
    {
      "image": "https://example.com/image2.png",
      "price": 84745.76,
      "product_name": "Another Product",
      "product_type": "Service",
      "tax": 18.0
    }
  ]
