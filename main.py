import pandas as pd

customers = pd.read_csv('Data/olist_customers_dataset.csv')
geolocation = pd.read_csv('Data/olist_geolocation_dataset.csv')
order_items = pd.read_csv('Data/olist_order_items_dataset.csv')
order_payments = pd.read_csv('Data/olist_payments_dataset.csv')
order_reviews = pd.read_csv('Data/olist_order_reviews_dataset.csv')
orders = pd.read_csv('Data/olist_orders_dataset.csv')
products = pd.read_csv('Data/olist_products_dataset.csv')
sellers = pd.read_csv('Data/olist_sellers_dataset.csv')
product_translations = pd.read_csv('Data/product_category_name_translation.csv')