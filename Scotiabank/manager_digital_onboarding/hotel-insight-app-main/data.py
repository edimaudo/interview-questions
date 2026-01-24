from utils import *


# Load data
@st.cache_data
def load_data(DATA_URL):
    """Loads files based on file type (CSV only)."""
    data = pd.read_csv(DATA_URL, sep='|', skipinitialspace=True)
    return data

# Data
bookings_df = load_data("data/bookings.csv")
food_orders_df = load_data("data/food-orders.csv")
menu_df = load_data("data/menu.csv")
requests_df = load_data("data/requests.csv")
rooms_df = load_data("data/rooms.csv")

# Data Updates
# Convert date columns in bookings_df
bookings_df['start date'] = pd.to_datetime(bookings_df['start date'])
bookings_df['end date'] = pd.to_datetime(bookings_df['end date'])

# Convert date column in food_orders_df
food_orders_df['date'] = pd.to_datetime(food_orders_df['date'])

# Convert date columns in requests_df
requests_df['start date'] = pd.to_datetime(requests_df['start date'])
requests_df['end date'] = pd.to_datetime(requests_df['end date'])

# Function to correct year 1916 to 2016
def correct_year(dt):
    if dt.year == 1916:
        return dt.replace(year=2016)
    return dt

# Apply correction to bookings_df
bookings_df['start date'] = bookings_df['start date'].apply(correct_year)
bookings_df['end date'] = bookings_df['end date'].apply(correct_year)

# Apply correction to requests_df
requests_df['start date'] = requests_df['start date'].apply(correct_year)
requests_df['end date'] = requests_df['end date'].apply(correct_year)

# build unified booking dataset
bookings_requests_df = pd.merge(bookings_df, requests_df, on='request id', how='left')
bookings_requests_df['room_prefix'] = bookings_requests_df['room'].astype(str).str[0]
integrated_bookings_df = pd.merge(bookings_requests_df, rooms_df, left_on='room_prefix', right_on='prefix', how='left')
# Stay duration
integrated_bookings_df['stay_duration'] = (integrated_bookings_df['end date_x'] - integrated_bookings_df['start date_x']).dt.days
# Booking month
integrated_bookings_df['booking_month'] = integrated_bookings_df['start date_x'].dt.month_name()
# Total guest
integrated_bookings_df['total_guests'] = integrated_bookings_df['#adults'] + integrated_bookings_df['#children']
# Booking revenue
integrated_bookings_df['booking_revenue'] = integrated_bookings_df['stay_duration'] * integrated_bookings_df['price/day']

# filters
month_list = integrated_bookings_df['booking_month'].unique().tolist()
room_type_list = integrated_bookings_df['room type'].unique().tolist()
request_type_list = integrated_bookings_df['request type'].unique().tolist()

# Integrated food order
integrated_food_orders_df = pd.merge(food_orders_df, menu_df, left_on='menu id', right_on='id', how='left')
integrated_food_orders_df['order_value'] = integrated_food_orders_df['#orders'] * integrated_food_orders_df['price']
